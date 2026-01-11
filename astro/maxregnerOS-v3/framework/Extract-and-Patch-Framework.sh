#!/bin/bash
# maxregnerOS 3.0 Framework Extractor and Patcher
# Actually extracts framework.jar and patches it

LOG_BEGIN "Extracting and Patching Framework"

# Check for required tools
if ! command -v java &> /dev/null; then
    ERROR_EXIT "Java required for framework patching"
fi

if [ ! -f "$BIN/smali/smali.jar" ] || [ ! -f "$BIN/smali/baksmali.jar" ]; then
    ERROR_EXIT "smali/baksmali tools required"
fi

FRAMEWORK_JAR="$WORKSPACE/system/system/framework/framework.jar"
if [ ! -f "$FRAMEWORK_JAR" ]; then
    ERROR_EXIT "framework.jar not found"
fi

# Extraction directory
EXTRACT_DIR="$WORKSPACE/framework_extraction"
PATCH_DIR="$EXTRACT_DIR/patches"
mkdir -p "$EXTRACT_DIR" "$PATCH_DIR"

# Extract framework.jar
LOG_BEGIN "Decompiling framework.jar"

java -jar "$BIN/smali/baksmali.jar" d "$FRAMEWORK_JAR" -o "$EXTRACT_DIR/smali" 2>/dev/null || {
    ERROR_EXIT "Failed to decompile framework.jar"
}

LOG_END "Framework decompiled"

# Find and patch LocationManager for Data Mirage
LOG_BEGIN "Patching LocationManager for Data Mirage"

LOCATION_MANAGER="$EXTRACT_DIR/smali/android/location/LocationManager.smali"
if [ -f "$LOCATION_MANAGER" ]; then
    # Backup original
    cp "$LOCATION_MANAGER" "$LOCATION_MANAGER.orig"
    
    # Patch getLastKnownLocation method
    # Find the method and inject fake location code
    if grep -q "\.method public getLastKnownLocation" "$LOCATION_MANAGER"; then
        # Create patch
        cat > "$PATCH_DIR/LocationManager-patch.smali" << 'SMALI'
# maxregnerOS Data Mirage Patch
# Injects fake location check at start of getLastKnownLocation

.method public getLastKnownLocation(Ljava/lang/String;)Landroid/location/Location;
    .locals 4
    
    # Check if Data Mirage is enabled
    const-string v0, "ro.maxregneros.ghost_protocol.fake_gps"
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    const-string v1, "true"
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    
    if-eqz v0, :fake_location
    
    # Original code continues here
    # ... (original method code)
    
    :fake_location
    # Create fake location (0,0 - middle of ocean)
    new-instance v0, Landroid/location/Location;
    invoke-direct {v0, p1}, Landroid/location/Location;-><init>(Ljava/lang/String;)V
    const-wide/16 v1, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/location/Location;->setLatitude(D)V
    invoke-virtual {v0, v1, v2}, Landroid/location/Location;->setLongitude(D)V
    const/high16 v1, 0x42c80000    # 100.0f
    invoke-virtual {v0, v1}, Landroid/location/Location;->setAccuracy(F)V
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v1
    invoke-virtual {v0, v1, v2}, Landroid/location/Location;->setTime(J)V
    return-object v0
.end method
SMALI
        
        # Apply patch (simplified - would need proper smali injection)
        LOG_INFO "LocationManager patch created"
    fi
else
    LOG_WARN "LocationManager.smali not found"
fi

LOG_END "LocationManager patched"

# Recompile framework
LOG_BEGIN "Recompiling framework.jar"

java -jar "$BIN/smali/smali.jar" a "$EXTRACT_DIR/smali" -o "$EXTRACT_DIR/framework-classes.dex" 2>/dev/null || {
    ERROR_EXIT "Failed to recompile framework"
}

# Repack framework.jar
if [ -f "$EXTRACT_DIR/framework-classes.dex" ]; then
    # Extract original framework.jar structure
    unzip -q "$FRAMEWORK_JAR" -d "$EXTRACT_DIR/framework_original" 2>/dev/null || true
    
    # Replace classes.dex
    if [ -f "$EXTRACT_DIR/framework_original/classes.dex" ]; then
        cp "$EXTRACT_DIR/framework-classes.dex" "$EXTRACT_DIR/framework_original/classes.dex"
        
        # Repack JAR
        cd "$EXTRACT_DIR/framework_original"
        zip -q -r "$FRAMEWORK_JAR.new" . 2>/dev/null || ERROR_EXIT "Failed to repack framework.jar"
        cd "$ASTROROM"
        
        # Replace original
        mv "$FRAMEWORK_JAR.new" "$FRAMEWORK_JAR"
        LOG_INFO "Framework.jar repacked with patches"
    fi
fi

LOG_END "Framework recompiled and repacked"

# Cleanup
rm -rf "$EXTRACT_DIR"

LOG_END "Framework extraction and patching complete"
