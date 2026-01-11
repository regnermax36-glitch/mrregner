#!/bin/bash
# maxregnerOS 3.0 Magisk Module Builder
# Builds actual Magisk module from workspace

LOG_BEGIN "Building maxregnerOS 3.0 Magisk Module"

# Module structure
MODULE_DIR="$DIROUT/maxregnerOS-v3"
MODULE_ZIP="$DIROUT/maxregnerOS-v3-${CODENAME}-$(date +%Y%m%d-%H%M%S).zip"

# Clean and create module directory
rm -rf "$MODULE_DIR"
mkdir -p "$MODULE_DIR/META-INF/com/google/android"
mkdir -p "$MODULE_DIR/system/{fonts,media/{icons,animations},framework,priv-app,bin,etc/init}"

# Copy Magisk module files
cp "$SCRPATH/magisk/module.prop" "$MODULE_DIR/"
cp "$SCRPATH/magisk/customize.sh" "$MODULE_DIR/"
chmod 755 "$MODULE_DIR/customize.sh"

# Create update-binary (Magisk template)
cat > "$MODULE_DIR/META-INF/com/google/android/update-binary" << 'EOF'
#!/system/bin/sh
##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################

##########################################################################################
# Preparation
##########################################################################################

# This will be set to true if we're running in a Magisk environment
[ -z $MAGISK_VER ] && MAGISK_VER=""
[ -z $MAGISK_VER_CODE ] && MAGISK_VER_CODE=0

# Detect Magisk version
[ -f /data/adb/magisk/util_functions.sh ] && . /data/adb/magisk/util_functions.sh

# Default permissions
umask 022

##########################################################################################
# Installation
##########################################################################################

ui_print " "
ui_print "╔═══════════════════════════════════════╗"
ui_print "║      maxregnerOS 3.0 Installer       ║"
ui_print "║   10,000x More Special Redesign      ║"
ui_print "╚═══════════════════════════════════════╝"
ui_print " "

# Extract files
ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2

# Run customize script
[ -f "$MODPATH/customize.sh" ] && . "$MODPATH/customize.sh"

# Set permissions
ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0755 0644

ui_print " "
ui_print "✓ Installation complete!"
ui_print " "
ui_print "Reboot to apply maxregnerOS 3.0 redesign"
ui_print " "
EOF

chmod 755 "$MODULE_DIR/META-INF/com/google/android/update-binary"

# Create updater-script
cat > "$MODULE_DIR/META-INF/com/google/android/updater-script" << 'EOF'
#MAGISK
EOF

# Copy only changed/modified files (delta system)
LOG_BEGIN "Copying modified files"

# Debug: Show what exists in workspace
LOG_INFO "Checking workspace for maxregnerOS v3 files..."
LOG_INFO "Workspace: $WORKSPACE"
if [ -d "$WORKSPACE/system/system" ]; then
    LOG_INFO "Workspace system directory exists"
    find "$WORKSPACE/system/system" -type d -name "*maxregner*" -o -name "*maxregnerOS*" 2>/dev/null | head -10 | while read -r dir; do
        LOG_INFO "Found directory: $dir"
    done
    find "$WORKSPACE/system/system" -type f -name "*maxregner*" -o -name "*maxregnerOS*" 2>/dev/null | head -10 | while read -r file; do
        LOG_INFO "Found file: $file"
    done
else
    LOG_WARN "Workspace system directory not found: $WORKSPACE/system/system"
fi

# Icons
ICON_SOURCE="$WORKSPACE/system/system/media/icons/maxregneros-v3"
if [ -d "$ICON_SOURCE" ] && [ -n "$(find "$ICON_SOURCE" -type f 2>/dev/null | head -1)" ]; then
    mkdir -p "$MODULE_DIR/system/media/icons"
    cp -r "$ICON_SOURCE" "$MODULE_DIR/system/media/icons/" 2>/dev/null || true
    ICON_COUNT=$(find "$MODULE_DIR/system/media/icons/maxregneros-v3" -type f 2>/dev/null | wc -l)
    LOG_INFO "Icons copied ($ICON_COUNT files)"
else
    LOG_WARN "Icons directory not found or empty: $ICON_SOURCE"
    # Try alternative location
    if [ -d "$WORKSPACE/system/system/media/icons/maxregnerOS-v3" ]; then
        mkdir -p "$MODULE_DIR/system/media/icons"
        cp -r "$WORKSPACE/system/system/media/icons/maxregnerOS-v3" "$MODULE_DIR/system/media/icons/" 2>/dev/null || true
        ICON_COUNT=$(find "$MODULE_DIR/system/media/icons/maxregnerOS-v3" -type f 2>/dev/null | wc -l)
        LOG_INFO "Icons copied from alternative location ($ICON_COUNT files)"
    fi
fi

# Fonts
FONT_SOURCE="$WORKSPACE/system/system/fonts"
if [ -d "$FONT_SOURCE" ]; then
    mkdir -p "$MODULE_DIR/system/fonts"
    FONT_COUNT=0
    # Copy maxregneros fonts
    while IFS= read -r font_file; do
        if [ -f "$font_file" ]; then
            cp "$font_file" "$MODULE_DIR/system/fonts/" 2>/dev/null && ((FONT_COUNT++)) || true
        fi
    done < <(find "$FONT_SOURCE" -name "*maxregneros*" -o -name "*maxregnerOS*" -type f 2>/dev/null)
    
    if [ "$FONT_COUNT" -gt 0 ]; then
        LOG_INFO "Fonts copied ($FONT_COUNT files)"
    else
        LOG_WARN "No maxregnerOS fonts found in $FONT_SOURCE"
    fi
    
    # Copy font config if exists
    if [ -f "$WORKSPACE/system/system/etc/fonts_maxregneros.xml" ]; then
        mkdir -p "$MODULE_DIR/system/etc"
        cp "$WORKSPACE/system/system/etc/fonts_maxregneros.xml" "$MODULE_DIR/system/etc/" 2>/dev/null || true
        LOG_INFO "Font configuration copied"
    fi
else
    LOG_WARN "Fonts directory not found: $FONT_SOURCE"
fi

# Animations
ANIM_SOURCE="$WORKSPACE/system/system/media/animations/maxregnerOS-v3"
if [ -d "$ANIM_SOURCE" ] && [ -n "$(find "$ANIM_SOURCE" -type f 2>/dev/null | head -1)" ]; then
    mkdir -p "$MODULE_DIR/system/media/animations"
    cp -r "$ANIM_SOURCE" "$MODULE_DIR/system/media/animations/" 2>/dev/null || true
    ANIM_COUNT=$(find "$MODULE_DIR/system/media/animations/maxregnerOS-v3" -type f 2>/dev/null | wc -l)
    LOG_INFO "Animations copied ($ANIM_COUNT files)"
else
    LOG_WARN "Animations directory not found or empty: $ANIM_SOURCE"
    # Try alternative location
    if [ -d "$WORKSPACE/system/system/media/animations/maxregneros-v3" ]; then
        mkdir -p "$MODULE_DIR/system/media/animations"
        cp -r "$WORKSPACE/system/system/media/animations/maxregneros-v3" "$MODULE_DIR/system/media/animations/" 2>/dev/null || true
        ANIM_COUNT=$(find "$MODULE_DIR/system/media/animations/maxregneros-v3" -type f 2>/dev/null | wc -l)
        LOG_INFO "Animations copied from alternative location ($ANIM_COUNT files)"
    fi
fi

# Framework modifications (only if modified)
if [ -f "$WORKSPACE/system/system/framework/framework.jar" ]; then
    # Check if framework was modified (has maxregnerOS patches)
    if strings "$WORKSPACE/system/system/framework/framework.jar" 2>/dev/null | grep -q "maxregnerOS"; then
        mkdir -p "$MODULE_DIR/system/framework"
        cp "$WORKSPACE/system/system/framework/framework.jar" "$MODULE_DIR/system/framework/" 2>/dev/null || true
        LOG_INFO "Framework copied"
    else
        LOG_INFO "Framework.jar exists but not modified (no maxregnerOS patches detected)"
    fi
else
    LOG_INFO "Framework.jar not found in workspace"
fi

# APK modifications (Settings, SystemUI, Launcher)
APK_COPIED=0
for apk_name in SecSettings SystemUI Launcher3; do
    apk_path="$WORKSPACE/system/system/priv-app/$apk_name/$apk_name.apk"
    if [ -f "$apk_path" ]; then
        # Check if APK was modified - try multiple methods
        MODIFIED=false
        if unzip -l "$apk_path" 2>/dev/null | grep -qi "maxregneros\|maxregnerOS"; then
            MODIFIED=true
        elif strings "$apk_path" 2>/dev/null | grep -qi "maxregneros\|maxregnerOS"; then
            MODIFIED=true
        fi
        
        if [ "$MODIFIED" = "true" ]; then
            mkdir -p "$MODULE_DIR/system/priv-app/$apk_name"
            cp "$apk_path" "$MODULE_DIR/system/priv-app/$apk_name/" 2>/dev/null && {
                LOG_INFO "APK copied: $apk_name"
                ((APK_COPIED++))
            } || LOG_WARN "Failed to copy APK: $apk_name"
        else
            LOG_INFO "APK not modified: $apk_name"
        fi
    else
        LOG_INFO "APK not found: $apk_path"
    fi
done

if [ "$APK_COPIED" -eq 0 ]; then
    LOG_WARN "No APKs were copied (they may not be modified yet)"
fi

# Binaries
if [ -d "$WORKSPACE/system/system/bin" ]; then
    find "$WORKSPACE/system/system/bin" -name "*maxregneros*" -type f -exec cp {} "$MODULE_DIR/system/bin/" \; 2>/dev/null || true
fi

# Init scripts
if [ -f "$WORKSPACE/system/system/etc/init/maxregneros-services.rc" ]; then
    cp "$WORKSPACE/system/system/etc/init/maxregneros-services.rc" "$MODULE_DIR/system/etc/init/" 2>/dev/null || true
fi

# Service script
if [ -f "$SCRPATH/magisk/service.sh" ]; then
    mkdir -p "$MODULE_DIR/system/etc"
    cp "$SCRPATH/magisk/service.sh" "$MODULE_DIR/system/etc/" 2>/dev/null || true
    chmod 755 "$MODULE_DIR/system/etc/service.sh" 2>/dev/null || true
fi

# Verify files were copied
TOTAL_FILES=$(find "$MODULE_DIR" -type f 2>/dev/null | wc -l)
if [ "$TOTAL_FILES" -lt 5 ]; then
    LOG_WARN "Very few files in module ($TOTAL_FILES files). Module may be empty."
    LOG_WARN "Checking what exists in workspace..."
    LOG_WARN "Icons: $([ -d "$WORKSPACE/system/system/media/icons/maxregneros-v3" ] && find "$WORKSPACE/system/system/media/icons/maxregneros-v3" -type f 2>/dev/null | wc -l || echo 0) files"
    LOG_WARN "Fonts: $([ -d "$WORKSPACE/system/system/fonts" ] && find "$WORKSPACE/system/system/fonts" -name "*maxregneros*" -type f 2>/dev/null | wc -l || echo 0) files"
    LOG_WARN "Animations: $([ -d "$WORKSPACE/system/system/media/animations/maxregnerOS-v3" ] && find "$WORKSPACE/system/system/media/animations/maxregnerOS-v3" -type f 2>/dev/null | wc -l || echo 0) files"
else
    LOG_INFO "Total files in module: $TOTAL_FILES"
fi

LOG_END "Files copied"

# Create ZIP
LOG_BEGIN "Creating Magisk module ZIP"

cd "$MODULE_DIR"
zip -r "$MODULE_ZIP" . -q -x "*.git*" "*.DS_Store*"
cd "$ASTROROM"

MODULE_SIZE=$(du -h "$MODULE_ZIP" | cut -f1)
MODULE_SIZE_BYTES=$(stat -f%z "$MODULE_ZIP" 2>/dev/null || stat -c%s "$MODULE_ZIP" 2>/dev/null || echo "0")
LOG_END "Magisk module created: $MODULE_ZIP ($MODULE_SIZE, ${MODULE_SIZE_BYTES} bytes)"

if [ "$MODULE_SIZE_BYTES" -lt 10000 ]; then
    LOG_WARN "Module is very small (${MODULE_SIZE_BYTES} bytes). It may be empty or missing files."
fi

echo ""
echo -e "${GREEN}✓${NC} maxregnerOS 3.0 Magisk Module built successfully"
echo -e "  ${BOLD}Location:${NC} $MODULE_ZIP"
echo -e "  ${BOLD}Size:${NC} $MODULE_SIZE"
echo ""
echo -e "Install via: Magisk Manager → Modules → Install from storage"
echo ""
