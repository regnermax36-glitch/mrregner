# maxregnerOS Modules - Quick Start Guide

**Get started with maxregnerOS features in 5 minutes.**

## What You Need

- ✅ Rooted Android device
- ✅ LSPosed installed
- ✅ ADB access (for services)
- ✅ Basic Android development knowledge

---

## Step 1: Build Data Mirage (Easiest)

### Option A: Build from Source

```bash
cd modules/lsposed/DataMirage
# Open in Android Studio
# Build → Build APK
# Install APK on device
```

### Option B: Use Pre-built (if available)

```bash
# Download APK
adb install DataMirage.apk
```

### Enable in LSPosed

1. Open **LSPosed Manager**
2. Go to **Modules**
3. Enable **Data Mirage**
4. Tap on **Data Mirage** → **Scope**
5. Select apps to protect (or "All Apps")
6. **Reboot**

### Test It

1. Enable for a test app (e.g., Facebook)
2. Grant location permission
3. Check app's location - should show **0°N, 0°E** (Gulf of Guinea)
4. ✅ **It works!**

---

## Step 2: Test Neural Notifications (Medium)

### Build

```bash
cd modules/lsposed/NeuralNotifications
# Same as Data Mirage
```

### Enable

1. Enable in LSPosed
2. **Important:** Enable for **system framework** (android package)
3. Reboot

### Test

1. Receive multiple notifications
2. Wait 1 hour (or change interval in code)
3. Check notifications - should see **one summary**
4. ✅ **It works!**

---

## Step 3: Panic Grip Monitor (Advanced)

### Setup

```bash
# Push script to device
adb root
adb remount
adb push modules/services/panic-grip-monitor.sh /system/etc/init.d/99panicgrip
adb shell chmod 755 /system/etc/init.d/99panicgrip
adb reboot
```

### Test

```bash
# Check if running
adb shell ps | grep panic
# Check logs
adb logcat | grep PanicGrip
```

### Configure

Edit thresholds in script:
- `SQUEEZE_PRESSURE_THRESHOLD`
- `SQUEEZE_DURATION_MS`
- Adjust for your device

---

## Step 4: Customize

### Data Mirage Configuration

Edit `DataMirage/MainHook.java`:
```java
private static final double FAKE_LATITUDE = 0.0;  // Change fake location
private static final double FAKE_LONGITUDE = 0.0;
```

### Neural Notifications Configuration

Edit `NeuralNotifications/MainHook.java`:
```java
private static final long SUMMARY_INTERVAL_MS = TimeUnit.HOURS.toMillis(1);  // Change interval
```

---

## Troubleshooting

### Module Not Working?

```bash
# Check LSPosed status
adb shell su -c "lsmod | grep lsposed"

# Check Xposed logs
adb logcat | grep -E "DataMirage|NeuralNotifications"

# Verify module is enabled
# LSPosed Manager → Modules → Check enabled
```

### Service Not Running?

```bash
# Check permissions
adb shell ls -l /system/etc/init.d/99panicgrip

# Test manually
adb shell su -c "/system/etc/init.d/99panicgrip"

# Check SELinux
adb shell getenforce
```

---

## Next Steps

1. ✅ **Data Mirage** - Start here (easiest)
2. ✅ **Neural Notifications** - Medium difficulty
3. 🔄 **Panic Grip** - Advanced (needs native code)
4. 🔄 **Other features** - See IMPLEMENTATION.md

---

## Need Help?

- Check `BUILD.md` for detailed build instructions
- Check `IMPLEMENTATION.md` in `astro/maxregnerOS/` for code examples
- Check module READMEs for specific details
- Check LSPosed logs for errors

---

**Ready to go beyond simple theming? Start with Data Mirage! 🚀**
