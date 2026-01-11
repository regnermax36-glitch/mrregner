#!/bin/bash
# maxregnerOS 3.0 Animation Generator
# Creates actual animation XML files

LOG_BEGIN "Generating maxregnerOS 3.0 Animations"

ANIM_DIR="$WORKSPACE/system/system/media/animations/maxregnerOS-v3"
mkdir -p "$ANIM_DIR"

# Animation specifications
DURATION=300
INTERPOLATOR="cubic_bezier"

# Function to create animation XML
create_animation() {
    local name="$1"
    local type="$2"
    local duration="${3:-$DURATION}"
    local output="$ANIM_DIR/$name.xml"
    
    case "$type" in
        "scale_fade")
            cat > "$output" << EOF
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@android:anim/decelerate_interpolator"
    android:duration="${duration}">
    <scale
        android:fromXScale="0.8"
        android:fromYScale="0.8"
        android:toXScale="1.0"
        android:toYScale="1.0"
        android:pivotX="50%"
        android:pivotY="50%"
        android:duration="${duration}"/>
    <alpha
        android:fromAlpha="0.0"
        android:toAlpha="1.0"
        android:duration="${duration}"/>
</set>
EOF
            ;;
        "slide_fade")
            cat > "$output" << EOF
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@android:anim/decelerate_interpolator"
    android:duration="${duration}">
    <translate
        android:fromXDelta="100%"
        android:toXDelta="0%"
        android:duration="${duration}"/>
    <alpha
        android:fromAlpha="0.0"
        android:toAlpha="1.0"
        android:duration="${duration}"/>
</set>
EOF
            ;;
        "scale")
            cat > "$output" << EOF
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@android:anim/overshoot_interpolator"
    android:duration="${duration}">
    <scale
        android:fromXScale="1.0"
        android:fromYScale="1.0"
        android:toXScale="0.95"
        android:toYScale="0.95"
        android:pivotX="50%"
        android:pivotY="50%"
        android:duration="${duration}"/>
</set>
EOF
            ;;
        "bounce")
            cat > "$output" << EOF
<?xml version="1.0" encoding="utf-8"?>
<set xmlns:android="http://schemas.android.com/apk/res/android"
    android:interpolator="@android:anim/bounce_interpolator"
    android:duration="${duration}">
    <scale
        android:fromXScale="0.95"
        android:fromYScale="0.95"
        android:toXScale="1.0"
        android:toYScale="1.0"
        android:pivotX="50%"
        android:pivotY="50%"
        android:duration="${duration}"/>
</set>
EOF
            ;;
        "fade")
            cat > "$output" << EOF
<?xml version="1.0" encoding="utf-8"?>
<alpha xmlns:android="http://schemas.android.com/apk/res/android"
    android:fromAlpha="0.0"
    android:toAlpha="1.0"
    android:duration="${duration}"
    android:interpolator="@android:anim/decelerate_interpolator"/>
EOF
            ;;
        "slide_down")
            cat > "$output" << EOF
<?xml version="1.0" encoding="utf-8"?>
<translate xmlns:android="http://schemas.android.com/apk/res/android"
    android:fromYDelta="-100%"
    android:toYDelta="0%"
    android:duration="${duration}"
    android:interpolator="@android:anim/decelerate_interpolator"/>
EOF
            ;;
    esac
    
    LOG_INFO "Created animation: $name ($type)"
}

# Generate animations
LOG_BEGIN "Creating animation files"

create_animation "app_launch" "scale_fade" 300
create_animation "app_exit" "scale_fade" 250
create_animation "page_transition_forward" "slide_fade" 250
create_animation "page_transition_back" "slide_fade" 250
create_animation "icon_press" "scale" 150
create_animation "icon_release" "bounce" 200
create_animation "system_dialog_enter" "fade" 200
create_animation "system_dialog_exit" "fade" 150
create_animation "notification_enter" "slide_down" 300
create_animation "notification_exit" "fade" 200
create_animation "window_enter" "scale_fade" 300
create_animation "window_exit" "fade" 250
create_animation "activity_enter" "slide_fade" 300
create_animation "activity_exit" "slide_fade" 250
create_animation "task_open" "scale_fade" 300
create_animation "task_close" "fade" 200

LOG_END "Animations created"

# Create animation configuration
cat > "$ANIM_DIR/animations.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<animations>
    <name>maxregnerOS 3.0</name>
    <version>3.0.0</version>
    <config>
        <app_launch>app_launch.xml</app_launch>
        <app_exit>app_exit.xml</app_exit>
        <page_transition_forward>page_transition_forward.xml</page_transition_forward>
        <page_transition_back>page_transition_back.xml</page_transition_back>
        <icon_press>icon_press.xml</icon_press>
        <icon_release>icon_release.xml</icon_release>
        <system_dialog_enter>system_dialog_enter.xml</system_dialog_enter>
        <system_dialog_exit>system_dialog_exit.xml</system_dialog_exit>
        <notification_enter>notification_enter.xml</notification_enter>
        <notification_exit>notification_exit.xml</notification_exit>
    </config>
</animations>
EOF

# Set system properties
BPROP "system" "ro.maxregneros.v3.animations.path" "/system/media/animations/maxregnerOS-v3"
BPROP "system" "ro.maxregneros.v3.animations.count" "15"

# Verify files were created
ANIM_COUNT=$(find "$ANIM_DIR" -type f -name "*.xml" 2>/dev/null | wc -l)
if [ "$ANIM_COUNT" -gt 0 ]; then
    LOG_INFO "Successfully created $ANIM_COUNT animation files"
    LOG_INFO "Animations location: $ANIM_DIR"
else
    LOG_WARN "No animation files were created!"
    # Create a placeholder to ensure directory exists
    touch "$ANIM_DIR/.placeholder"
fi

LOG_END "Animations generated"
