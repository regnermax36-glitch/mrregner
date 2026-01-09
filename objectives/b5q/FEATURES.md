# Z Flip5 (b5q) Features & Patches

This directory contains all device-specific features, patches, and optimizations for the Samsung Galaxy Z Flip5 (SM-F731B).

## Feature Scripts

### 1. **Add-ZFlip5-Camera-Features.sh**
Enhances camera capabilities with:
- 4K/120FPS video recording
- 8K video support
- Expert RAW mode
- Pro Video mode
- Director's View
- Single Take mode
- Cover screen camera preview
- Flex mode camera support
- AI scene optimizer
- Night mode, Portrait mode, Food mode

### 2. **Add-ZFlip5-Display-Features.sh**
Optimizes display and foldable-specific features:
- Adaptive refresh rate (1-120Hz)
- Outdoor mode
- Adaptive color tone
- Eye Comfort Shield
- Flex Mode support
- Cover screen widgets and notifications
- Flex Mode for video calls, camera, gallery
- Multi-window and split screen
- HDR10+ support
- Dynamic AMOLED optimizations

### 3. **Add-ZFlip5-Performance.sh**
Performance enhancements:
- Game Booster and Game Tools
- High FPS gaming support (120FPS)
- CPU/GPU boost
- RAM Plus (8GB)
- Adaptive performance
- Low heat mode
- Thermal management
- App launch optimization
- 5G and Wi-Fi 6E optimization

### 4. **Add-ZFlip5-Extra-Features.sh**
Additional features:
- Samsung Pay/Wallet
- Bixby Voice and Vision
- Samsung Health features
- Smart Stay, Smart Rotation, Smart Pause
- Air Gesture and Air View
- Edge Panel and Edge Lighting
- Secure Folder (patched)
- DeX support
- Link to Windows
- Quick Share and Nearby Share
- Cover screen widgets
- Always On Display enhancements
- Dolby Atmos and AKG tuning

### 5. **Add-ZFlip5-AI-Features.sh**
AI capabilities:
- AI Agent support
- Generative AI (LLM 0.40)
- AI Photo and Video enhancement
- AI Scene Optimizer
- AI Gallery search and editing
- Bixby AI features
- Smart suggestions
- AI Wallpaper generation

### 6. **Add-ZFlip5-Patches.sh**
Device-specific patches:
- Model props for app compatibility
- Official build status
- Foldable device identification
- Cover screen configuration
- Flex mode angles (75-115°)
- Performance props
- Camera HAL configuration
- Display density settings
- Network configuration

### 7. **Add-ZFlip5-Optimizations.sh**
System-wide optimizations:
- Memory and storage management
- App optimization and deep sleep
- Network optimizations
- Battery protection features
- Display and dark mode
- Security and privacy
- Audio and haptic enhancements
- Connectivity features
- One UI Good Lock support
- Cover screen and Flex mode optimizations

## Build Order

Scripts are executed in alphabetical order by the build system:
1. Add-ZFlip5-AI-Features.sh
2. Add-ZFlip5-Camera-Features.sh
3. Add-ZFlip5-Display-Features.sh
4. Add-ZFlip5-Extra-Features.sh
5. Add-ZFlip5-Optimizations.sh
6. Add-ZFlip5-Patches.sh
7. Add-ZFlip5-Performance.sh
8. b5q.sh (device configuration)
9. stock/stock.sh (stock firmware additions)

## Notes

- All scripts use the `FF` function to set floating features
- All scripts use the `BPROP` function to set build properties
- All scripts use the `ADD_FROM_FW` function to add files from firmware
- Error handling is included with `2>/dev/null || true` for optional additions
- Scripts are compatible with the AstroROM build system

## Compatibility

- **Device**: Samsung Galaxy Z Flip5 (SM-F731B)
- **Codename**: b5q
- **SoC**: Qualcomm Snapdragon 8 Gen 2 (SM8550)
- **Android Version**: Compatible with Android 13/14/15 (depending on ROM base)
