# maxregnerOS Base Framework
# Enables maxregnerOS system properties and feature flags

LOG_BEGIN "Enabling maxregnerOS Framework"

# maxregnerOS identification
BPROP "system" "ro.maxregneros.enabled" "true"
BPROP "system" "ro.maxregneros.version" "1.0"
BPROP "system" "ro.maxregneros.codename" "singularity"

# Enable all maxregnerOS modules
BPROP "system" "ro.maxregneros.liquid_reality.enabled" "true"
BPROP "system" "ro.maxregneros.cortex.enabled" "true"
BPROP "system" "ro.maxregneros.ghost_protocol.enabled" "true"
BPROP "system" "ro.maxregneros.singularity.enabled" "true"

# Build identifier
BPROP "system" "ro.build.tags" "release-keys,maxregnerOS"
BPROP "system" "ro.build.type" "user"

LOG_END "maxregnerOS Framework Enabled"
