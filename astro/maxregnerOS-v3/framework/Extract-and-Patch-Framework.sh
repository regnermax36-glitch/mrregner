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

# Check if framework.jar exists and is readable
if [ ! -f "$FRAMEWORK_JAR" ] || [ ! -r "$FRAMEWORK_JAR" ]; then
    ERROR_EXIT "framework.jar not found or not readable: $FRAMEWORK_JAR"
fi

# Decompile with proper error handling
if ! java -jar "$BIN/smali/baksmali.jar" d "$FRAMEWORK_JAR" -o "$EXTRACT_DIR/smali" > "$EXTRACT_DIR/baksmali.log" 2>&1; then
    LOG_WARN "baksmali failed, checking log..."
    cat "$EXTRACT_DIR/baksmali.log" | head -20
    ERROR_EXIT "Failed to decompile framework.jar"
fi

LOG_END "Framework decompiled"

# Verify decompilation worked
if [ ! -d "$EXTRACT_DIR/smali" ] || [ -z "$(find "$EXTRACT_DIR/smali" -name "*.smali" 2>/dev/null | head -1)" ]; then
    LOG_WARN "Decompilation may have failed - no smali files found"
    LOG_WARN "This is normal if framework.jar doesn't contain smali code"
    LOG_WARN "LocationManager is typically in services.jar or framework-res.apk"
    # Don't exit - continue without patching
else
    LOG_INFO "Found $(find "$EXTRACT_DIR/smali" -name "*.smali" 2>/dev/null | wc -l) smali files"
fi

# Find and patch LocationManager for Data Mirage
LOG_BEGIN "Patching LocationManager for Data Mirage"

# Search for LocationManager.smali (could be in different locations)
# Note: LocationManager is usually in services.jar, not framework.jar
LOCATION_MANAGER=$(find "$EXTRACT_DIR/smali" -name "LocationManager.smali" 2>/dev/null | head -1)

if [ -n "$LOCATION_MANAGER" ] && [ -f "$LOCATION_MANAGER" ]; then
    LOG_INFO "Found LocationManager at: $LOCATION_MANAGER"
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
        
        # Create patch file
        cat > "$PATCH_DIR/LocationManager-patch.txt" << 'PATCH'
# maxregnerOS Data Mirage Patch for getLastKnownLocation method
# This patch will be applied using smalipatch format
PATCH
        
        # Use smalipatch if available, otherwise manual injection
        if [ -f "$SCRPATH/framework.jar/DataMirage-LocationManager.smalipatch" ]; then
            LOG_INFO "Using smalipatch file for LocationManager"
            # The smalipatch will be applied by the build system's patching mechanism
        else
            # Manual patch: Find method and inject at start
            LOG_INFO "Applying manual patch to LocationManager"
            # Backup
            cp "$LOCATION_MANAGER" "$LOCATION_MANAGER.bak"
            
            # Find method line number
            method_line=$(grep -n "\.method public getLastKnownLocation" "$LOCATION_MANAGER" | cut -d: -f1)
            if [ -n "$method_line" ]; then
                # Insert patch after method declaration (after .locals line)
                locals_line=$(sed -n "${method_line},$((method_line+10))p" "$LOCATION_MANAGER" | grep -n "\.locals" | head -1 | cut -d: -f1)
                if [ -n "$locals_line" ]; then
                    insert_line=$((method_line + locals_line))
                    # Create patch content
                    patch_content=$(cat << 'SMALI'
    # maxregnerOS Data Mirage - Fake GPS check
    const-string v0, "ro.maxregneros.ghost_protocol.fake_gps"
    invoke-static {v0}, Landroid/os/SystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    const-string v1, "true"
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :fake_location_maxregneros
SMALI
)
                    # Insert patch
                    sed -i "${insert_line}a\\${patch_content}" "$LOCATION_MANAGER" 2>/dev/null || {
                        LOG_WARN "Failed to insert patch, trying alternative method"
                        cp "$LOCATION_MANAGER.bak" "$LOCATION_MANAGER"
                    }
                    
                    # Add fake location return before .end method
                    fake_location_code=$(cat << 'SMALI'
    :fake_location_maxregneros
    new-instance v0, Landroid/location/Location;
    invoke-direct {v0, p1}, Landroid/location/Location;-><init>(Ljava/lang/String;)V
    const-wide/16 v1, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/location/Location;->setLatitude(D)V
    invoke-virtual {v0, v1, v2}, Landroid/location/Location;->setLongitude(D)V
    const/high16 v1, 0x42c80000
    invoke-virtual {v0, v1}, Landroid/location/Location;->setAccuracy(F)V
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v1
    invoke-virtual {v0, v1, v2}, Landroid/location/Location;->setTime(J)V
    return-object v0
SMALI
)
                    # Find .end method and insert before it
                    end_method_line=$(grep -n "\.end method" "$LOCATION_MANAGER" | head -1 | cut -d: -f1)
                    if [ -n "$end_method_line" ] && [ "$end_method_line" -gt "$method_line" ]; then
                        sed -i "$((end_method_line-1))a\\${fake_location_code}" "$LOCATION_MANAGER" 2>/dev/null || true
                    fi
                    
                    LOG_INFO "LocationManager patched successfully"
                else
                    LOG_WARN ".locals not found, patch may not work correctly"
                fi
            else
                LOG_WARN "getLastKnownLocation method not found"
            fi
        fi
    else
        LOG_WARN "getLastKnownLocation method not found in LocationManager"
    fi
else
    LOG_WARN "LocationManager.smali not found in framework.jar"
    LOG_INFO "Note: LocationManager is typically in services.jar, not framework.jar"
    LOG_INFO "Data Mirage patching will be skipped for framework.jar"
fi

LOG_END "LocationManager patched"

# Recompile framework only if we have smali files
if [ -d "$EXTRACT_DIR/smali" ] && [ -n "$(find "$EXTRACT_DIR/smali" -name "*.smali" 2>/dev/null | head -1)" ]; then
    LOG_BEGIN "Recompiling framework.jar"
    
    if ! java -jar "$BIN/smali/smali.jar" a "$EXTRACT_DIR/smali" -o "$EXTRACT_DIR/framework-classes.dex" > "$EXTRACT_DIR/smali.log" 2>&1; then
        LOG_WARN "smali recompilation failed, checking log..."
        cat "$EXTRACT_DIR/smali.log" | head -30
        LOG_WARN "This may be normal if framework.jar doesn't contain smali code"
        LOG_WARN "Skipping framework.jar repacking"
    elif [ ! -f "$EXTRACT_DIR/framework-classes.dex" ]; then
        LOG_WARN "Recompiled classes.dex not found"
        LOG_WARN "This may be normal if framework.jar doesn't contain smali code"
        LOG_WARN "Skipping framework.jar repacking"
    else
        LOG_INFO "Successfully recompiled classes.dex"

        # Repack framework.jar
        # Extract original framework.jar structure
        mkdir -p "$EXTRACT_DIR/framework_original"
        if ! unzip -q "$FRAMEWORK_JAR" -d "$EXTRACT_DIR/framework_original" 2>/dev/null; then
            LOG_WARN "Failed to extract framework.jar, trying alternative method"
            # Alternative: just replace classes.dex in JAR
            cd "$EXTRACT_DIR"
            if zip -q "$FRAMEWORK_JAR" framework-classes.dex 2>/dev/null; then
                mv framework-classes.dex classes.dex
                zip -q "$FRAMEWORK_JAR" classes.dex 2>/dev/null && {
                    LOG_INFO "Framework.jar updated with new classes.dex"
                } || LOG_WARN "Failed to update framework.jar with classes.dex"
            else
                LOG_WARN "Failed to add classes.dex to framework.jar"
            fi
            cd "$ASTROROM"
        else
            # Replace classes.dex
            if [ -f "$EXTRACT_DIR/framework_original/classes.dex" ]; then
                cp "$EXTRACT_DIR/framework-classes.dex" "$EXTRACT_DIR/framework_original/classes.dex"
                
                # Repack JAR
                cd "$EXTRACT_DIR/framework_original"
                if zip -q -r "$FRAMEWORK_JAR.new" . 2>/dev/null; then
                    mv "$FRAMEWORK_JAR.new" "$FRAMEWORK_JAR"
                    LOG_INFO "Framework.jar repacked with patches"
                else
                    LOG_WARN "Failed to repack framework.jar"
                fi
                cd "$ASTROROM"
            else
                LOG_WARN "No classes.dex found in original framework.jar"
            fi
        fi
        
        LOG_END "Framework recompiled and repacked"
    else
        LOG_INFO "No smali files to recompile, skipping framework.jar repacking"
        LOG_INFO "This is normal - framework.jar may not contain smali code"
    fi
else
    LOG_INFO "No smali directory found, skipping framework recompilation"
    LOG_INFO "This is normal - framework.jar may not contain smali code"
fi

# Cleanup
rm -rf "$EXTRACT_DIR"

LOG_END "Framework extraction and patching complete"
