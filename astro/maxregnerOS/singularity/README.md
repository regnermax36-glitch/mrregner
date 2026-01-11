# Singularity - The Universal Control Center

**"Your phone is no longer just a phone; it's the master key."**

## Features

### 1. Universal Remote 2.0

Instant device recognition and control:

- Point phone at **any** smart device (TV, light, thermostat)
- Uses UWB (Ultra Wideband) and camera recognition
- Instantly projects controls for that device
- **No pairing, no app searching**

**Implementation:** Device recognition service + UWB stack + IR blaster

---

### 2. Desktop DNA

Full Arch Linux environment when connected to monitor:

- Boots complete, persistent Arch Linux environment
- Code, edit video, compile software
- Session freezes and saves when unplugged
- **Instant resume** when reconnected

**Implementation:** Linux container (chroot or containerization) + HDMI detection

---

## Implementation Notes

### ROM Level (This Script)
- Enables system properties
- Sets up container paths
- Configures device recognition

### Native App (Required)
- Universal Remote app
- Device recognition engine
- Control overlay UI

### Linux Container (Required for Desktop DNA)
- Arch Linux rootfs
- Container runtime (chroot/containerization)
- Session management
- File system integration

---

## Requirements

### Universal Remote 2.0
- UWB chip (Samsung Galaxy devices have this)
- IR blaster (if available)
- Camera for visual recognition
- WiFi Direct

### Desktop DNA
- HDMI/USB-C to HDMI adapter
- External monitor
- 4GB+ free storage for Linux container
- Root access for container setup

---

## Supported Devices (Universal Remote)

- Smart TVs (Samsung, LG, Sony, etc.)
- Smart lights (Philips Hue, etc.)
- Smart thermostats
- Any device with WiFi/IR/UWB

---

## Linux Container

The Arch Linux environment includes:
- Full package manager (pacman)
- Development tools (gcc, make, etc.)
- Video editing software
- Code editors (Vim, Nano, etc.)
- All standard Linux utilities

---

## Performance

- Container runs natively (no emulation)
- Full hardware access
- GPU acceleration available
- Storage shared with Android
