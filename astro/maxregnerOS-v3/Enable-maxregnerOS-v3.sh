# maxregnerOS 3.0 - Complete Redesign
# Enables all v3 features and runs extraction/patching

LOG_BEGIN "Enabling maxregnerOS 3.0 (Complete Redesign)"

# Version
BPROP "system" "ro.maxregneros.version" "3.0.0"
BPROP "system" "ro.maxregneros.v3.enabled" "true"
BPROP "system" "ro.maxregneros.v3.magisk_module" "true"

# Enable features
FF "MAXREGNEROS_V3_ENABLED" "TRUE"
FF "MAXREGNEROS_V3_ICONS" "TRUE"
FF "MAXREGNEROS_V3_FONTS" "TRUE"
FF "MAXREGNEROS_V3_ANIMATIONS" "TRUE"

# Run extraction and patching
LOG_BEGIN "Running extraction and patching tools"

# Extract and redesign icons
if [ -f "$SCRPATH/icons/Extract-and-Redesign-Icons.sh" ]; then
    source "$SCRPATH/icons/Extract-and-Redesign-Icons.sh" || LOG_WARN "Icon extraction failed"
fi

# Extract and patch framework
if [ -f "$SCRPATH/framework/Extract-and-Patch-Framework.sh" ]; then
    source "$SCRPATH/framework/Extract-and-Patch-Framework.sh" || LOG_WARN "Framework patching failed"
fi

# Extract and patch APKs
if [ -f "$SCRPATH/apks/Extract-and-Patch-APKs.sh" ]; then
    source "$SCRPATH/apks/Extract-and-Patch-APKs.sh" || LOG_WARN "APK patching failed"
fi

# Generate fonts
if [ -f "$SCRPATH/fonts/Generate-Fonts.sh" ]; then
    source "$SCRPATH/fonts/Generate-Fonts.sh" || LOG_WARN "Font generation failed"
fi

# Generate animations
if [ -f "$SCRPATH/animations/Generate-Animations.sh" ]; then
    source "$SCRPATH/animations/Generate-Animations.sh" || LOG_WARN "Animation generation failed"
fi

LOG_END "Extraction and patching complete"

LOG_END "maxregnerOS 3.0 enabled"
