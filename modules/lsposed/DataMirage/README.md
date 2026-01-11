# Data Mirage - LSPosed Module

**Feeds fake data to trackers instead of blocking them.**

## What It Does

When apps request permissions (location, contacts, etc.), Data Mirage:
- Grants the permission (so apps don't break)
- Returns **fake data** instead of real data
- Apps think they're tracking you, but they're tracking a ghost

## Features

- **Fake GPS:** Returns location in middle of ocean (0°N, 0°E)
- **Fake Contacts:** Returns generated fake contact list
- **Fake Device Info:** Returns fake device model, serial, etc.
- **Shadow Profile:** Creates persistent fake identity per app

## Installation

1. Build APK (see build instructions)
2. Install APK
3. Enable in LSPosed Manager
4. Select scope (all apps or specific apps)
5. Reboot

## Configuration

Edit `src/main/java/com/maxregneros/datamirage/Config.java`:

```java
public class Config {
    public static final boolean ENABLE_FAKE_GPS = true;
    public static final double FAKE_LATITUDE = 0.0;  // Middle of ocean
    public static final double FAKE_LONGITUDE = 0.0;
    public static final boolean ENABLE_FAKE_CONTACTS = true;
    public static final int FAKE_CONTACT_COUNT = 50;
}
```

## How It Works

1. Hooks into `LocationManager.getLastKnownLocation()`
2. Hooks into `LocationManager.requestLocationUpdates()`
3. Hooks into `ContentResolver.query()` for contacts
4. Returns fake data instead of real data
5. Apps continue working normally, but get fake data

## Testing

1. Enable module for a test app (e.g., Facebook)
2. Grant location permission
3. Check app's location - should show 0°N, 0°E (Gulf of Guinea)
4. Check app's contacts - should see fake contacts

## Notes

- Some apps may detect fake data (unlikely but possible)
- Battery impact is minimal (just intercepting calls)
- No root required (LSPosed handles it)

## Source Code

See `MainHook.java` for implementation.
