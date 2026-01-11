# Liquid Reality - The Interface That Breathes
# Enables reactive icons, no-grid workspace, and true depth wallpapers

LOG_BEGIN "Enabling Liquid Reality"

# Feature flags
FF "MAXREGNEROS_LIQUID_REALITY_ENABLED" "TRUE"
FF "MAXREGNEROS_REACTIVE_ICONS_ENABLED" "TRUE"
FF "MAXREGNEROS_NO_GRID_WORKSPACE_ENABLED" "TRUE"
FF "MAXREGNEROS_TRUE_DEPTH_WALLPAPERS_ENABLED" "TRUE"

# System properties
BPROP "system" "ro.maxregneros.liquid_reality.reactive_icons" "true"
BPROP "system" "ro.maxregneros.liquid_reality.no_grid_workspace" "true"
BPROP "system" "ro.maxregneros.liquid_reality.true_depth_wallpapers" "true"

# Reactive Icons configuration
BPROP "system" "ro.maxregneros.reactive_icons.battery_drain_effect" "true"
BPROP "system" "ro.maxregneros.reactive_icons.music_pulse" "true"
BPROP "system" "ro.maxregneros.reactive_icons.cpu_glow" "true"

# No-Grid Workspace configuration
BPROP "system" "ro.maxregneros.no_grid.gravity_enabled" "true"
BPROP "system" "ro.maxregneros.no_grid.tilt_control" "true"
BPROP "system" "ro.maxregneros.no_grid.time_based_learning" "true"
BPROP "system" "ro.maxregneros.no_grid.app_prediction" "true"

# True Depth Wallpapers configuration
BPROP "system" "ro.maxregneros.true_depth.gyroscope_enabled" "true"
BPROP "system" "ro.maxregneros.true_depth.head_tracking" "true"
BPROP "system" "ro.maxregneros.true_depth.parallax_depth" "100"

# Performance optimization
BPROP "system" "ro.maxregneros.liquid_reality.gpu_accelerated" "true"
BPROP "system" "ro.maxregneros.liquid_reality.shader_support" "true"

# Launcher integration
BPROP "system" "ro.maxregneros.launcher.custom" "true"
BPROP "system" "ro.maxregneros.launcher.game_engine" "godot"

LOG_END "Liquid Reality Enabled"
