#!/bin/bash
# maxregnerOS 3.0 Font Generator
# Processes and installs custom fonts

LOG_BEGIN "Installing maxregnerOS 3.0 Fonts"

FONT_DIR="$WORKSPACE/system/system/fonts"
mkdir -p "$FONT_DIR"

# Check for font tools
if ! command -v fontforge &> /dev/null; then
    LOG_WARN "FontForge not found. Using fallback method."
    USE_FONTFORGE=false
else
    USE_FONTFORGE=true
fi

# Font source directory (should contain TTF files)
SOURCE_FONTS="$SCRPATH/fonts-source"

# If source fonts exist, process them
if [ -d "$SOURCE_FONTS" ]; then
    LOG_BEGIN "Processing custom fonts"
    
    for font_file in "$SOURCE_FONTS"/*.ttf "$SOURCE_FONTS"/*.otf; do
        if [ -f "$font_file" ]; then
            font_name=$(basename "$font_file")
            
            # Rename to maxregnerOS convention
            if [[ "$font_name" == *"sans"* ]] || [[ "$font_name" == *"Sans"* ]]; then
                new_name="maxregnerOS-Sans-$(echo "$font_name" | grep -oE "(Regular|Medium|Bold|Light)" || echo "Regular").ttf"
            elif [[ "$font_name" == *"mono"* ]] || [[ "$font_name" == *"Mono"* ]]; then
                new_name="maxregnerOS-Mono-Regular.ttf"
            elif [[ "$font_name" == *"display"* ]] || [[ "$font_name" == *"Display"* ]]; then
                new_name="maxregnerOS-Display-Regular.ttf"
            else
                new_name="maxregnerOS-$(basename "$font_file")"
            fi
            
            # Copy font
            cp "$font_file" "$FONT_DIR/$new_name"
            LOG_INFO "Installed font: $new_name"
        fi
    done
    
    LOG_END "Fonts processed"
else
    # Create font configuration even without source fonts
    LOG_INFO "No source fonts found, creating font configuration"
fi

# Create font fallback configuration
cat > "$WORKSPACE/system/system/etc/fonts_maxregneros.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<familyset>
    <family name="maxregnerOS Sans">
        <font weight="300" style="normal">maxregnerOS-Sans-Light.ttf</font>
        <font weight="400" style="normal">maxregnerOS-Sans-Regular.ttf</font>
        <font weight="500" style="normal">maxregnerOS-Sans-Medium.ttf</font>
        <font weight="700" style="normal">maxregnerOS-Sans-Bold.ttf</font>
    </family>
    <family name="maxregnerOS Mono">
        <font weight="400" style="normal">maxregnerOS-Mono-Regular.ttf</font>
    </family>
    <family name="maxregnerOS Display">
        <font weight="400" style="normal">maxregnerOS-Display-Regular.ttf</font>
    </family>
</familyset>
EOF

# Set system property to use maxregnerOS fonts
BPROP "system" "ro.maxregneros.v3.fonts.primary" "maxregnerOS Sans"
BPROP "system" "ro.maxregneros.v3.fonts.mono" "maxregnerOS Mono"
BPROP "system" "ro.maxregneros.v3.fonts.display" "maxregnerOS Display"

# Update system font configuration
FONTS_CONFIG="$WORKSPACE/system/system/etc/fonts.xml"
if [ -f "$FONTS_CONFIG" ]; then
    # Add maxregnerOS fonts to system font list
    # This is done via XML patching in APK tools
    LOG_INFO "Font configuration will be updated"
fi

LOG_END "Fonts installed"
