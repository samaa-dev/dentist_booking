#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ENV_FILE="$ROOT_DIR/.env"
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
  echo "Error: URL_SUPABASE and SUPABASE_KEY are required in .env"
  exit 1
fi

DART_DEFINES=(
  "--dart-define=URL_SUPABASE=${URL_SUPABASE}"
  "--dart-define=SUPABASE_KEY=${SUPABASE_KEY}"
)

OPTIONAL_VARS=(
  CLINIC_DISPLAY_NAME
  CLINIC_TAGLINE
  CLINIC_ROOM_NUMBER
  CLINIC_DOCTOR_NAME
  TV_ANNOUNCEMENT_ENABLED
  TV_OVERLAY_HOLD_AFTER_SPEECH_MS
  TV_OVERLAY_HOLD_WHEN_SILENT_MS
)

for var in "${OPTIONAL_VARS[@]}"; do
  val="${!var:-}"
  if [[ -n "$val" ]]; then
    DART_DEFINES+=("--dart-define=${var}=${val}")
  fi
done

echo "Building release APK with values from .env ..."
flutter build apk --release "${DART_DEFINES[@]}"

APK_PATH="$ROOT_DIR/build/app/outputs/flutter-apk/app-release.apk"
VERSION="$(grep -E '^version:' "$ROOT_DIR/pubspec.yaml" | head -1 | awk '{print $2}' | cut -d'+' -f1)"
DIST_DIR="$ROOT_DIR/dist"
mkdir -p "$DIST_DIR"
DIST_APK="$DIST_DIR/dentist_booking_tv_v${VERSION}.apk"
cp "$APK_PATH" "$DIST_APK"

echo ""
echo "Build complete:"
echo "  $APK_PATH"
echo "  $DIST_APK"
