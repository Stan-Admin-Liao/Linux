#!/bin/bash

# --- 參數設定 ---
PROJECT_ID="855277"
LEARN_ID="8"

if [ -z "$EI_API_KEY" ]; then
    echo "❌ 錯誤：環境變數 \$EI_API_KEY 為空，請先執行 export EI_API_KEY='你的Key'"
    exit 1
fi

echo "🚀 [Edge Impulse] 觸發專案 $PROJECT_ID 訓練 (ID: $LEARN_ID)..."

# 1. 發送觸發請求
RESPONSE=$(curl -s -X POST "https://studio.edgeimpulse.com/v1/api/${PROJECT_ID}/jobs/train/keras/${LEARN_ID}" \
  -H "x-api-key: ${EI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"mode": "visual"}')

# 簡單檢查觸發是否成功
if [[ "$RESPONSE" != *"success\":true"* ]]; then
    echo "❌ 觸發失敗！伺服器回應：$RESPONSE"
    exit 1
fi

echo "✅ 訓練已成功啟動！"
echo "⏳ 等待所有作業完成 (監控 totalJobCount)..."

# 2. 監控總作業數是否歸零
# 先等待 5 秒，確保伺服器已將作業排入隊列
sleep 5

while true; do
    # 獲取當前進行中的作業總數
    JOB_COUNT=$(curl -s https://studio.edgeimpulse.com/v1/api/${PROJECT_ID}/jobs \
        -H "x-api-key: ${EI_API_KEY}" | jq '.totalJobCount')

    # 如果 count 是 0，表示沒有正在進行的作業
    if [ "$JOB_COUNT" -eq 0 ]; then
        echo -e "\n🎉 [完成] 所有作業已結束 (totalJobCount = 0)。"
        break
    fi

    # 顯示狀態並等待
    printf "\r⏳ 正在進行中，目前剩餘作業數: $JOB_COUNT ... "
    sleep 10
done

echo "------------------------------------------"
echo "✅ 重新訓練流程順利結束。"
