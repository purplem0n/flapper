#!/bin/bash
# Generate Android signing key for debug, profile, and release builds
# Creates android-signing.jks with alias 'androidsigning'

set -e

KEYSTORE_FILE="android-signing.jks"
ALIAS="androidsigning"
KEYSTORE_DIR="android"
KEYSTORE_APP_DIR="$KEYSTORE_DIR/app"
KEYSTORE_PATH="$KEYSTORE_APP_DIR/$KEYSTORE_FILE"

# Generate a random 16-character password
GENERATE_PASSWORD() {
    openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | head -c 16
}

# Check if keytool is available
if ! command -v keytool &>/dev/null; then
    echo "Error: keytool is required but not found."
    echo "Please install Java JDK and ensure keytool is in your PATH."
    exit 1
fi

# Check if keystore already exists
if [ -f "$KEYSTORE_PATH" ]; then
    echo "Error: Keystore file already exists at $KEYSTORE_PATH"
    echo "Delete it first if you want to regenerate."
    exit 1
fi

# Generate random password
KEY_PASSWORD=$(GENERATE_PASSWORD)
STORE_PASSWORD=$(GENERATE_PASSWORD)

# Use same password for key and store (common practice)
PASSWORD="$KEY_PASSWORD"

echo "Generating Android signing key..."
echo "================================"
echo ""
echo "Keystore: $KEYSTORE_PATH"
echo "Alias: $ALIAS"
echo "Password: $PASSWORD"
echo ""

# Create the keystore directory if it doesn't exist
mkdir -p "$KEYSTORE_APP_DIR"

# Generate the keystore
keytool -genkey \
    -v \
    -keystore "$KEYSTORE_PATH" \
    -alias "$ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "CN=Android Signing, OU=Development, O=App, L=Unknown, ST=Unknown, C=US" \
    -storepass "$PASSWORD" \
    -keypass "$PASSWORD"

# Create the key.properties file
KEY_PROPERTIES_PATH="$KEYSTORE_DIR/key.properties"

echo "Creating key.properties..."
cat > "$KEY_PROPERTIES_PATH" <<EOF
storePassword=$PASSWORD
keyPassword=$PASSWORD
keyAlias=$ALIAS
storeFile=$KEYSTORE_FILE
EOF

echo ""
echo "Keystore generated successfully!"
echo "================================"
echo ""
echo "Files created:"
echo "  - $KEYSTORE_PATH"
echo "  - $KEY_PROPERTIES_PATH"
echo ""
echo "Signing configuration:"
echo "--------------------------------"
cat "$KEY_PROPERTIES_PATH"
echo "--------------------------------"
echo ""
echo "IMPORTANT: Keep this password safe! You cannot update your app without it."
echo ""
echo "The signing key is now configured for:"
echo "  - Debug builds"
echo "  - Profile builds"
echo "  - Release builds"
echo ""
