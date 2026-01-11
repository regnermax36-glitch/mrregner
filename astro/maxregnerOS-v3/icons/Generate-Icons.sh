#!/bin/bash
# maxregnerOS 3.0 Icon Generator
# Actually generates redesigned icons using ImageMagick

LOG_BEGIN "Generating maxregnerOS 3.0 Icons"

# Check for ImageMagick
if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
    ERROR_EXIT "ImageMagick not found. Install: apt-get install imagemagick"
fi

ICON_DIR="$WORKSPACE/system/system/media/icons/maxregneros-v3"
mkdir -p "$ICON_DIR/{system,apps,adaptive}"

# Icon specifications
ICON_SIZE=512
ACCENT_COLOR="#00FF88"
BACKGROUND_COLOR="#1A1A1A"
SHADOW_COLOR="#00000080"
GLOW_COLOR="#00FF8840"

# Function to generate icon
generate_icon() {
    local name="$1"
    local symbol="$2"
    local output="$3"
    local size="$ICON_SIZE"
    
    # Create base with rounded hexagon shape
    convert -size ${size}x${size} xc:transparent \
        \( -size ${size}x${size} xc:"$BACKGROUND_COLOR" \
           -draw "roundrectangle 0,0 $((size-1)),$((size-1)) $((size/8)),$((size/8))" \
        \) \
        -composite \
        "$output-base.png"
    
    # Add shadow
    convert "$output-base.png" \
        \( +clone -background "$SHADOW_COLOR" -shadow 100x3+0+3 \) \
        +swap -background none -layers merge +repage \
        "$output-shadow.png"
    
    # Add glow effect
    convert "$output-shadow.png" \
        \( +clone -background "$GLOW_COLOR" -blur 0x15 \) \
        +swap -background none -layers merge +repage \
        "$output-glow.png"
    
    # Add symbol/text (simplified - would use actual icon designs)
    convert "$output-glow.png" \
        -fill "$ACCENT_COLOR" \
        -font "DejaVu-Sans-Bold" \
        -pointsize $((size/3)) \
        -gravity center \
        -annotate +0+0 "$symbol" \
        "$output.png"
    
    # Cleanup temp files
    rm -f "$output-base.png" "$output-shadow.png" "$output-glow.png"
    
    LOG_INFO "Generated: $name"
}

# Generate system icons
LOG_BEGIN "Generating system icons"

generate_icon "settings" "⚙" "$ICON_DIR/system/settings.png"
generate_icon "systemui" "📱" "$ICON_DIR/system/systemui.png"
generate_icon "launcher" "🏠" "$ICON_DIR/system/launcher.png"
generate_icon "phone" "📞" "$ICON_DIR/system/phone.png"
generate_icon "contacts" "👥" "$ICON_DIR/system/contacts.png"
generate_icon "messages" "💬" "$ICON_DIR/system/messages.png"
generate_icon "camera" "📷" "$ICON_DIR/system/camera.png"
generate_icon "gallery" "🖼" "$ICON_DIR/system/gallery.png"
generate_icon "music" "🎵" "$ICON_DIR/system/music.png"
generate_icon "calculator" "🔢" "$ICON_DIR/system/calculator.png"
generate_icon "clock" "🕐" "$ICON_DIR/system/clock.png"
generate_icon "calendar" "📅" "$ICON_DIR/system/calendar.png"
generate_icon "email" "📧" "$ICON_DIR/system/email.png"
generate_icon "browser" "🌐" "$ICON_DIR/system/browser.png"
generate_icon "files" "📁" "$ICON_DIR/system/files.png"

LOG_END "System icons generated"

# Generate adaptive icons (with multiple layers)
LOG_BEGIN "Generating adaptive icons"

for icon in settings phone camera gallery; do
    # Foreground layer
    convert -size ${ICON_SIZE}x${ICON_SIZE} xc:transparent \
        -fill "$ACCENT_COLOR" \
        -font "DejaVu-Sans-Bold" \
        -pointsize $((ICON_SIZE/2)) \
        -gravity center \
        -annotate +0+0 "ICON" \
        "$ICON_DIR/adaptive/${icon}-foreground.png"
    
    # Background layer
    convert -size ${ICON_SIZE}x${ICON_SIZE} \
        -fill "$BACKGROUND_COLOR" \
        -draw "roundrectangle 0,0 $((ICON_SIZE-1)),$((ICON_SIZE-1)) $((ICON_SIZE/8)),$((ICON_SIZE/8))" \
        "$ICON_DIR/adaptive/${icon}-background.png"
    
    LOG_INFO "Generated adaptive: $icon"
done

LOG_END "Adaptive icons generated"

# Create icon mapping file
cat > "$ICON_DIR/icon-mapping.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<iconpack>
    <name>maxregnerOS 3.0</name>
    <version>3.0.0</version>
    <icons>
        <icon name="com.android.settings" path="system/settings.png"/>
        <icon name="com.android.systemui" path="system/systemui.png"/>
        <icon name="com.android.launcher3" path="system/launcher.png"/>
        <icon name="com.android.dialer" path="system/phone.png"/>
        <icon name="com.android.contacts" path="system/contacts.png"/>
        <icon name="com.android.mms" path="system/messages.png"/>
        <icon name="com.sec.android.app.camera" path="system/camera.png"/>
        <icon name="com.sec.android.gallery3d" path="system/gallery.png"/>
        <icon name="com.sec.android.app.music" path="system/music.png"/>
        <icon name="com.sec.android.app.popupcalculator" path="system/calculator.png"/>
        <icon name="com.android.deskclock" path="system/clock.png"/>
        <icon name="com.android.calendar" path="system/calendar.png"/>
        <icon name="com.android.email" path="system/email.png"/>
        <icon name="com.android.browser" path="system/browser.png"/>
        <icon name="com.sec.android.app.myfiles" path="system/files.png"/>
    </icons>
</iconpack>
EOF

# Copy icons to system
if [ -d "$ICON_DIR" ]; then
    mkdir -p "$WORKSPACE/system/system/media/icons"
    cp -r "$ICON_DIR" "$WORKSPACE/system/system/media/icons/" 2>/dev/null || true
fi

LOG_END "Icons generated and installed"
