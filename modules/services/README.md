# maxregnerOS Services

Native services and scripts for maxregnerOS features.

## Services

### panic-grip-monitor.sh

Monitors pressure sensors (or accelerometer) for "tight squeeze" pattern and triggers dummy mode.

**Installation:**
```bash
adb push panic-grip-monitor.sh /system/etc/init.d/99panicgrip
adb shell chmod 755 /system/etc/init.d/99panicgrip
adb shell chown root:shell /system/etc/init.d/99panicgrip
```

**Configuration:**
- Edit thresholds in script
- Adjust for your device's pressure sensor

**Note:** This is a simplified version. Full implementation requires:
- Native C code for sensor reading
- Proper sensor driver access
- Pattern detection algorithm
- Dummy mode implementation

## Service Development

### Creating a Service

1. Create shell script or native binary
2. Place in `/system/etc/init.d/` or `/system/bin/`
3. Set permissions: `chmod 755`
4. Add to init scripts if needed

### Native Services

For better performance, implement services in C/C++:
- Direct hardware access
- Better sensor reading
- Lower battery impact
- More reliable

### Integration with ROM

These services are called by the ROM build system:
- Services are copied to system during build
- Permissions are set automatically
- Can be enabled/disabled via system properties

## Status

- ✅ panic-grip-monitor.sh - Basic template
- 🔴 Full implementation - Requires native code
- 🔴 Sensor drivers - Device-specific
- 🔴 Dummy mode - Needs user profile setup
