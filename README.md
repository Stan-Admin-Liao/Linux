
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
│   ├── setup.md
│   └── Usage.md
├── logs
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

請請依序完成所有步驟，以確保資料上傳模型監控與模型更新流程可正常執行。

### Step 1：更新系統套件

```bash
    sudo apt update
    sudo apt upgrade -y
```

### Step 2：安裝基本工具

```bash
    sudo apt install -y curl jq git
```

### Step 3：安裝 Node.js 與 npm

```bash
    sudo apt install -y nodejs npm
```
 #確認版本：
```bash
    node -v
    npm -v
```

### Step 4：安裝 Edge Impulse 相關工具

```bash
    sudo npm install -g edge-impulse-cli
    sudo npm install -g edge-impulse-linux
```
 #確認是否安裝成功：
```bash
    edge-impulse-linux-runner --version
```


## 環境變數設定
本專案需使用 Edge Impulse API Key 與 Project ID

```bash
    export EI_API_KEY=ei_xxxxxxxxxxxxxxxxx
    export PROJECT_ID=123456
```
  #確認是否設定成功：
```bash  
    echo $EI_API_KEY
    echo $PROJECT_ID
```

## 專案權限設定
進入專案根目錄後，設定所有腳本為可執行：

```bash
    chmod +x scripts/*.sh
```
模型下載後需具備執行權限：

```bash
    chmod +x models/*.eim
```
此動作已在 update.sh 中自動處理，但仍建議確認
---

## 環境檢查

執行環境檢查腳本以確認所有設定是否完成：

```bash
    ./scripts/check_env.sh
```

若所有檢查項目皆顯示通過，代表安裝與設定成功。

---

## 參考文獻＆連結


**Edge Impulse Documentation**: [https://docs.edgeimpulse.com/](https://docs.edgeimpulse.com/) - 關於 CLI 工具與上傳 API 的核心規範。



---

## 開發成員

  李吉海

  廖偉喆

  邵傳允
 
