# maxregnerOS Native Services
# Adds native services for maxregnerOS features

LOG_BEGIN "Adding maxregnerOS Services"

# Cortex AI Service
ADD_FROM_FW "stock" "system" "bin/cortex_ai_service" 2>/dev/null || true
BPROP "system" "ro.maxregneros.cortex.service.enabled" "true"
BPROP "system" "ro.maxregneros.cortex.service.path" "/system/bin/cortex_ai_service"

# Data Mirage Service
ADD_FROM_FW "stock" "system" "bin/data_mirage_service" 2>/dev/null || true
BPROP "system" "ro.maxregneros.ghost_protocol.service.enabled" "true"
BPROP "system" "ro.maxregneros.ghost_protocol.service.path" "/system/bin/data_mirage_service"

# Panic Grip Monitor Service
ADD_FROM_FW "stock" "system" "bin/panic_grip_monitor" 2>/dev/null || true
BPROP "system" "ro.maxregneros.ghost_protocol.panic_grip.service.enabled" "true"
BPROP "system" "ro.maxregneros.ghost_protocol.panic_grip.service.path" "/system/bin/panic_grip_monitor"

# Neural Notification Service
ADD_FROM_FW "stock" "system" "bin/neural_notification_service" 2>/dev/null || true
BPROP "system" "ro.maxregneros.cortex.neural_notification.service.enabled" "true"
BPROP "system" "ro.maxregneros.cortex.neural_notification.service.path" "/system/bin/neural_notification_service"

# Add init scripts
cat > "$WORKSPACE/system/system/etc/init/maxregneros-services.rc" << 'EOF'
# maxregnerOS Services
service cortex_ai_service /system/bin/cortex_ai_service
    class core
    user root
    group root
    seclabel u:r:init:s0
    oneshot

service data_mirage_service /system/bin/data_mirage_service
    class core
    user root
    group root
    seclabel u:r:init:s0
    oneshot

service panic_grip_monitor /system/bin/panic_grip_monitor
    class core
    user root
    group root
    seclabel u:r:init:s0

service neural_notification_service /system/bin/neural_notification_service
    class core
    user root
    group root
    seclabel u:r:init:s0
EOF

LOG_END "maxregnerOS Services added"
