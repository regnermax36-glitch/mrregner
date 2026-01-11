# maxregnerOS SystemUI Modifications
# Adds maxregnerOS UI elements to SystemUI

LOG_BEGIN "Adding maxregnerOS SystemUI"

# Enable SystemUI features
FF "MAXREGNEROS_SYSTEMUI_STATUS_BAR_ENABLED" "TRUE"
FF "MAXREGNEROS_SYSTEMUI_NOTIFICATION_ENABLED" "TRUE"
FF "MAXREGNEROS_SYSTEMUI_QUICK_SETTINGS_ENABLED" "TRUE"

# System properties
BPROP "system" "ro.maxregneros.systemui.enabled" "true"
BPROP "system" "ro.maxregneros.systemui.status_bar.custom" "true"
BPROP "system" "ro.maxregneros.systemui.notification.style" "neural"

# Neural notification indicator
BPROP "system" "ro.maxregneros.systemui.neural_indicator" "true"

LOG_END "maxregnerOS SystemUI enabled (requires SystemUI.apk patching)"
