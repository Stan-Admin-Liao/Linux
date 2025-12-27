#!/bin/bash

echo "====== 檢查環境 ======="
echo ""


COMMANDS=("python3" "curl" "git" "jq" "node")
FAILED=0

echo "===== 檢查必要指令 ====="
for cmd in "${COMMANDS[@]}"; do
    if command -v $cmd &> /dev/null; then
        echo "✅ $cmd 已安裝"
    else
        echo "❌ $cmd 未找到"
        FAILED=1
    fi
done

echo ""
echo "===== 檢查環境變數 ====="

if [ -z "$EI_API_KEY" ]; then
    echo "⚠️  EI_API_KEY: 未設定"
    echo "nano ~/.bashrc"
    echo "explore EI_API_KEY"
    FAILED=1
else
    echo "✅ EI_API_KEY: 已設定"
fi

if [ -z "$PROJECT_ID" ]; then
    echo "⚠️  PROJECT_ID: 未設定"
    echo "nano ~/.bashrc"
    echo "explore PROJECT_ID"
    FAILED=1
else
    echo "✅ PROJECT_ID: ${PROJECT_ID}"
fi

echo ""
echo "===== 檢查結果 ====="
if [ $FAILED -eq 0 ]; then
    echo "🎉 所有檢查通過，環境設定正確！"
    exit 0
else
    echo "🚫 環境檢查失敗，請安裝缺失的組件或設定變數。"
    exit 1
fi

