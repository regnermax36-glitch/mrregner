# maxregnerOS Launcher Modifications
# Adds maxregnerOS launcher features (reactive icons, no-grid workspace)

LOG_BEGIN "Adding maxregnerOS Launcher UI"

# Enable launcher features
FF "MAXREGNEROS_LAUNCHER_REACTIVE_ICONS_ENABLED" "TRUE"
FF "MAXREGNEROS_LAUNCHER_NO_GRID_ENABLED" "TRUE"
FF "MAXREGNEROS_LAUNCHER_GRAVITY_ENABLED" "TRUE"

# System properties
BPROP "system" "ro.maxregneros.launcher.enabled" "true"
BPROP "system" "ro.maxregneros.launcher.reactive_icons" "true"
BPROP "system" "ro.maxregneros.launcher.no_grid" "true"
BPROP "system" "ro.maxregneros.launcher.gravity_system" "true"

# Icon animation properties
BPROP "system" "ro.maxregneros.launcher.icon.pulse_music" "true"
BPROP "system" "ro.maxregneros.launcher.icon.dim_battery" "true"
BPROP "system" "ro.maxregneros.launcher.icon.glow_cpu" "true"

LOG_END "maxregnerOS Launcher enabled (requires launcher APK patching)"
