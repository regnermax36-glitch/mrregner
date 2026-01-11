# maxregnerOS 3.0 Main Enabler
# Enables all v3 features and redesigns

LOG_BEGIN "Enabling maxregnerOS 3.0 (10,000x Special)"

# Version identification
BPROP "system" "ro.maxregneros.version" "3.0.0"
BPROP "system" "ro.maxregneros.version_code" "30000"
BPROP "system" "ro.maxregneros.magisk_module" "true"
BPROP "system" "ro.maxregneros.v3.enabled" "true"

# Enable all v3 features
FF "MAXREGNEROS_V3_ENABLED" "TRUE"
FF "MAXREGNEROS_V3_REDESIGN" "TRUE"
FF "MAXREGNEROS_V3_SPECIAL" "TRUE"

# Redesign flags
BPROP "system" "ro.maxregneros.v3.icons.redesigned" "true"
BPROP "system" "ro.maxregneros.v3.fonts.redesigned" "true"
BPROP "system" "ro.maxregneros.v3.animations.redesigned" "true"
BPROP "system" "ro.maxregneros.v3.ui.redesigned" "true"

# Special multiplier (10,000x)
BPROP "system" "ro.maxregneros.v3.special_multiplier" "10000"

LOG_END "maxregnerOS 3.0 enabled"
