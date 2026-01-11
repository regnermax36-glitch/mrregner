# Singularity - The Universal Control Center
# Enables Universal Remote 2.0 and Desktop DNA

LOG_BEGIN "Enabling Singularity"

# Feature flags
FF "MAXREGNEROS_SINGULARITY_ENABLED" "TRUE"
FF "MAXREGNEROS_UNIVERSAL_REMOTE_ENABLED" "TRUE"
FF "MAXREGNEROS_DESKTOP_DNA_ENABLED" "TRUE"

# System properties
BPROP "system" "ro.maxregneros.singularity.enabled" "true"
BPROP "system" "ro.maxregneros.singularity.master_key" "true"

# Universal Remote 2.0
BPROP "system" "ro.maxregneros.singularity.universal_remote" "true"
BPROP "system" "ro.maxregneros.singularity.uwb_enabled" "true"
BPROP "system" "ro.maxregneros.singularity.camera_recognition" "true"
BPROP "system" "ro.maxregneros.singularity.ir_blaster" "true"
BPROP "system" "ro.maxregneros.singularity.wifi_direct" "true"
BPROP "system" "ro.maxregneros.singularity.device_recognition" "instant"
BPROP "system" "ro.maxregneros.singularity.no_pairing" "true"
BPROP "system" "ro.maxregneros.singularity.overlay_controls" "true"

# Desktop DNA (Arch Linux Environment)
BPROP "system" "ro.maxregneros.singularity.desktop_dna" "true"
BPROP "system" "ro.maxregneros.singularity.linux_environment" "arch"
BPROP "system" "ro.maxregneros.singularity.full_persistent" "true"
BPROP "system" "ro.maxregneros.singularity.session_freeze" "true"
BPROP "system" "ro.maxregneros.singularity.instant_save" "true"
BPROP "system" "ro.maxregneros.singularity.container_type" "chroot"
BPROP "system" "ro.maxregneros.singularity.code_support" "true"
BPROP "system" "ro.maxregneros.singularity.video_editing" "true"
BPROP "system" "ro.maxregneros.singularity.compilation" "true"

# Desktop Integration
BPROP "system" "ro.maxregneros.singularity.hdmi_detection" "auto"
BPROP "system" "ro.maxregneros.singularity.monitor_mode" "desktop"
BPROP "system" "ro.maxregneros.singularity.multimonitor" "true"

# Device Recognition
BPROP "system" "ro.maxregneros.singularity.supported_devices" "tv,light,thermostat,all"

LOG_END "Singularity Enabled"
