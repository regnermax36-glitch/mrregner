#!/bin/bash
# maxregnerOS 3.0 Icon Extractor and Redesigner
# Actually extracts icons from system and recreates them

LOG_BEGIN "Extracting and Redesigning Icons"

# Check for required tools
if ! command -v convert &> /dev/null && ! command -v magick &> /dev/null; then
    ERROR_EXIT "ImageMagick required: apt-get install imagemagick"
fi

if ! command -v unzip &> /dev/null; then
    ERROR_EXIT "unzip required: apt-get install unzip"
fi

# Icon extraction directory
EXTRACT_DIR="$WORKSPACE/icon_extraction"
REDESIGN_DIR="$WORKSPACE/system/system/media/icons/maxregneros-v3"
mkdir -p "$EXTRACT_DIR"
mkdir -p "$REDESIGN_DIR/system"
mkdir -p "$REDESIGN_DIR/apps"
mkdir -p "$REDESIGN_DIR/adaptive"

# Icon specifications
ICON_SIZE=512
ACCENT_COLOR="#00FF88"
BACKGROUND_COLOR="#1A1A1A"
SHADOW_COLOR="#00000080"
GLOW_COLOR="#00FF8840"

# Function to extract icon from APK
extract_icon_from_apk() {
    local apk_path="$1"
    local icon_name="$2"
    local output_dir="$3"
    
    if [ ! -f "$apk_path" ]; then
        return 1
    fi
    
    # Extract APK
    local temp_dir="$EXTRACT_DIR/$(basename "$apk_path" .apk)"
    mkdir -p "$temp_dir"
    unzip -q "$apk_path" -d "$temp_dir" 2>/dev/null || return 1
    
    # Find icon files (common locations)
    local icon_files=(
        "$temp_dir/res/mipmap-xxxhdpi/ic_launcher.png"
        "$temp_dir/res/mipmap-xxxhdpi/ic_launcher_foreground.png"
        "$temp_dir/res/drawable-xxxhdpi/ic_launcher.png"
        "$temp_dir/res/mipmap-xxxhdpi/ic_launcher_round.png"
        "$temp_dir/res/drawable/ic_launcher.png"
    )
    
    # Also check AndroidManifest for icon reference
    if [ -f "$temp_dir/AndroidManifest.xml" ]; then
        # Extract icon name from manifest (simplified)
        local manifest_icon=$(grep -oP 'android:icon="[^"]*"' "$temp_dir/AndroidManifest.xml" 2>/dev/null | head -1 | cut -d'"' -f2)
        if [ -n "$manifest_icon" ]; then
            # Convert @drawable/icon to actual path
            local drawable_name=$(echo "$manifest_icon" | sed 's/@drawable\///' | sed 's/@mipmap\///')
            icon_files+=("$temp_dir/res/mipmap-xxxhdpi/${drawable_name}.png")
            icon_files+=("$temp_dir/res/drawable-xxxhdpi/${drawable_name}.png")
        fi
    fi
    
    # Find first existing icon
    local found_icon=""
    for icon_file in "${icon_files[@]}"; do
        if [ -f "$icon_file" ]; then
            found_icon="$icon_file"
            break
        fi
    done
    
    # Also search all drawable/mipmap directories
    if [ -z "$found_icon" ]; then
        found_icon=$(find "$temp_dir/res" -name "*launcher*.png" -o -name "*icon*.png" 2>/dev/null | head -1)
    fi
    
    if [ -n "$found_icon" ] && [ -f "$found_icon" ]; then
        # Ensure output directory exists
        mkdir -p "$output_dir"
        cp "$found_icon" "$output_dir/${icon_name}_original.png" 2>/dev/null || {
            rm -rf "$temp_dir"
            return 1
        }
        echo "$found_icon"
        rm -rf "$temp_dir"
        return 0
    fi
    
    rm -rf "$temp_dir"
    return 1
}

# Function to redesign icon
redesign_icon() {
    local original_icon="$1"
    local output_icon="$2"
    local size="$ICON_SIZE"
    
    if [ ! -f "$original_icon" ]; then
        LOG_WARN "Original icon not found: $original_icon"
        return 1
    fi
    
    # Ensure output directory exists
    mkdir -p "$(dirname "$output_icon")"
    
    # Resize original to target size
    convert "$original_icon" -resize ${size}x${size} "$EXTRACT_DIR/temp_resized.png" 2>/dev/null || {
        LOG_WARN "Failed to resize icon: $original_icon"
        return 1
    }
    
    # Create rounded hexagon mask
    convert -size ${size}x${size} xc:transparent \
        -fill white \
        -draw "roundrectangle 0,0 $((size-1)),$((size-1)) $((size/8)),$((size/8))" \
        "$EXTRACT_DIR/mask.png"
    
    # Apply mask to resized icon
    convert "$EXTRACT_DIR/temp_resized.png" "$EXTRACT_DIR/mask.png" \
        -alpha off -compose CopyOpacity -composite \
        "$EXTRACT_DIR/temp_masked.png"
    
    # Create background with gradient
    convert -size ${size}x${size} \
        -fill "$BACKGROUND_COLOR" \
        -draw "roundrectangle 0,0 $((size-1)),$((size-1)) $((size/8)),$((size/8))" \
        "$EXTRACT_DIR/background.png"
    
    # Composite icon on background
    convert "$EXTRACT_DIR/background.png" "$EXTRACT_DIR/temp_masked.png" \
        -composite "$EXTRACT_DIR/temp_composite.png"
    
    # Add shadow
    convert "$EXTRACT_DIR/temp_composite.png" \
        \( +clone -background "$SHADOW_COLOR" -shadow 100x3+0+3 \) \
        +swap -background none -layers merge +repage \
        "$EXTRACT_DIR/temp_shadow.png"
    
    # Add glow effect
    convert "$EXTRACT_DIR/temp_shadow.png" \
        \( +clone -background "$GLOW_COLOR" -blur 0x15 \) \
        +swap -background none -layers merge +repage \
        "$output_icon"
    
    # Cleanup
    rm -f "$EXTRACT_DIR/temp_*.png" "$EXTRACT_DIR/mask.png" "$EXTRACT_DIR/background.png"
    
    return 0
}

# Extract and redesign system icons
LOG_BEGIN "Extracting system icons"

SYSTEM_APKS=(
    "$WORKSPACE/system/system/priv-app/SecSettings/SecSettings.apk:settings"
    "$WORKSPACE/system/system/priv-app/SystemUI/SystemUI.apk:systemui"
    "$WORKSPACE/system/system/priv-app/Launcher3/Launcher3.apk:launcher"
    "$WORKSPACE/system/system/priv-app/SecTelephonyProvider/SecTelephonyProvider.apk:phone"
    "$WORKSPACE/system/system/priv-app/Contacts/Contacts.apk:contacts"
    "$WORKSPACE/system/system/priv-app/MmsService/MmsService.apk:messages"
    "$WORKSPACE/system/system/priv-app/SecCamera4/SecCamera4.apk:camera"
    "$WORKSPACE/system/system/priv-app/SecGallery2019/SecGallery2019.apk:gallery"
    "$WORKSPACE/system/system/app/MusicPlayer/MusicPlayer.apk:music"
    "$WORKSPACE/system/system/app/Calculator/Calculator.apk:calculator"
    "$WORKSPACE/system/system/app/ClockPackage/ClockPackage.apk:clock"
    "$WORKSPACE/system/system/app/Calendar/Calendar.apk:calendar"
    "$WORKSPACE/system/system/app/Email/Email.apk:email"
    "$WORKSPACE/system/system/app/SBrowser/SBrowser.apk:browser"
    "$WORKSPACE/system/system/app/MyFiles/MyFiles.apk:files"
)

for apk_info in "${SYSTEM_APKS[@]}"; do
    IFS=':' read -r apk_path icon_name <<< "$apk_info"
    
    if [ -f "$apk_path" ]; then
        LOG_INFO "Extracting icon from: $(basename "$apk_path")"
        original_icon=$(extract_icon_from_apk "$apk_path" "$icon_name" "$REDESIGN_DIR/system")
        
        if [ -n "$original_icon" ] && [ -f "$REDESIGN_DIR/system/${icon_name}_original.png" ]; then
            LOG_INFO "Redesigning: $icon_name"
            if redesign_icon "$REDESIGN_DIR/system/${icon_name}_original.png" "$REDESIGN_DIR/system/${icon_name}.png"; then
                if [ -f "$REDESIGN_DIR/system/${icon_name}.png" ]; then
                    LOG_INFO "✓ Created: $icon_name.png"
                else
                    LOG_WARN "Failed to create redesigned icon: $icon_name"
                fi
            else
                LOG_WARN "Failed to redesign icon: $icon_name"
            fi
        else
            LOG_WARN "No icon extracted for: $icon_name"
        fi
    fi
done

LOG_END "System icons extracted and redesigned"

# Extract adaptive icons (foreground + background)
LOG_BEGIN "Extracting adaptive icons"

for apk_info in "${SYSTEM_APKS[@]}"; do
    IFS=':' read -r apk_path icon_name <<< "$apk_info"
    
    if [ -f "$apk_path" ]; then
        temp_dir="$EXTRACT_DIR/$(basename "$apk_path" .apk)"
        mkdir -p "$temp_dir"
        unzip -q "$apk_path" -d "$temp_dir" 2>/dev/null
        
        # Find adaptive icon layers
        foreground=$(find "$temp_dir/res" -name "*ic_launcher_foreground*.png" 2>/dev/null | head -1)
        background=$(find "$temp_dir/res" -name "*ic_launcher_background*.png" 2>/dev/null | head -1)
        
        if [ -n "$foreground" ] && [ -f "$foreground" ]; then
            mkdir -p "$REDESIGN_DIR/adaptive"
            cp "$foreground" "$REDESIGN_DIR/adaptive/${icon_name}-foreground.png" 2>/dev/null || true
            redesign_icon "$foreground" "$REDESIGN_DIR/adaptive/${icon_name}-foreground-redesigned.png" || true
        fi
        
        if [ -n "$background" ] && [ -f "$background" ]; then
            mkdir -p "$REDESIGN_DIR/adaptive"
            cp "$background" "$REDESIGN_DIR/adaptive/${icon_name}-background.png" 2>/dev/null || true
            # Background doesn't need redesign, just resize it
            convert "$background" -resize ${ICON_SIZE}x${ICON_SIZE} "$REDESIGN_DIR/adaptive/${icon_name}-background-redesigned.png" 2>/dev/null || true
        fi
        
        rm -rf "$temp_dir"
    fi
done

LOG_END "Adaptive icons extracted"

# Create icon mapping
cat > "$REDESIGN_DIR/icon-mapping.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<iconpack>
    <name>maxregnerOS 3.0</name>
    <version>3.0.0</version>
    <icons>
EOF

for apk_info in "${SYSTEM_APKS[@]}"; do
    IFS=':' read -r apk_path icon_name <<< "$apk_info"
    if [ -f "$REDESIGN_DIR/system/${icon_name}.png" ]; then
        echo "        <icon name=\"$icon_name\" path=\"system/${icon_name}.png\"/>" >> "$REDESIGN_DIR/icon-mapping.xml"
    fi
done

cat >> "$REDESIGN_DIR/icon-mapping.xml" << 'EOF'
    </icons>
</iconpack>
EOF

# Cleanup extraction directory
rm -rf "$EXTRACT_DIR"

LOG_END "Icons extracted, redesigned, and installed"
