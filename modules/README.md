# maxregnerOS Modules

This directory contains LSPosed modules, Magisk modules, and services for maxregnerOS features.

## Directory Structure

```
modules/
├── lsposed/          # LSPosed modules (runtime hooks)
├── magisk/           # Magisk modules (system-level)
└── services/         # Native services and scripts
```

## Installation

### LSPosed Modules

1. Install LSPosed Manager
2. Enable module in LSPosed
3. Select target apps/scope
4. Reboot

### Magisk Modules

1. Flash via Magisk Manager
2. Reboot
3. Configure via sysfs or properties

### Services

1. Copy to `/system/etc/init.d/` or `/system/bin/`
2. Set permissions: `chmod 755`
3. Add to init scripts

## Module Status

| Module | Status | Difficulty |
|--------|--------|-----------|
| Data Mirage | 🟡 Template | Easy |
| Neural Notifications | 🟡 Template | Medium |
| Panic Grip | 🟡 Template | Medium |
| Pre-emptive Launch | 🟡 Planned | Hard |
| Reactive Icons | 🟡 Planned | Hard |
| Kill Switch | 🔴 Requires Kernel | Very Hard |

## Development

See `../astro/maxregnerOS/IMPLEMENTATION.md` for detailed implementation guides.
