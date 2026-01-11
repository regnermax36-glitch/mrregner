# maxregnerOS 3.0 - How To Use

Complete guide to building and installing maxregnerOS 3.0 Magisk module.

---

## 📋 Prerequisites

### Required Tools
```bash
# Install ImageMagick (for icon generation)
sudo apt-get install imagemagick

# Install Java 17+ (for apktool, smali)
sudo apt-get install openjdk-17-jdk

# Install unzip (usually pre-installed)
sudo apt-get install unzip

# Install zip (usually pre-installed)
sudo apt-get install zip
```

### Required Files
- Samsung firmware for your device (downloaded automatically)
- Root access on build machine (for some operations)
- Sufficient disk space (~10GB for workspace)

---

## 🚀 Building maxregnerOS 3.0

### Step 1: Prepare Your Device Configuration

Make sure you have a device configuration in `objectives/` directory. For example, if you have `objectives/b5q/`:

```bash
cd objectives/b5q
# Your b5q.sh should be configured
```

### Step 2: Build the ROM with maxregnerOS v3

```bash
# From AstroROM root directory
sudo ./build.sh --build b5q
```

**What happens:**
1. Downloads firmware (if not already downloaded)
2. Extracts firmware
3. Applies all astro patches (including maxregnerOS v3)
4. **Extracts icons from APKs** → Redesigns them
5. **Extracts framework.jar** → Patches it
6. **Extracts APKs** → Patches them
7. Generates fonts and animations
8. **Builds Magisk module** (instead of super.img)
9. Outputs: `out/maxregnerOS-v3-b5q-YYYYMMDD-HHMMSS.zip`

### Step 3: Check Output

```bash
ls -lh out/maxregnerOS-v3-*.zip
```

You should see a ZIP file (typically 50-200MB depending on changes).

---

## 📱 Installing on Device

### Step 1: Transfer to Device

```bash
# Via ADB
adb push out/maxregnerOS-v3-*.zip /sdcard/Download/

# Or copy via USB/MTP
```

### Step 2: Install via Magisk

1. **Open Magisk Manager** on your device
2. Go to **Modules** tab
3. Tap **Install from storage**
4. Navigate to `/sdcard/Download/`
5. Select `maxregnerOS-v3-*.zip`
6. Wait for installation
7. **Reboot device**

### Step 3: Verify Installation

After reboot:
```bash
# Check if module is active
adb shell su -c "getprop ro.maxregneros.v3.installed"
# Should output: true

# Check version
adb shell su -c "getprop ro.maxregneros.version"
# Should output: 3.0.0
```

---

## 🔍 What Gets Modified

### Icons
- **Location:** `/system/media/icons/maxregneros-v3/`
- **What:** All system app icons redesigned
- **Files:** PNG files with shadows, glow, rounded hexagon shape

### Framework
- **File:** `/system/framework/framework.jar`
- **What:** LocationManager patched for Data Mirage (fake GPS)
- **Method:** `getLastKnownLocation()` returns fake location (0,0)

### APKs
- **SecSettings:** maxregnerOS settings panel added
- **SystemUI:** Neural notification view added
- **Launcher3:** Reactive icons support added

### Fonts
- **Location:** `/system/fonts/`
- **Files:** `maxregnerOS-Sans-*.ttf`, `maxregnerOS-Mono-*.ttf`
- **Config:** `/system/etc/fonts_maxregneros.xml`

### Animations
- **Location:** `/system/media/animations/maxregnerOS-v3/`
- **Files:** 15+ animation XML files
- **Types:** scale_fade, slide_fade, bounce, fade, etc.

---

## 🛠️ Customization

### Custom Icons

Place your custom icons in:
```
astro/maxregnerOS-v3/icons/custom/
```

The extraction script will use these if they exist.

### Custom Fonts

Place TTF/OTF fonts in:
```
astro/maxregnerOS-v3/fonts/fonts-source/
```

Fonts will be processed and renamed automatically.

### Custom Animations

Modify animation XML files in:
```
astro/maxregnerOS-v3/animations/
```

Or create new ones following Android animation XML format.

---

## 🐛 Troubleshooting

### Build Fails: ImageMagick Not Found
```bash
sudo apt-get install imagemagick
```

### Build Fails: Java Not Found
```bash
sudo apt-get install openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

### Build Fails: apktool Error
```bash
# Check apktool.jar exists
ls -l utilities/apktool/apktool.jar

# If missing, download from:
# https://ibotpeaches.github.io/Apktool/
```

### Icons Not Extracted
- Check if APKs exist in workspace
- Verify unzip is installed
- Check extraction logs for errors

### Framework Not Patched
- Verify baksmali/smali tools exist
- Check Java is working: `java -version`
- Review framework extraction logs

### APKs Not Patched
- Check apktool is working
- Verify APKs are decompiling correctly
- Check for signing errors

### Module Doesn't Install
- Verify ZIP is not corrupted
- Check Magisk version (24.0+ required)
- Check device compatibility (Android 13+)

### Module Installs But Nothing Changes
- Verify module is enabled in Magisk Manager
- Check if files are in `/data/adb/modules/maxregnerOS-v3/`
- Reboot device
- Clear app caches (Settings, SystemUI, Launcher)

---

## 📊 Build Process Flow

```
1. Download Firmware
   ↓
2. Extract Firmware
   ↓
3. Apply Astro Patches
   ↓
4. Enable maxregnerOS v3
   ↓
5. Extract Icons from APKs
   ↓
6. Redesign Icons (ImageMagick)
   ↓
7. Extract framework.jar
   ↓
8. Patch framework.jar (smali)
   ↓
9. Extract APKs (apktool)
   ↓
10. Patch APKs (smali/XML)
    ↓
11. Generate Fonts
    ↓
12. Generate Animations
    ↓
13. Build Magisk Module
    ↓
14. Create ZIP
    ↓
15. Output: maxregnerOS-v3-*.zip
```

---

## 🔄 Updating

To update maxregnerOS 3.0:

1. **Rebuild module:**
   ```bash
   sudo ./build.sh --build b5q
   ```

2. **Transfer new ZIP to device**

3. **Flash in Magisk Manager:**
   - Old module will be replaced
   - No need to uninstall first

4. **Reboot**

---

## 📝 Notes

- **First build takes longer** (downloads firmware, extracts everything)
- **Subsequent builds are faster** (uses cached firmware)
- **Module size varies** based on number of changes
- **Icons are device-specific** (extracted from your device's APKs)
- **Framework patches are universal** (same for all devices)

---

## 🎯 Quick Start

```bash
# 1. Install prerequisites
sudo apt-get install imagemagick openjdk-17-jdk unzip zip

# 2. Build module
sudo ./build.sh --build b5q

# 3. Install on device
# Transfer ZIP → Magisk Manager → Install → Reboot
```

---

## ❓ FAQ

**Q: Do I need to rebuild for each device?**
A: Yes, icons are extracted from device-specific APKs.

**Q: Can I use this on non-Samsung devices?**
A: Framework patches work, but APK patches are Samsung-specific.

**Q: How do I disable a feature?**
A: Comment out the feature in `Enable-maxregnerOS-v3.sh`

**Q: Can I customize the icon design?**
A: Yes, modify `Extract-and-Redesign-Icons.sh` icon generation code.

**Q: How do I add more icons?**
A: Add APK paths to the `SYSTEM_APKS` array in `Extract-and-Redesign-Icons.sh`

---

**That's it! Build, install, and enjoy maxregnerOS 3.0! 🚀**
