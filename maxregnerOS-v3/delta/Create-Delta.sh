# maxregnerOS 3.0 Delta System
# Creates delta package with only changed files

LOG_BEGIN "Creating Delta Package (Changes Only)"

# Delta directory
DELTA_DIR="$DIROUT/maxregnerOS-v3-delta"
mkdir -p "$DELTA_DIR"

# Track original files
ORIGINAL_DIR="$WORKSPACE/original"
MODIFIED_DIR="$WORKSPACE/modified"

# Function to compare and copy only changes
create_delta() {
    local source_dir="$1"
    local target_dir="$2"
    local delta_target="$3"
    
    if [ ! -d "$source_dir" ] || [ ! -d "$target_dir" ]; then
        return
    fi
    
    # Find modified files
    find "$target_dir" -type f | while read -r file; do
        rel_path="${file#$target_dir/}"
        orig_file="$source_dir/$rel_path"
        
        if [ ! -f "$orig_file" ] || ! cmp -s "$orig_file" "$file" 2>/dev/null; then
            # File is new or modified
            dest_file="$delta_target/$rel_path"
            mkdir -p "$(dirname "$dest_file")"
            cp "$file" "$dest_file"
            LOG_INFO "Delta: $rel_path"
        fi
    done
}

# Create delta for different components
LOG_BEGIN "Analyzing changes..."

# Framework changes
if [ -d "$WORKSPACE/system/system/framework" ]; then
    create_delta "$ORIGINAL_DIR/framework" "$WORKSPACE/system/system/framework" "$DELTA_DIR/system/framework"
fi

# APK changes
for apk_dir in "$WORKSPACE/system/system/priv-app"/*; do
    if [ -d "$apk_dir" ]; then
        apk_name=$(basename "$apk_dir")
        create_delta "$ORIGINAL_DIR/priv-app/$apk_name" "$apk_dir" "$DELTA_DIR/system/priv-app/$apk_name"
    fi
done

# Font changes
if [ -d "$WORKSPACE/system/system/fonts" ]; then
    create_delta "$ORIGINAL_DIR/fonts" "$WORKSPACE/system/system/fonts" "$DELTA_DIR/system/fonts"
fi

# Icon changes
if [ -d "$WORKSPACE/system/system/media/icons" ]; then
    create_delta "$ORIGINAL_DIR/media/icons" "$WORKSPACE/system/system/media/icons" "$DELTA_DIR/system/media/icons"
fi

# Create delta manifest
cat > "$DELTA_DIR/delta-manifest.txt" << EOF
maxregnerOS 3.0 Delta Package
Generated: $(date)
Device: $CODENAME
Version: 3.0.0

Files changed:
$(find "$DELTA_DIR" -type f | wc -l)

Total size:
$(du -sh "$DELTA_DIR" | cut -f1)
EOF

LOG_END "Delta package created: $DELTA_DIR"
