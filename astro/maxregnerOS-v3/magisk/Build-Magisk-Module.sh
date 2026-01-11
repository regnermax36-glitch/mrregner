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

# Icons
if [ -d "$WORKSPACE/system/system/media/icons/maxregneros-v3" ]; then
    cp -r "$WORKSPACE/system/system/media/icons/maxregneros-v3" "$MODULE_DIR/system/media/icons/" 2>/dev/null || true
    LOG_INFO "Icons copied"
fi

# Fonts
if [ -d "$WORKSPACE/system/system/fonts" ]; then
    find "$WORKSPACE/system/system/fonts" -name "*maxregneros*" -type f -exec cp {} "$MODULE_DIR/system/fonts/" \; 2>/dev/null || true
    LOG_INFO "Fonts copied"
fi

# Animations
if [ -d "$WORKSPACE/system/system/media/animations/maxregnerOS-v3" ]; then
    cp -r "$WORKSPACE/system/system/media/animations/maxregnerOS-v3" "$MODULE_DIR/system/media/animations/" 2>/dev/null || true
    LOG_INFO "Animations copied"
fi

# Framework modifications (only if modified)
if [ -f "$WORKSPACE/system/system/framework/framework.jar" ]; then
    # Check if framework was modified (has maxregnerOS patches)
    if strings "$WORKSPACE/system/system/framework/framework.jar" 2>/dev/null | grep -q "maxregnerOS"; then
        mkdir -p "$MODULE_DIR/system/framework"
        cp "$WORKSPACE/system/system/framework/framework.jar" "$MODULE_DIR/system/framework/" 2>/dev/null || true
        LOG_INFO "Framework copied"
    fi
fi

# APK modifications (Settings, SystemUI, Launcher)
for apk_name in SecSettings SystemUI Launcher3; do
    apk_path="$WORKSPACE/system/system/priv-app/$apk_name/$apk_name.apk"
    if [ -f "$apk_path" ]; then
        # Check if APK was modified
        if unzip -l "$apk_path" 2>/dev/null | grep -q "maxregneros\|maxregnerOS"; then
            mkdir -p "$MODULE_DIR/system/priv-app/$apk_name"
            cp "$apk_path" "$MODULE_DIR/system/priv-app/$apk_name/" 2>/dev/null || true
            LOG_INFO "APK copied: $apk_name"
        fi
    fi
done

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

LOG_END "Files copied"

# Create ZIP
LOG_BEGIN "Creating Magisk module ZIP"

cd "$MODULE_DIR"
zip -r "$MODULE_ZIP" . -q -x "*.git*" "*.DS_Store*"
cd "$ASTROROM"

MODULE_SIZE=$(du -h "$MODULE_ZIP" | cut -f1)
LOG_END "Magisk module created: $MODULE_ZIP ($MODULE_SIZE)"

echo ""
echo -e "${GREEN}✓${NC} maxregnerOS 3.0 Magisk Module built successfully"
echo -e "  ${BOLD}Location:${NC} $MODULE_ZIP"
echo -e "  ${BOLD}Size:${NC} $MODULE_SIZE"
echo ""
echo -e "Install via: Magisk Manager → Modules → Install from storage"
echo ""
