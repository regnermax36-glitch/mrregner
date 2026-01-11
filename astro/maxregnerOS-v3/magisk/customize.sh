#!/system/bin/sh
# maxregnerOS 3.0 Magisk Module Customize Script

ui_print " "
ui_print "╔═══════════════════════════════════════╗"
ui_print "║      maxregnerOS 3.0 Installer       ║"
ui_print "║   10,000x More Special Redesign      ║"
ui_print "╚═══════════════════════════════════════╝"
ui_print " "

# Check Android version
ANDROID_VERSION=$(getprop ro.build.version.sdk)
if [ "$ANDROID_VERSION" -lt 33 ]; then
    ui_print "⚠️  Android 13+ required"
    abort "Installation aborted"
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
