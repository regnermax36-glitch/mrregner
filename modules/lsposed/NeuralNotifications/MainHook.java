package com.maxregneros.neuralnotifications;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * Neural Notifications - Aggregates notifications into hourly summaries
 * 
 * Collects all notifications and generates a 2-sentence summary
 * instead of showing individual notifications.
 */
public class MainHook implements IXposedHookLoadPackage {

    private static final String TAG = "NeuralNotifications";
    private static final boolean DEBUG = true;

    // Configuration
    private static final long SUMMARY_INTERVAL_MS = TimeUnit.HOURS.toMillis(1); // 1 hour
    private static final int SUMMARY_SENTENCES = 2;

    // Notification buffer
    private final List<NotificationData> notificationBuffer = new ArrayList<>();
    private final Handler handler = new Handler(Looper.getMainLooper());
    private Runnable summaryRunnable;

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        // Only hook system framework
        if (!lpparam.packageName.equals("android")) {
            return;
        }

        log("Hooking NotificationManagerService");

        try {
            Class<?> notificationServiceClass = XposedHelpers.findClass(
                "com.android.server.notification.NotificationManagerService", 
                lpparam.classLoader);

            // Hook enqueueNotificationInternal to intercept notifications
            XposedHelpers.findAndHookMethod(notificationServiceClass, 
                "enqueueNotificationInternal",
                String.class, String.class, int.class, int.class, String.class, int.class,
                android.app.Notification.class, int.class, int.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        Notification notification = (Notification) param.args[6];
                        String packageName = (String) param.args[0];
                        
                        if (notification != null) {
                            // Store notification in buffer
                            NotificationData data = new NotificationData(
                                packageName,
                                notification.extras.getCharSequence(Notification.EXTRA_TITLE),
                                notification.extras.getCharSequence(Notification.EXTRA_TEXT),
                                System.currentTimeMillis()
                            );
                            
                            synchronized (notificationBuffer) {
                                notificationBuffer.add(data);
                                log("Buffered notification from " + packageName + ": " + 
                                    data.text);
                            }
                            
                            // Cancel original notification (prevent it from showing)
                            param.setResult(null);
                            
                            // Schedule summary if not already scheduled
                            scheduleSummary();
                        }
                    }
                });

        } catch (Throwable e) {
            log("Error hooking NotificationManagerService: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Schedule summary generation
     */
    private void scheduleSummary() {
        if (summaryRunnable != null) {
            handler.removeCallbacks(summaryRunnable);
        }
        
        summaryRunnable = new Runnable() {
            @Override
            public void run() {
                generateSummary();
            }
        };
        
        handler.postDelayed(summaryRunnable, SUMMARY_INTERVAL_MS);
    }

    /**
     * Generate summary from buffered notifications
     */
    private void generateSummary() {
        synchronized (notificationBuffer) {
            if (notificationBuffer.isEmpty()) {
                return;
            }
            
            log("Generating summary from " + notificationBuffer.size() + " notifications");
            
            // Simple keyword extraction (MVP version)
            String summary = generateSimpleSummary(notificationBuffer);
            
            // Show summary notification
            showSummaryNotification(summary);
            
            // Clear buffer
            notificationBuffer.clear();
        }
    }

    /**
     * Simple summary generation (keyword extraction)
     * TODO: Replace with AI model for better results
     */
    private String generateSimpleSummary(List<NotificationData> notifications) {
        StringBuilder summary = new StringBuilder();
        
        // Extract key information from notifications
        List<String> items = new ArrayList<>();
        for (NotificationData data : notifications) {
            String item = extractKeyInfo(data);
            if (item != null && !item.isEmpty()) {
                items.add(item);
            }
        }
        
        // Limit to most important items
        int maxItems = Math.min(items.size(), 5);
        for (int i = 0; i < maxItems; i++) {
            summary.append(items.get(i));
            if (i < maxItems - 1) {
                summary.append(", ");
            }
        }
        
        // Format as 2 sentences
        String fullSummary = summary.toString();
        if (fullSummary.length() > 200) {
            fullSummary = fullSummary.substring(0, 197) + "...";
        }
        
        return fullSummary;
    }

    /**
     * Extract key information from notification
     */
    private String extractKeyInfo(NotificationData data) {
        String text = data.text != null ? data.text.toString() : "";
        String title = data.title != null ? data.title.toString() : "";
        
        // Simple extraction: use title or first part of text
        if (!title.isEmpty()) {
            return title;
        } else if (!text.isEmpty()) {
            // Take first 50 characters
            return text.length() > 50 ? text.substring(0, 47) + "..." : text;
        }
        
        return data.packageName;
    }

    /**
     * Show summary notification
     */
    private void showSummaryNotification(String summary) {
        // TODO: Use NotificationManager to show summary
        // This requires Context, which is tricky in Xposed
        // Alternative: Use XposedHelpers to get system services
        log("Summary: " + summary);
    }

    /**
     * Notification data container
     */
    private static class NotificationData {
        String packageName;
        CharSequence title;
        CharSequence text;
        long timestamp;

        NotificationData(String packageName, CharSequence title, CharSequence text, long timestamp) {
            this.packageName = packageName;
            this.title = title;
            this.text = text;
            this.timestamp = timestamp;
        }
    }

    private void log(String message) {
        if (DEBUG) {
            XposedBridge.log("[" + TAG + "] " + message);
        }
    }
}
