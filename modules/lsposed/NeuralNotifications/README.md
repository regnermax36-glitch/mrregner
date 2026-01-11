# Neural Notifications - LSPosed Module

**One hourly briefing instead of 50 notifications.**

## What It Does

Instead of showing individual notifications, this module:
- Collects all notifications for one hour
- Uses AI (or keyword extraction) to summarize them
- Shows **one notification** with a 2-sentence summary
- Example: *"Mark asked about the project files, Mom wants to know if you're coming for dinner, and your package was delivered."*

## Features

- **Notification Aggregation:** Collects all notifications for configurable interval
- **AI Summary:** Generates 2-sentence summary (can use local NLP or simple extraction)
- **Source Tracking:** Aggregates from email, WhatsApp, system alerts, etc.
- **Smart Grouping:** Groups related notifications together

## Installation

1. Build APK
2. Install APK
3. Enable in LSPosed Manager
4. Enable for system framework
5. Reboot
6. Configure summary interval in module settings

## Configuration

- **Summary Interval:** Default 3600 seconds (1 hour)
- **Summary Sources:** email, whatsapp, system, all
- **Summary Length:** 2 sentences (configurable)
- **AI Model:** Local (TensorFlow Lite) or simple keyword extraction

## How It Works

1. Hooks into `NotificationManagerService.enqueueNotificationInternal()`
2. Intercepts all notifications before they're shown
3. Stores them in buffer
4. Every hour (or configured interval):
   - Processes buffer
   - Generates summary using AI or keywords
   - Cancels original notifications
   - Shows single summary notification

## Implementation Notes

### Simple Version (MVP)
- Use keyword extraction
- Extract: sender, action, subject
- Format as 2 sentences
- No AI required

### Advanced Version
- Use TensorFlow Lite model
- On-device NLP processing
- Better summarization
- Context understanding

## Testing

1. Enable module
2. Receive multiple notifications
3. Wait for summary interval
4. Check notification - should see one summary notification
5. Original notifications should be hidden

## Source Code

See `MainHook.java` for implementation.
