#!/bin/bash

# Function to escape special characters for sed
escape_sed() {
    echo "$1" | sed 's/[\/&]/\\&/g'
}

# Function to prompt for input if not provided (reads from stdin)
prompt_if_empty() {
    local var_name=$1
    local prompt_text=$2
    local var_value=${!var_name}
    
    if [ -z "$var_value" ]; then
        read -p "$prompt_text: " var_value
    fi
    
    echo "$var_value"
}

# Prompt reading from /dev/tty (for when stdin is the curl pipe but user is at a terminal)
prompt_from_tty() {
    local prompt_text=$1
    local default_val=${2:-}
    read -p "$prompt_text: " var_value < /dev/tty
    echo "${var_value:-$default_val}"
}

# Get package ID, app name, and proper name from arguments or prompt
# When run from clone.sh with one arg (target dir), that is the default app name.
PACKAGE_ID=${1:-""}
APP_NAME=${2:-""}
PROPER_NAME=${3:-""}

# When stdin is not a TTY (e.g. curl ... | bash), do not read from stdin — it's the script.
# If we have one arg and the user is at a terminal (stdout TTY + /dev/tty), prompt via /dev/tty.
# Otherwise use args/defaults so we don't corrupt pubspec (e.g. in CI).
if [[ ! -t 0 ]]; then
    if [[ -n "$1" && -z "$2" ]] && [[ -t 1 && -e /dev/tty ]]; then
        # Single arg from clone + terminal: prompt from /dev/tty, use $1 as default app name
        echo ""
        PACKAGE_ID=$(prompt_from_tty "Enter package ID (e.g., com.yourcompany.yourapp)" "com.example.$1")
        APP_NAME=$(prompt_from_tty "Enter app name (e.g., yourapp)" "$1")
        PROPER_NAME=$(prompt_from_tty "Enter proper name (e.g., MyApp)" "$(echo "${1:0:1}" | tr '[:lower:]' '[:upper:]')${1:1}")
    elif [[ -n "$1" && -z "$2" ]]; then
        # Single arg, no terminal (CI): use as app name
        APP_NAME="$1"
        PACKAGE_ID="com.example.${APP_NAME}"
        PROPER_NAME="$(echo "${APP_NAME:0:1}" | tr '[:lower:]' '[:upper:]')${APP_NAME:1}"
    else
        APP_NAME=${APP_NAME:-flapper}
        PACKAGE_ID=${PACKAGE_ID:-com.example.${APP_NAME}}
        PROPER_NAME=${PROPER_NAME:-$(echo "${APP_NAME:0:1}" | tr '[:lower:]' '[:upper:]')${APP_NAME:1}}
    fi
else
    PACKAGE_ID=$(prompt_if_empty PACKAGE_ID "Enter package ID (e.g., com.yourcompany.yourapp)")
    APP_NAME=$(prompt_if_empty APP_NAME "Enter app name (e.g., yourapp)")
    PROPER_NAME=$(prompt_if_empty PROPER_NAME "Enter proper name (e.g., MyApp)")
fi

# Escape special characters for sed
ESCAPED_PACKAGE_ID=$(escape_sed "$PACKAGE_ID")
ESCAPED_APP_NAME=$(escape_sed "$APP_NAME")
ESCAPED_PROPER_NAME=$(escape_sed "$PROPER_NAME")

echo "Replacing 'com.example.flapper' with '$PACKAGE_ID'..."
echo "Replacing 'Flapper' with '$PROPER_NAME'..."
echo "Replacing 'flapper' with '$APP_NAME'..."

# Perform replacements using find -exec for reliability
# Order: com.example.flapper (longest) -> Flapper (capitalized) -> flapper (lowercase)
if [[ "$OSTYPE" == "darwin"* ]]; then
    find . -type f \( \
        -name "*.dart" -o \
        -name "*.yaml" -o \
        -name "*.kt" -o \
        -name "*.kts" -o \
        -name "*.xml" -o \
        -name "*.plist" -o \
        -name "*.xcconfig" -o \
        -name "*.pbxproj" -o \
        -name "*.xcscheme" -o \
        -name "*.json" -o \
        -name "*.html" -o \
        -name "*.cc" -o \
        -name "*.cpp" -o \
        -name "*.rc" -o \
        -name "CMakeLists.txt" -o \
        -name "*.md" \
    \) ! -path "*/\.*" ! -path "*/build/*" ! -path "*/node_modules/*" ! -path "*/\.dart_tool/*" \
    -exec sed -i '' "s/com\.example\.flapper/$ESCAPED_PACKAGE_ID/g" {} +
    
    find . -type f \( \
        -name "*.dart" -o \
        -name "*.yaml" -o \
        -name "*.kt" -o \
        -name "*.kts" -o \
        -name "*.xml" -o \
        -name "*.plist" -o \
        -name "*.xcconfig" -o \
        -name "*.pbxproj" -o \
        -name "*.xcscheme" -o \
        -name "*.json" -o \
        -name "*.html" -o \
        -name "*.cc" -o \
        -name "*.cpp" -o \
        -name "*.rc" -o \
        -name "CMakeLists.txt" -o \
        -name "*.md" \
    \) ! -path "*/\.*" ! -path "*/build/*" ! -path "*/node_modules/*" ! -path "*/\.dart_tool/*" \
    -exec sed -i '' "s/Flapper/$ESCAPED_PROPER_NAME/g" {} +
    
    find . -type f \( \
        -name "*.dart" -o \
        -name "*.yaml" -o \
        -name "*.kt" -o \
        -name "*.kts" -o \
        -name "*.xml" -o \
        -name "*.plist" -o \
        -name "*.xcconfig" -o \
        -name "*.pbxproj" -o \
        -name "*.xcscheme" -o \
        -name "*.json" -o \
        -name "*.html" -o \
        -name "*.cc" -o \
        -name "*.cpp" -o \
        -name "*.rc" -o \
        -name "CMakeLists.txt" -o \
        -name "*.md" \
    \) ! -path "*/\.*" ! -path "*/build/*" ! -path "*/node_modules/*" ! -path "*/\.dart_tool/*" \
    -exec sed -i '' "s/flapper/$ESCAPED_APP_NAME/g" {} +
else
    find . -type f \( \
        -name "*.dart" -o \
        -name "*.yaml" -o \
        -name "*.kt" -o \
        -name "*.kts" -o \
        -name "*.xml" -o \
        -name "*.plist" -o \
        -name "*.xcconfig" -o \
        -name "*.pbxproj" -o \
        -name "*.xcscheme" -o \
        -name "*.json" -o \
        -name "*.html" -o \
        -name "*.cc" -o \
        -name "*.cpp" -o \
        -name "*.rc" -o \
        -name "CMakeLists.txt" -o \
        -name "*.md" \
    \) ! -path "*/\.*" ! -path "*/build/*" ! -path "*/node_modules/*" ! -path "*/\.dart_tool/*" \
    -exec sed -i "s/com\.example\.flapper/$ESCAPED_PACKAGE_ID/g" {} +
    
    find . -type f \( \
        -name "*.dart" -o \
        -name "*.yaml" -o \
        -name "*.kt" -o \
        -name "*.kts" -o \
        -name "*.xml" -o \
        -name "*.plist" -o \
        -name "*.xcconfig" -o \
        -name "*.pbxproj" -o \
        -name "*.xcscheme" -o \
        -name "*.json" -o \
        -name "*.html" -o \
        -name "*.cc" -o \
        -name "*.cpp" -o \
        -name "*.rc" -o \
        -name "CMakeLists.txt" -o \
        -name "*.md" \
    \) ! -path "*/\.*" ! -path "*/build/*" ! -path "*/node_modules/*" ! -path "*/\.dart_tool/*" \
    -exec sed -i "s/Flapper/$ESCAPED_PROPER_NAME/g" {} +
    
    find . -type f \( \
        -name "*.dart" -o \
        -name "*.yaml" -o \
        -name "*.kt" -o \
        -name "*.kts" -o \
        -name "*.xml" -o \
        -name "*.plist" -o \
        -name "*.xcconfig" -o \
        -name "*.pbxproj" -o \
        -name "*.xcscheme" -o \
        -name "*.json" -o \
        -name "*.html" -o \
        -name "*.cc" -o \
        -name "*.cpp" -o \
        -name "*.rc" -o \
        -name "CMakeLists.txt" -o \
        -name "*.md" \
    \) ! -path "*/\.*" ! -path "*/build/*" ! -path "*/node_modules/*" ! -path "*/\.dart_tool/*" \
    -exec sed -i "s/flapper/$ESCAPED_APP_NAME/g" {} +
fi

# Handle directory rename for Android package structure
if [ -d "android/app/src/main/kotlin/com/example/flapper" ]; then
    NEW_PACKAGE_PATH=$(echo "$PACKAGE_ID" | tr '.' '/')
    mkdir -p "android/app/src/main/kotlin/$NEW_PACKAGE_PATH"
    if [ -n "$(ls -A android/app/src/main/kotlin/com/example/flapper 2>/dev/null)" ]; then
        mv "android/app/src/main/kotlin/com/example/flapper"/* "android/app/src/main/kotlin/$NEW_PACKAGE_PATH/" 2>/dev/null
    fi
    rmdir "android/app/src/main/kotlin/com/example/flapper" 2>/dev/null || true
    rmdir "android/app/src/main/kotlin/com/example" 2>/dev/null || true
    rmdir "android/app/src/main/kotlin/com" 2>/dev/null || true
fi

echo "Replacements complete!"
echo ""
echo "Running Flutter setup commands..."

flutter clean
flutter pub get
dart run flutter_launcher_icons:generate
dart run flutter_native_splash:create
