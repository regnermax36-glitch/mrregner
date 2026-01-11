# maxregnerOS UI Resources
# Adds maxregnerOS strings, colors, and drawables

LOG_BEGIN "Adding maxregnerOS Resources"

# Resource directory
RES_DIR="$WORKSPACE/system/system/etc/maxregneros/res"

mkdir -p "$RES_DIR/values" "$RES_DIR/drawable" "$RES_DIR/color"

# Strings
cat > "$RES_DIR/values/strings.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="maxregneros_title">maxregnerOS</string>
    <string name="liquid_reality_title">Liquid Reality</string>
    <string name="liquid_reality_summary">Reactive icons, no-grid workspace, true depth wallpapers</string>
    <string name="cortex_title">Cortex Integration</string>
    <string name="cortex_summary">AI-powered features: pre-emptive launching, neural notifications</string>
    <string name="ghost_protocol_title">Ghost Protocol</string>
    <string name="ghost_protocol_summary">Privacy features: Data Mirage, Panic Grip, Kill Switch</string>
    <string name="singularity_title">Singularity</string>
    <string name="singularity_summary">Universal control center and Desktop DNA</string>
    <string name="neural_notification_title">Neural Summary</string>
    <string name="neural_notification_empty">No summary available</string>
</resources>
EOF

# Colors
cat > "$RES_DIR/values/colors.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="maxregneros_accent">#00FF88</color>
    <color name="maxregneros_accent_dark">#00CC6A</color>
    <color name="maxregneros_text_primary">#FFFFFF</color>
    <color name="maxregneros_text_secondary">#CCCCCC</color>
    <color name="liquid_reality_glow">#00FF88</color>
    <color name="cortex_neural">#FF0088</color>
    <color name="ghost_protocol_shadow">#8800FF</color>
</resources>
EOF

# maxregnerOS logo (placeholder - should be actual image)
# For now, create a simple colored drawable
cat > "$RES_DIR/drawable/maxregneros_logo.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="#00FF88"/>
    <corners android:radius="8dp"/>
</shape>
EOF

LOG_END "maxregnerOS Resources added"
