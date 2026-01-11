#!/system/bin/sh
# maxregnerOS 3.0 Service Script
# Runs after boot to apply runtime changes

MODDIR=${0%/*}
MODID=maxregnerOS-v3

# Wait for system to be ready
sleep 30

# Apply icon changes
if [ -f "$MODDIR/system/media/icons/applied" ]; then
    # Icons already applied
    true
else
    # Apply icon pack
    touch "$MODDIR/system/media/icons/applied"
fi

# Apply font changes
if [ -f "$MODDIR/system/fonts/maxregneros-sans.ttf" ]; then
    # Fonts installed
    true
fi

# Start animation service
if [ -f "$MODDIR/system/bin/maxregneros-animations" ]; then
    "$MODDIR/system/bin/maxregneros-animations" &
fi

# Set system properties
setprop ro.maxregneros.version "3.0.0"
setprop ro.maxregneros.installed "true"
setprop ro.maxregneros.magisk_module "true"
