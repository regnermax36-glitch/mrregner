# maxregnerOS 3.0 - Complete Redesign
# Enables all v3 features

LOG_BEGIN "Enabling maxregnerOS 3.0 (Complete Redesign)"

# Version
BPROP "system" "ro.maxregneros.version" "3.0.0"
BPROP "system" "ro.maxregneros.v3.enabled" "true"
BPROP "system" "ro.maxregneros.v3.magisk_module" "true"

# Enable features
FF "MAXREGNEROS_V3_ENABLED" "TRUE"
FF "MAXREGNEROS_V3_ICONS" "TRUE"
FF "MAXREGNEROS_V3_FONTS" "TRUE"
FF "MAXREGNEROS_V3_ANIMATIONS" "TRUE"

LOG_END "maxregnerOS 3.0 enabled"
