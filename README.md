




# edge impulse 分類模型
簡介
在 Linux 上使用 Edge Impulse 進行資料收集與模型推論的專案。
透過編寫 Shell Script 整合 Edge Impulse CLI，實現了從本地端上傳到雲端訓練模型。
用於分類玻璃 鐵罐 紙等回收物。

---

- [edge impulse 分類模型](#)
 - [專案結構](#專案結構)
 - [安裝指南](#安裝指南)
 - [環境檢查](#環境檢查)
 - [參考文獻＆連結](#參考文獻＆連結)
 - [開發成員](#開發成員)

---

## 專案結構
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

---

## 安裝指南

請依照以下步驟配置開發環境，確保所有自動化腳本能正常使用。

### 1. 系統依賴安裝

本專案依賴 Node.js 環境運行 Edge Impulse CLI。

```bash
# 安裝 Node.js 與 NPM
sudo apt update && sudo apt install nodejs npm

# 安裝 Edge Impulse CLI 工具鏈
npm install -g edge-impulse-cli

```

### 2. Python 推理環境

```bash
pip3 install opencv-python numpy

```

### 3. 設定 API Key

將您的 Edge Impulse 專案 API Key 加入環境變數（建議寫入 `~/.bashrc` 以長期生效）：

```bash
export EI_API_KEY='your_project_api_key_here'

```

---

## 環境檢查



---

## 參考文獻＆連結


**Edge Impulse Documentation**: [https://docs.edgeimpulse.com/](https://docs.edgeimpulse.com/) - 關於 CLI 工具與上傳 API 的核心規範。



---

## 開發成員

  李吉海

  廖偉喆

  邵傳允
 
