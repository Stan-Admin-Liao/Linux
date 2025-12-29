#!/bin/bash
set -e

# --- 顏色 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }


# --- 參數設定 ---
if [ -z "$EI_API_KEY" ]; then
    log_error "❌ 錯誤：環境變數 EI_API_KEY 為空，請先執行 export EI_API_KEY='你的Key'"
    exit 1
fi

log_info "🚀 [Edge Impulse] 觸發專案 $PROJECT_ID 訓練 (ID: $LEARNING_BLOCK_ID)..."

FIRST_JOB_COUNT=$(curl -s https://studio.edgeimpulse.com/v1/api/${PROJECT_ID}/jobs \
        -H "x-api-key: ${EI_API_KEY}" | jq '.totalJobCount')

# 1. 發送觸發請求
RESPONSE=$(curl -s -X POST \
  "https://studio.edgeimpulse.com/v1/api/${PROJECT_ID}/jobs/train/keras/${LEARNING_BLOCK_ID}" \
  -H "x-api-key: ${EI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"mode": "visual"}')

# 簡單檢查觸發是否成功
if [[ "$RESPONSE" != *"success\":true"* ]]; then
    log_error "❌ 觸發失敗！伺服器回應：$RESPONSE"
    exit 1
fi

log_info "✅ 訓練已成功啟動！"
echo "⏳ 等待所有作業完成 ..."


# 先等待 5 秒，確保伺服器已將作業排入隊列
sleep 5

while true; do
    JOB_COUNT=$(curl -s https://studio.edgeimpulse.com/v1/api/${PROJECT_ID}/jobs \
        -H "x-api-key: ${EI_API_KEY}" | jq '.totalJobCount')

  
    if [ "$JOB_COUNT" -eq $FIRST_JOB_COUNT ]; then
    	printf "\r                 "
        log_info "\n🎉 [完成] 所有作業已結束 "
        break
    fi

    # 顯示狀態並等待
    printf "\r⏳ 正在進行中，目前剩餘作業數: $JOB_COUNT     \b\b\b\b"
    sleep 2
    printf "."
    sleep 2
    printf "."
    sleep 2
    printf "."
    sleep 2
    printf "."
    sleep 2
done

echo "------------------------------------------"
log_info "✅ 重新訓練流程順利結束。"
