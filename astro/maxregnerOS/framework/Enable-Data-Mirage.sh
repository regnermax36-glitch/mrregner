# Data Mirage - ROM Level Implementation
# Feeds fake data to trackers by patching framework

LOG_BEGIN "Enabling Data Mirage (ROM Level)"

# Feature flags
FF "MAXREGNEROS_DATA_MIRAGE_ENABLED" "TRUE"
FF "MAXREGNEROS_FAKE_GPS_ENABLED" "TRUE"
FF "MAXREGNEROS_FAKE_CONTACTS_ENABLED" "TRUE"

# System properties
BPROP "system" "ro.maxregneros.ghost_protocol.data_mirage" "true"
BPROP "system" "ro.maxregneros.ghost_protocol.fake_gps" "true"
BPROP "system" "ro.maxregneros.ghost_protocol.fake_location.latitude" "0.0"
BPROP "system" "ro.maxregneros.ghost_protocol.fake_location.longitude" "0.0"
BPROP "system" "ro.maxregneros.ghost_protocol.fake_contacts" "true"
BPROP "system" "ro.maxregneros.ghost_protocol.shadow_profile" "true"

# Add to framework.jar smali patches directory
SMALI_PATCH_DIR="$SCRPATH/framework.jar"

if [ ! -d "$SMALI_PATCH_DIR" ]; then
    mkdir -p "$SMALI_PATCH_DIR"
fi

LOG_END "Data Mirage enabled (requires framework.jar smali patch)"
