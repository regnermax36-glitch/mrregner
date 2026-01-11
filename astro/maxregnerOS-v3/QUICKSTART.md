# maxregnerOS 3.0 - Quick Start

**5-minute guide to get maxregnerOS 3.0 running.**

---

## ⚡ Quick Steps

### 1. Install Prerequisites (One Time)

```bash
sudo apt-get update
sudo apt-get install imagemagick openjdk-17-jdk unzip zip
```

### 2. Build Module

```bash
cd /path/to/AstroROM
sudo ./build.sh --build b5q
```

**Wait for build to complete** (10-30 minutes first time, faster after)

### 3. Find Output

```bash
ls -lh out/maxregnerOS-v3-*.zip
```

### 4. Install on Device

1. Copy ZIP to device: `adb push out/maxregnerOS-v3-*.zip /sdcard/`
2. Open **Magisk Manager**
3. **Modules** → **Install from storage**
4. Select the ZIP file
5. **Reboot**

### 5. Done! ✅

After reboot, you'll have:
- ✅ Redesigned icons
- ✅ Custom fonts
- ✅ New animations
- ✅ maxregnerOS features

---

## 🔍 Verify It Worked

```bash
adb shell su -c "getprop ro.maxregneros.version"
# Should show: 3.0.0
```

---

## 🆘 Problems?

**Build fails?**
- Check prerequisites are installed
- Check you have root/sudo access
- Check disk space (need ~10GB)

**Module doesn't install?**
- Check Magisk version (24.0+)
- Check Android version (13+)
- Check ZIP isn't corrupted

**Nothing changes after install?**
- Reboot device
- Clear app caches
- Check module is enabled in Magisk

---

**That's it! Simple as that! 🎉**
