# Z Flip5 Camera Enhancements
# Adds flagship camera features and video recording capabilities

LOG_BEGIN "Adding Z Flip5 Camera Features"

# Enable high-resolution video recording
FF "CAMERA_CONFIG_VIDEO_RECORDING_QUALITY" "UHD_60FPS"
FF "CAMERA_SUPPORT_4K_120FPS" "TRUE"
FF "CAMERA_SUPPORT_8K_VIDEO" "TRUE"
FF "CAMERA_SUPPORT_LOG_VIDEO" "TRUE"
FF "CAMERA_SUPPORT_PRO_VIDEO" "TRUE"

# Camera quality and features
FF "CAMERA_CONFIG_DEFAULT_QUALITY" "superfine"
FF "CAMERA_SUPPORT_EXPERT_RAW" "TRUE"
FF "CAMERA_SUPPORT_NIGHT_MODE" "TRUE"
FF "CAMERA_SUPPORT_PORTRAIT_MODE" "TRUE"
FF "CAMERA_SUPPORT_FOOD_MODE" "TRUE"
FF "CAMERA_SUPPORT_PRO_MODE" "TRUE"
FF "CAMERA_SUPPORT_SINGLE_TAKE" "TRUE"
FF "CAMERA_SUPPORT_DIRECTOR_VIEW" "TRUE"
FF "CAMERA_SUPPORT_ZOOM_SLIDER" "TRUE"

# Video features
FF "CAMERA_SUPPORT_SUPER_STEADY" "TRUE"
FF "CAMERA_SUPPORT_HYPERLAPSE" "TRUE"
FF "CAMERA_SUPPORT_SLOW_MOTION_960FPS" "TRUE"
FF "CAMERA_SUPPORT_AUTO_FPS" "TRUE"

# Camera AI features
FF "CAMERA_SUPPORT_SCENE_OPTIMIZER" "TRUE"
FF "CAMERA_SUPPORT_AI_PHOTO" "TRUE"
FF "CAMERA_SUPPORT_AI_ZOOM" "TRUE"
FF "CAMERA_SUPPORT_QR_SCANNER" "TRUE"

# Cover screen camera support (Z Flip5 specific)
FF "CAMERA_SUPPORT_COVER_SCREEN_PREVIEW" "TRUE"
FF "CAMERA_SUPPORT_FLEX_MODE" "TRUE"

# Camera permissions and libraries
ADD_FROM_FW "extra" "system" "priv-app/SamsungCamera" 2>/dev/null || true
ADD_FROM_FW "extra" "system" "app/ExpertRaw" 2>/dev/null || true

# Set camera model props for compatibility
BPROP "system" "ro.product.system.model" "$MODEL"
BPROP "product" "ro.product.product.model" "$MODEL"

LOG_END "Z Flip5 Camera Features Added"
