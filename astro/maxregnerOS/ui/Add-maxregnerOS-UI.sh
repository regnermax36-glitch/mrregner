# maxregnerOS UI Integration
# Adds maxregnerOS UI elements to Settings, SystemUI, and Launcher

LOG_BEGIN "Adding maxregnerOS UI"

# Enable UI features
FF "MAXREGNEROS_UI_ENABLED" "TRUE"
FF "MAXREGNEROS_SETTINGS_UI_ENABLED" "TRUE"
FF "MAXREGNEROS_SYSTEMUI_ENABLED" "TRUE"
FF "MAXREGNEROS_LAUNCHER_UI_ENABLED" "TRUE"

# System properties for UI
BPROP "system" "ro.maxregneros.ui.enabled" "true"
BPROP "system" "ro.maxregneros.ui.theme" "dark"
BPROP "system" "ro.maxregneros.ui.accent_color" "#00FF88"

LOG_END "maxregnerOS UI framework enabled"
