#!/bin/bash
# Universal Tauri MacOS Shipper - written by Antigravity IDE

echo "=========================================="
echo "🚀 Универсальный деплой Tauri -> /Applications"
echo "=========================================="

if [ ! -d "src-tauri" ]; then
    echo "❌ Ошибка: Запускай скрипт из корня проекта Tauri (там, где папка src-tauri)."
    exit 1
fi

echo "📦 [1/3] Запускаю сборку (release bundle)..."

if [ -f "package.json" ]; then
    if grep -q '"build:tauri"' package.json; then
        npm run build:tauri
    elif grep -q '"tauri":' package.json; then
        npm run tauri build
    else
        npx tauri build
    fi
else
    cargo tauri build
fi

if [ $? -ne 0 ]; then
    echo "❌ Ошибка компиляции! Сборка прервана."
    exit 1
fi

echo "🔍 [2/3] Ищу собранный .app файл..."
APP_BUNDLE=$(find src-tauri/target/release/bundle/macos -maxdepth 1 -name "*.app" | head -n 1)

if [ -z "$APP_BUNDLE" ]; then
    echo "❌ Ошибка: Файл .app не найден в src-tauri/target/release/bundle/macos/"
    exit 1
fi

APP_NAME=$(basename "$APP_BUNDLE")
TARGET_DIR="/Applications/$APP_NAME"

echo "🚚 [3/3] Переношу $APP_NAME в Программы (/Applications)..."
rm -rf "$TARGET_DIR"
cp -R "$APP_BUNDLE" "$TARGET_DIR"

echo "✅ ГОТОВО! Запускаю $APP_NAME..."
open "$TARGET_DIR"
