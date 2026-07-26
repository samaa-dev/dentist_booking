#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: .env file not found at $ENV_FILE"
  exit 1
fi

# Load .env (skip comments and blank lines; strip Windows CRLF).
while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line%$'\r'}"
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
  key="${line%%=*}"
  value="${line#*=}"
  key="${key#"${key%%[![:space:]]*}"}"
  key="${key%"${key##*[![:space:]]}"}"
  if [[ -n "$key" ]]; then
    export "$key=$value"
  fi
done < "$ENV_FILE"

if [[ -z "${URL_SUPABASE:-}" || -z "${SUPABASE_KEY:-}" ]]; then
  echo "Error: URL_SUPABASE and SUPABASE_KEY are required in $ENV_FILE"
  exit 1
fi

KEY_PROPERTIES="$ROOT_DIR/android/key.properties"
if [[ ! -f "$KEY_PROPERTIES" ]]; then
  echo "Error: signing config not found at $KEY_PROPERTIES"
  exit 1
fi

STORE_FILE="$(grep -E '^storeFile=' "$KEY_PROPERTIES" | head -1 | cut -d= -f2-)"
STORE_FILE="${STORE_FILE%$'\r'}"
if [[ -z "$STORE_FILE" ]]; then
  echo "Error: storeFile is missing in $KEY_PROPERTIES"
  exit 1
fi

# Gradle resolves storeFile relative to android/app/
if [[ "$STORE_FILE" = /* ]]; then
  KEYSTORE_PATH="$STORE_FILE"
else
  KEYSTORE_PATH="$ROOT_DIR/android/app/$STORE_FILE"
fi

if [[ ! -f "$KEYSTORE_PATH" ]]; then
  echo "Error: keystore not found at $KEYSTORE_PATH"
  exit 1
fi

DART_DEFINES=(
  "--dart-define=URL_SUPABASE=${URL_SUPABASE}"
  "--dart-define=SUPABASE_KEY=${SUPABASE_KEY}"
)

VERSION_FULL="$(grep -E '^version:' "$ROOT_DIR/pubspec.yaml" | head -1 | awk '{print $2}')"
if [[ -z "$VERSION_FULL" ]]; then
  echo "Error: could not read version from pubspec.yaml"
  exit 1
fi

echo "Building release APK + AAB (v${VERSION_FULL}) from ${ENV_FILE} ..."
echo "  dart-defines: URL_SUPABASE, SUPABASE_KEY"
echo ""

flutter pub get
flutter build apk --release "${DART_DEFINES[@]}"
flutter build appbundle --release "${DART_DEFINES[@]}"

APK_SRC="$ROOT_DIR/build/app/outputs/flutter-apk/app-release.apk"
AAB_SRC="$ROOT_DIR/build/app/outputs/bundle/release/app-release.aab"

if [[ ! -f "$APK_SRC" ]]; then
  echo "Error: APK not found at $APK_SRC"
  exit 1
fi
if [[ ! -f "$AAB_SRC" ]]; then
  echo "Error: AAB not found at $AAB_SRC"
  exit 1
fi

DIST_DIR="$ROOT_DIR/dist"
mkdir -p "$DIST_DIR"
DIST_APK="$DIST_DIR/dentist_booking_app_v${VERSION_FULL}.apk"
DIST_AAB="$DIST_DIR/dentist_booking_app_v${VERSION_FULL}.aab"
cp "$APK_SRC" "$DIST_APK"
cp "$AAB_SRC" "$DIST_AAB"

human_size() {
  local bytes
  bytes="$(wc -c < "$1" | tr -d ' ')"
  if command -v numfmt >/dev/null 2>&1; then
    numfmt --to=iec --suffix=B "$bytes"
  else
    echo "${bytes}B"
  fi
}

echo ""
echo "Build complete (v${VERSION_FULL}):"
echo "  APK: $DIST_APK ($(human_size "$DIST_APK"))"
echo "  AAB: $DIST_AAB ($(human_size "$DIST_AAB"))"
echo ""
echo "Also available at Flutter outputs:"
echo "  $APK_SRC"
echo "  $AAB_SRC"
