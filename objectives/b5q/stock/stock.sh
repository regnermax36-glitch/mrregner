FF "SYSTEM_CONFIG_SIOP_POLICY_FILENAME" "siop_b5q_sm8550"
FF "SETTINGS_CONFIG_BRAND_NAME" "$MODEL_NAME"

# Game Driver for Snapdragon 8 Gen 2
ADD_FROM_FW "stock" "system" "priv-app/GameDriver-SM8550"

# Z Flip5 specific system apps
ADD_FROM_FW "stock" "system" "priv-app/CoverScreenService" 2>/dev/null || true
ADD_FROM_FW "stock" "system" "priv-app/FlexModePanelService" 2>/dev/null || true
ADD_FROM_FW "stock" "system" "app/CoverScreen" 2>/dev/null || true

# Enable Z Flip5 specific features
FF "COMMON_SUPPORT_FOLDABLE_DEVICE" "TRUE"
FF "COMMON_SUPPORT_FLEX_MODE" "TRUE"
FF "COMMON_SUPPORT_COVER_SCREEN" "TRUE"