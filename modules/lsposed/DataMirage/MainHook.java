package com.maxregneros.datamirage;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * Data Mirage - Feeds fake data to trackers
 * 
 * This module hooks into system services to return fake location,
 * contacts, and device info instead of real data.
 */
public class MainHook implements IXposedHookLoadPackage {

    private static final String TAG = "DataMirage";
    private static final boolean DEBUG = true;

    // Fake location (middle of ocean)
    private static final double FAKE_LATITUDE = 0.0;
    private static final double FAKE_LONGITUDE = 0.0;
    private static final float FAKE_ACCURACY = 100.0f;

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        // Skip system packages to avoid issues
        if (lpparam.packageName.equals("android") || 
            lpparam.packageName.startsWith("com.android.")) {
            return;
        }

        log("Hooking package: " + lpparam.packageName);

        // Hook LocationManager
        hookLocationManager(lpparam);
        
        // Hook ContentResolver for contacts
        hookContacts(lpparam);
        
        // Hook device info
        hookDeviceInfo(lpparam);
    }

    /**
     * Hook LocationManager to return fake GPS location
     */
    private void hookLocationManager(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> locationManagerClass = XposedHelpers.findClass(
                "android.location.LocationManager", lpparam.classLoader);

            // Hook getLastKnownLocation
            XposedHelpers.findAndHookMethod(locationManagerClass, "getLastKnownLocation",
                String.class, new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        Location fakeLocation = createFakeLocation((String) param.args[0]);
                        param.setResult(fakeLocation);
                        log("Returned fake location for " + param.args[0]);
                    }
                });

            // Hook requestLocationUpdates (returns fake location in callback)
            XposedHelpers.findAndHookMethod(locationManagerClass, "requestLocationUpdates",
                String.class, long.class, float.class, 
                XposedHelpers.findClass("android.location.LocationListener", lpparam.classLoader),
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        // Create fake location and inject into callback
                        Location fakeLocation = createFakeLocation((String) param.args[0]);
                        Object listener = param.args[3];
                        
                        // Call onLocationChanged with fake location
                        XposedHelpers.callMethod(listener, "onLocationChanged", fakeLocation);
                        log("Injected fake location update");
                    }
                });

        } catch (Throwable e) {
            log("Error hooking LocationManager: " + e.getMessage());
        }
    }

    /**
     * Hook ContentResolver to return fake contacts
     */
    private void hookContacts(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> contentResolverClass = XposedHelpers.findClass(
                "android.content.ContentResolver", lpparam.classLoader);

            XposedHelpers.findAndHookMethod(contentResolverClass, "query",
                android.net.Uri.class, String[].class, String.class, String[].class, String.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        android.net.Uri uri = (android.net.Uri) param.args[0];
                        if (uri != null && uri.toString().contains("contacts")) {
                            // Replace with fake contacts query
                            // For now, just log - full implementation would create fake Cursor
                            log("Intercepted contacts query: " + uri);
                            // TODO: Return fake Cursor with generated contacts
                        }
                    }
                });

        } catch (Throwable e) {
            log("Error hooking ContentResolver: " + e.getMessage());
        }
    }

    /**
     * Hook device info (Build class)
     */
    private void hookDeviceInfo(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> buildClass = XposedHelpers.findClass(
                "android.os.Build", lpparam.classLoader);

            // Hook MODEL to return fake model
            XposedHelpers.findAndHookMethod(buildClass, "getString", String.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        String key = (String) param.args[0];
                        if ("MODEL".equals(key)) {
                            param.setResult("Unknown Device");
                            log("Returned fake MODEL");
                        } else if ("SERIAL".equals(key)) {
                            param.setResult("FAKE123456789");
                            log("Returned fake SERIAL");
                        }
                    }
                });

        } catch (Throwable e) {
            log("Error hooking Build: " + e.getMessage());
        }
    }

    /**
     * Create a fake Location object
     */
    private Location createFakeLocation(String provider) {
        Location location = new Location(provider);
        location.setLatitude(FAKE_LATITUDE);
        location.setLongitude(FAKE_LONGITUDE);
        location.setAccuracy(FAKE_ACCURACY);
        location.setTime(System.currentTimeMillis());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            location.setElapsedRealtimeNanos(System.nanoTime());
        }
        return location;
    }

    private void log(String message) {
        if (DEBUG) {
            XposedBridge.log("[" + TAG + "] " + message);
        }
    }
}
