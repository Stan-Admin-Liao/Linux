#edge impulse測試
目前進度在14周
13周內容有些沒做 （但是我們沒有要做 對吧）


[OID](https://github.com/EscVM/OIDv4_ToolKit)

[iclass](https://iclass.tku.edu.tw/course/254600)

底下分工自己改一下
# Edge Impulse Linux Client Demo

這是一個在 Linux 虛擬機上使用 Edge Impulse 進行資料收集與模型推論的專案。

##  專案結構說明
* **scripts/**: 包含所有自動化腳本（如上傳資料、執行推論）
* **data/**: 用於存放收集到的原始數據（圖片或音訊）
* **models/**: 存放從 Edge Impulse 下載的 `.eim` 模型檔案

##  如何使用

### 1. 環境設定
請確保已安裝 Edge Impulse Linux CLI 工具。

### 2. 設定 API Key
使用前請先在 `scripts/` 資料夾內的腳本中填入專案的 API Key。

### 3. 執行指令
* **上傳資料:**
  ```bash
  bash scripts/upload_data.sh
執行推論:
Bash

    bash scripts/run_inference.sh

專案結構
```
edge_impulse_demo
├── data
│   ├── ERROR.md
│   ├── new_data
│   ├── PRTSC.md
│   │   └──  .png
│   ├── setup.md
│   └── Usage.md
├── logs
│   └── .log
├── models
│   ├── model2.eim
│   ├── model3.eim
│   └── model.eim
├── processed_results
├── README.md
└── scripts
    ├── batch_upload.sh
    ├── check_env.sh
    ├── classify_od.py
    ├── ml_Pipeline.sh
    ├── retrain.sh
    ├── run_inference.sh
    └── upload_data.sh
```



👥 開發成員及分工

  李吉海:

  廖偉喆:

  邵傳允:收集訓練資料、製作Readme
