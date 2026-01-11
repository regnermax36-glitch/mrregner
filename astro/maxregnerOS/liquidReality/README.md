# Liquid Reality - The Interface That Breathes

**"Standard icons are boring. In maxregnerOS, the interface is alive."**

## Features

### 1. Biometric-Reactive Icons

Icons that react to your device's state in real-time:

- **Battery Low?** Settings and Battery icons dim and desaturate
- **Playing Music?** Music/Spotify icon pulses to exact BPM
- **High CPU?** Gaming icons glow red (heat visualization)

**Implementation:** Custom launcher with game engine (Godot) for real-time shaders

---

### 2. No-Grid Workspace

Apps float in a gravity system:

- **Tilt Control:** Tilt phone, apps slide to your thumb
- **Time-Based Learning:** OS learns which apps you need at 8 AM vs 8 PM
- **Auto-Float:** Most-used apps automatically float to center

**Implementation:** Custom launcher with physics engine and ML-based prediction

---

### 3. True Depth Wallpapers

Real-time 3D parallax using gyroscope and head-tracking:

- Uses front camera for head-tracking
- Gyroscope for device orientation
- Creates illusion of 3D room behind screen
- GPU-accelerated rendering

**Implementation:** Custom wallpaper service with 3D rendering engine

---

## Implementation Notes

### ROM Level (This Script)
- Enables system properties
- Sets feature flags
- Provides framework hooks

### LSPosed Module (Required)
- Hooks into launcher service
- Intercepts icon rendering
- Provides real-time sensor data

### Native App (Required)
- Custom launcher application
- Godot-based rendering engine
- Physics simulation

---

## Configuration

All settings are available via system properties (see Enable-Liquid-Reality.sh)

可以通过 `getprop` 命令查看当前配置。
