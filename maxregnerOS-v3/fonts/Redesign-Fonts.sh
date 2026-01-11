# maxregnerOS 3.0 Font Redesign
# Installs custom maxregnerOS font family

LOG_BEGIN "Installing maxregnerOS 3.0 Fonts"

# Font directory
FONT_DIR="$WORKSPACE/system/system/fonts"
mkdir -p "$FONT_DIR"

# Enable custom fonts
FF "MAXREGNEROS_V3_FONTS_ENABLED" "TRUE"
FF "MAXREGNEROS_V3_FONTS_SANS" "TRUE"
FF "MAXREGNEROS_V3_FONTS_MONO" "TRUE"
FF "MAXREGNEROS_V3_FONTS_DISPLAY" "TRUE"

# System properties
BPROP "system" "ro.maxregneros.v3.fonts.enabled" "true"
BPROP "system" "ro.maxregneros.v3.fonts.family" "maxregnerOS"
BPROP "system" "ro.maxregneros.v3.fonts.version" "3.0.0"

# Font specifications
BPROP "system" "ro.maxregneros.v3.fonts.sans.name" "maxregnerOS Sans"
BPROP "system" "ro.maxregneros.v3.fonts.mono.name" "maxregnerOS Mono"
BPROP "system" "ro.maxregneros.v3.fonts.display.name" "maxregnerOS Display"

# Font files (should be placed in fonts directory)
# maxregnerOS-Sans-Regular.ttf
# maxregnerOS-Sans-Medium.ttf
# maxregnerOS-Sans-Bold.ttf
# maxregnerOS-Mono-Regular.ttf
# maxregnerOS-Display-Regular.ttf

# Create font configuration
cat > "$WORKSPACE/system/system/etc/fonts_maxregneros.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<familyset>
    <family>
        <fileset>
            <file>maxregnerOS-Sans-Regular.ttf</file>
            <file>maxregnerOS-Sans-Medium.ttf</file>
            <file>maxregnerOS-Sans-Bold.ttf</file>
        </fileset>
    </family>
    <family>
        <fileset>
            <file>maxregnerOS-Mono-Regular.ttf</file>
        </fileset>
    </family>
    <family>
        <fileset>
            <file>maxregnerOS-Display-Regular.ttf</file>
        </fileset>
    </family>
</familyset>
EOF

# Update system font configuration
FONTS_CONFIG="$WORKSPACE/system/system/etc/fonts.xml"
if [ -f "$FONTS_CONFIG" ]; then
    # Add maxregnerOS fonts to system font list
    # This would require XML manipulation
    LOG_INFO "Font configuration will be updated during APK patching"
fi

LOG_END "maxregnerOS fonts configured (font files need to be placed)"
