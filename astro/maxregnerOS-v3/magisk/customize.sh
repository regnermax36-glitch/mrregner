#!/system/bin/sh
# maxregnerOS 3.0 Magisk Module Customize Script
# Works in both build environment and Magisk installation environment

# Define ui_print function if not available (build environment)
if ! command -v ui_print >/dev/null 2>&1; then
    ui_print() {
        # Use LOG_INFO if available (build environment)
        if command -v LOG_INFO >/dev/null 2>&1; then
            LOG_INFO "$@"
        else
            echo "$@"
        fi
    }
fi

# Define abort function if not available
if ! command -v abort >/dev/null 2>&1; then
    abort() {
        echo "ERROR: $@" >&2
        exit 1
    }
fi

# Only run installation checks if in Magisk environment
if [ -n "$MODPATH" ] || [ -n "$MAGISK_VER" ]; then
    ui_print " "
    ui_print "╔═══════════════════════════════════════╗"
    ui_print "║      maxregnerOS 3.0 Installer       ║"
    ui_print "║   10,000x More Special Redesign      ║"
    ui_print "╚═══════════════════════════════════════╝"
    ui_print " "

    # Check Android version (only in Magisk environment)
    if command -v getprop >/dev/null 2>&1; then
        ANDROID_VERSION=$(getprop ro.build.version.sdk 2>/dev/null || echo "0")
        if [ -n "$ANDROID_VERSION" ] && [ "$ANDROID_VERSION" != "0" ] && [ "$ANDROID_VERSION" -lt 33 ]; then
            ui_print "⚠️  Android 13+ required"
            abort "Installation aborted"
        fi
    fi

    ui_print "✓ Device compatible"
    ui_print "✓ Installing maxregnerOS 3.0..."
    ui_print " "

    ui_print "→ Installing redesigned icons..."
    ui_print "→ Installing custom fonts..."
    ui_print "→ Installing animations..."
    ui_print "→ Applying UI modifications..."
    ui_print " "

    ui_print "✓ Installation complete!"
    ui_print " "
    ui_print "Reboot to apply changes"
    ui_print " "
else
    # Build environment - just log that customize.sh was processed
    ui_print "maxregnerOS 3.0 customize.sh processed (build environment)"
fi
