#!/bin/bash

# --- 顏色 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }



echo "====== 檢查環境 ======="
echo ""


COMMANDS=("python3" "curl" "git" "jq" "node")
FAILED=0

echo "===== 檢查必要指令 ====="
for cmd in "${COMMANDS[@]}"; do
    if command -v $cmd &> /dev/null; then
        log_info "✅ $cmd 已安裝"
    else
        log_error "❌ $cmd 未找到"
        FAILED=1
    fi
done

echo ""
echo "===== 檢查環境變數 ====="

if [ -z "$EI_API_KEY" ]; then
    log_error "⚠️  EI_API_KEY: 未設定"
    echo "nano ~/.bashrc"
    echo "explore EI_API_KEY"
    FAILED=1
else
    log_info "✅ EI_API_KEY: 已設定"
fi

if [ -z "$PROJECT_ID" ]; then
    log_error "⚠️  PROJECT_ID: 未設定"
    echo "nano ~/.bashrc"
    echo "explore PROJECT_ID"
    FAILED=1
else
    log_info "✅ PROJECT_ID: ${PROJECT_ID}"
fi

echo ""
echo "===== 檢查結果 ====="
if [ $FAILED -eq 0 ]; then
    log_info "🎉 所有檢查通過，環境設定正確！"
    exit 0
else
    log_error "🚫 環境檢查失敗，請安裝缺失的組件或設定變數。"
    exit 1
fi

