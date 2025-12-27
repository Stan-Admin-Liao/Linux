# 錯誤與錯誤處理紀錄


## API Returns null
[picture](PRTSC/pic1)

### 問題原因
1.在回應的 JSON 中找不到 .impulse.learn 這個路徑
2.尚未定義 Impulse learnBlocks
### 解決方式
先到網站上查看有沒有設定learning block
[picture](PRTSC/pic2)

輸入 
`curl -s "https://studio.edgeimpulse.com/v1/api/${PROJECT_ID}/impulse" -H "x-api-key: ${EI_API_KEY}" | jq '.'`
查看原始 JSON
[picture](PRTSC/pic3)

找到正確的路徑是.impulse.learnBlocks 不是.impulse.learn
修改指令為
`curl -s "https://studio.edgeimpulse.com/v1/api/${PROJECT_ID}/impulse" -H "x-api-key: ${EI_API_KEY}" | jq '.impulse.learnBlocks'`

## Cannot POST /v1/api/${PROJECT_ID}/jobs/train/${LEARNING_BLOCK_ID}
[picture](PRTSC/pic4)

### 問題原因
URL 路徑不正確
在 Edge Impulse API 中，沒有/jobs/train/${LEARNING_BLOCK_ID}這個端點
### 解決方式
從官方 API 裡面找正確的路徑
https://docs.edgeimpulse.com/apis
[picture](PRTSC/pic5)


