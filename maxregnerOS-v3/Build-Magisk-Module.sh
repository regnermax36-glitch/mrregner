#!/bin/bash
# maxregnerOS 3.0 Magisk Module Builder
# Builds Magisk module instead of super.img

LOG_BEGIN "Building maxregnerOS 3.0 Magisk Module"

# Module directory
MODULE_DIR="$DIROUT/maxregnerOS-v3"
MODULE_ZIP="$DIROUT/maxregnerOS-v3-${CODENAME}-$(date +%Y%m%d).zip"

# Create module structure
mkdir -p "$MODULE_DIR/META-INF/com/google/android"
mkdir -p "$MODULE_DIR/system/{fonts,media,framework,bin,etc}"

# Copy Magisk module files
cp "$ASTROROM/maxregnerOS-v3/magisk/module.prop" "$MODULE_DIR/"
cp "$ASTROROM/maxregnerOS-v3/magisk/customize.sh" "$MODULE_DIR/"
cp "$ASTROROM/maxregnerOS-v3/magisk/service.sh" "$MODULE_DIR/system/etc/"

# Create update-binary (Magisk template)
cat > "$MODULE_DIR/META-INF/com/google/android/update-binary" << 'EOF'
#!/system/bin/sh
# Magisk module update-binary
# This is handled by Magisk Manager
EOF

# Create updater-script
cat > "$MODULE_DIR/META-INF/com/google/android/updater-script" << 'EOF'
#MAGISK
EOF

# Copy only changed files (delta system)
LOG_BEGIN "Creating delta package (changes only)"

# Icons
if [ -d "$WORKSPACE/system/system/media/icons" ]; then
    cp -r "$WORKSPACE/system/system/media/icons" "$MODULE_DIR/system/media/" 2>/dev/null || true
fi

# Fonts
if [ -d "$WORKSPACE/system/system/fonts" ]; then
    # Only copy maxregnerOS fonts
    find "$WORKSPACE/system/system/fonts" -name "*maxregneros*" -exec cp {} "$MODULE_DIR/system/fonts/" \; 2>/dev/null || true
fi

# Framework modifications (only changed files)
if [ -d "$WORKSPACE/system/system/framework" ]; then
    # Copy framework.jar if modified
    if [ -f "$WORKSPACE/system/system/framework/framework.jar" ]; then
        mkdir -p "$MODULE_DIR/system/framework"
        cp "$WORKSPACE/system/system/framework/framework.jar" "$MODULE_DIR/system/framework/" 2>/dev/null || true
    fi
fi

# APK modifications (Settings, SystemUI, Launcher)
for apk in SecSettings SystemUI Launcher3; do
    if [ -f "$WORKSPACE/system/system/priv-app/$apk/$apk.apk" ]; then
        mkdir -p "$MODULE_DIR/system/priv-app/$apk"
        cp "$WORKSPACE/system/system/priv-app/$apk/$apk.apk" "$MODULE_DIR/system/priv-app/$apk/" 2>/dev/null || true
    fi
done

# Binaries and services
if [ -d "$WORKSPACE/system/system/bin" ]; then
    find "$WORKSPACE/system/system/bin" -name "*maxregneros*" -exec cp {} "$MODULE_DIR/system/bin/" \; 2>/dev/null || true
fi

# Init scripts
if [ -f "$WORKSPACE/system/system/etc/init/maxregneros-services.rc" ]; then
    mkdir -p "$MODULE_DIR/system/etc/init"
    cp "$WORKSPACE/system/system/etc/init/maxregneros-services.rc" "$MODULE_DIR/system/etc/init/" 2>/dev/null || true
fi

LOG_END "Delta package created"

# Set permissions
chmod 755 "$MODULE_DIR/META-INF/com/google/android/update-binary"
chmod 755 "$MODULE_DIR/customize.sh"
chmod 755 "$MODULE_DIR/system/etc/service.sh"

# Create ZIP
LOG_BEGIN "Creating Magisk module ZIP"

cd "$MODULE_DIR"
zip -r "$MODULE_ZIP" . -q
cd "$ASTROROM"

MODULE_SIZE=$(du -h "$MODULE_ZIP" | cut -f1)
LOG_END "Magisk module created: $MODULE_ZIP ($MODULE_SIZE)"

echo ""
echo -e "${GREEN}✓${NC} maxregnerOS 3.0 Magisk Module built successfully"
echo -e "  ${BOLD}Location:${NC} $MODULE_ZIP"
echo -e "  ${BOLD}Size:${NC} $MODULE_SIZE"
echo ""
echo -e "Install via Magisk Manager → Modules → Install from storage"
echo ""
