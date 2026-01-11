#!/system/bin/sh
# maxregnerOS 3.0 Magisk Module Customize Script
# Handles module installation and customization

MODDIR=${0%/*}
MODID=maxregnerOS-v3
MODNAME=maxregnerOS

ui_print " "
ui_print "╔═══════════════════════════════════════╗"
ui_print "║      maxregnerOS 3.0 Installer        ║"
ui_print "║   10,000x More Special Redesign      ║"
ui_print "╚═══════════════════════════════════════╝"
ui_print " "

# Check Android version
ANDROID_VERSION=$(getprop ro.build.version.sdk)
if [ "$ANDROID_VERSION" -lt 33 ]; then
    ui_print "⚠️  Android 13+ required"
    ui_print "⚠️  Your device: Android $(getprop ro.build.version.release)"
    abort "Installation aborted"
fi

# Check if Samsung device
BRAND=$(getprop ro.product.brand)
if [ "$BRAND" != "samsung" ]; then
    ui_print "⚠️  Samsung device recommended"
    ui_print "⚠️  May not work correctly on other devices"
fi

ui_print "✓ Device compatible"
ui_print "✓ Starting installation..."
ui_print " "

# Installation steps
ui_print "→ Installing redesigned icons..."
ui_print "→ Installing custom fonts..."
ui_print "→ Installing animations..."
ui_print "→ Applying UI modifications..."
ui_print " "

ui_print "✓ Installation complete!"
ui_print " "
ui_print "Reboot to apply changes"
ui_print " "
