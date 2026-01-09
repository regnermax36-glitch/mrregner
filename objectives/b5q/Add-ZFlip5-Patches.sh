# Z Flip5 Device-Specific Patches
# Applies patches and fixes specific to Z Flip5

LOG_BEGIN "Applying Z Flip5 Patches"

# Device model props for app compatibility
BPROP "system" "ro.product.system.model" "$MODEL"
BPROP "system" "ro.product.system.name" "$CODENAME"
BPROP "product" "ro.product.product.model" "$MODEL"
BPROP "product" "ro.product.product.name" "$CODENAME"
BPROP "vendor" "ro.vendor.product.model" "$MODEL"
BPROP "vendor" "ro.vendor.product.name" "$CODENAME"

# Build props for Z Flip5
BPROP "system" "ro.product.system.device" "$CODENAME"
BPROP "product" "ro.product.product.device" "$CODENAME"
BPROP "vendor" "ro.vendor.product.device" "$CODENAME"

# Enable official status
BPROP "system" "ro.build.official" "true"
BPROP "system" "ro.build.type" "user"

# Foldable device identification
BPROP "system" "ro.build.characteristics" "phone,foldable"
BPROP "system" "ro.config.device_type" "foldable"

# Cover screen props
BPROP "system" "ro.cover.screen.enabled" "true"
BPROP "system" "ro.cover.screen.size" "3.4"

# Flex mode props
BPROP "system" "ro.flex.mode.enabled" "true"
BPROP "system" "ro.flex.mode.angle" "75-115"

# Performance props
BPROP "system" "ro.config.cpu_boost" "true"
BPROP "system" "ro.config.gpu_boost" "true"
BPROP "system" "ro.config.ram_plus" "true"
BPROP "system" "ro.config.ram_plus_size" "8192"

# Camera props
BPROP "system" "camera.hal1.packagelist" "com.skype.raider,com.google.android.talk"
BPROP "system" "camera2.portability.force_api" "1"

# Display props
BPROP "system" "ro.lcd_density" "420"
BPROP "system" "ro.sf.lcd_density" "420"

# Battery optimization
BPROP "system" "ro.config.battery_saver_enabled" "true"
BPROP "system" "ro.config.ultra_power_saving" "true"

# Network props
BPROP "system" "ro.telephony.default_network" "10"
BPROP "system" "ro.ril.telephony.mqanelements" "6"

# Enable developer options by default (can be disabled)
BPROP "system" "persist.sys.usb.config" "mtp,adb"
BPROP "system" "ro.debuggable" "1"
BPROP "system" "ro.secure" "0"

# Z Flip5 specific feature flags
FF "COMMON_CONFIG_DEVICE_TYPE" "FOLDABLE"
FF "COMMON_CONFIG_COVER_SCREEN_SIZE" "3.4"
FF "COMMON_CONFIG_FLEX_MODE_ANGLES" "75-115"

LOG_END "Z Flip5 Patches Applied"
