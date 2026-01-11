# Building maxregnerOS Modules

Quick guide for building LSPosed modules and services.

## Prerequisites

### LSPosed Modules
- Android Studio (latest)
- JDK 17+
- Android SDK 34+
- LSPosed API (included in build.gradle)

### Services
- Android device with root
- ADB access
- Shell access

---

## Building LSPosed Modules

### Data Mirage

1. **Open Project**
   ```bash
   cd modules/lsposed/DataMirage
   # Open in Android Studio
   ```

2. **Sync Gradle**
   - Android Studio will sync dependencies
   - LSPosed API will be downloaded

3. **Build APK**
   - Build → Build Bundle(s) / APK(s) → Build APK(s)
   - Or: `./gradlew assembleDebug`

4. **Install**
   - Transfer APK to device
   - Install: `adb install app-debug.apk`
   - Or install via file manager

5. **Enable in LSPosed**
   - Open LSPosed Manager
   - Enable "Data Mirage"
   - Select scope (apps to hook)
   - Reboot

### Neural Notifications

Same process as Data Mirage, but:
- Hook system framework (android package)
- Requires additional permissions
- May need system-level access

---

## Building Services

### Panic Grip Monitor

1. **Edit Script**
   - Adjust sensor paths for your device
   - Configure thresholds
   - Test pattern detection

2. **Push to Device**
   ```bash
   adb root
   adb remount
   adb push panic-grip-monitor.sh /system/etc/init.d/99panicgrip
   adb shell chmod 755 /system/etc/init.d/99panicgrip
   ```

3. **Test**
   ```bash
   adb shell /system/etc/init.d/99panicgrip
   # Check logs
   adb logcat | grep PanicGrip
   ```

4. **Enable on Boot**
   - Script in `/system/etc/init.d/` runs automatically
   - Or add to init.rc if needed

---

## Native Services (C/C++)

### Building Native Service

1. **Create Native Code**
   ```c
   // panic_grip_monitor.c
   #include <stdio.h>
   #include <stdlib.h>
   
   int main() {
       // Sensor reading code
       return 0;
   }
   ```

2. **Compile with NDK**
   ```bash
   $NDK_ROOT/ndk-build
   ```

3. **Push Binary**
   ```bash
   adb push libs/arm64-v8a/panic_grip_monitor /system/bin/
   adb shell chmod 755 /system/bin/panic_grip_monitor
   ```

---

## Testing

### LSPosed Modules

1. Enable module
2. Select test app
3. Use app normally
4. Check Xposed logs:
   ```bash
   adb logcat | grep DataMirage
   ```

### Services

1. Run service manually
2. Check logs:
   ```bash
   adb logcat | grep PanicGrip
   cat /data/local/tmp/panic_grip.log
   ```

---

## Troubleshooting

### Module Not Working

- Check LSPosed is active: Settings → LSPosed status
- Verify module is enabled
- Check scope selection
- Check Xposed logs for errors
- Reboot device

### Service Not Running

- Check permissions: `ls -l /system/etc/init.d/99panicgrip`
- Check SELinux: `getenforce`
- Check logs: `logcat | grep ServiceName`
- Test manually: `sh /system/etc/init.d/99panicgrip`

---

## Next Steps

1. **Start Simple:** Build Data Mirage first (easiest)
2. **Test Thoroughly:** Test on non-critical apps first
3. **Iterate:** Improve based on testing
4. **Document:** Document device-specific changes
5. **Contribute:** Share improvements back to project

---

## Resources

- [LSPosed Documentation](https://lsposed.org/)
- [Xposed Framework API](https://api.xposed.info/)
- [Android NDK](https://developer.android.com/ndk)
- [Android Init Scripts](https://source.android.com/devices/tech/ota/ab/system-as-root)
