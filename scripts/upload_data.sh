#!/bin/bash
# upload_data.sh - 統一的 Edge Impulse 數據上傳腳本
set -e 

# --- 顏色與日誌函式定義 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# --- 預設值與變數設定 ---
LABEL=""
FILES=()
CATEGORY="training" # 預設類別
DO_SPLIT=false      # 是否執行 8:2 分配

show_usage() {
    log_info "Edge Impulse 數據上傳工具"
    echo "---------------------------------------------------------"
    echo "使用方法: $0 [-split | -t] <LABEL> <FILES...>"
    echo "選項:"
    echo "  -split       自動按 8:2 分配到 training/testing"
    echo "  -t, -test    全部上傳到 testing 類別"
    echo "  (無選項)      全部上傳到 training 類別"
    echo "---------------------------------------------------------"
    exit 0
}

# --- 檢查 API Key ---
if [ -z "$EI_API_KEY" ]; then
    log_error "環境變數 EI_API_KEY 未設定。"
    exit 1
fi

# --- 參數解析 ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -split)
            DO_SPLIT=true
            shift
            ;;
        -t|-test)
            CATEGORY="testing"
            shift
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            if [ -z "$LABEL" ]; then
                LABEL="$1"
            else
                FILES+=("$1") # 收集所有路徑
            fi
            shift
            ;;
    esac
done

# --- 檢查必要參數 ---
if [ -z "$LABEL" ] || [ ${#FILES[@]} -eq 0 ]; then
    log_error "缺少標籤名稱或文件路徑。"
    show_usage
fi

LOG_FILE="$LOG_DIR/upload_${LABEL}_${TIMESTAMP}.txt"

# --- 執行上傳邏輯 ---
if [ "$DO_SPLIT" = true ]; then
    log_info "模式: 自動分配 (8:2)"
    
    TOTAL=${#FILES[@]}
    TRAIN_COUNT=$(( TOTAL * 8 / 10 ))
    
    # 數組切片
    TRAIN_FILES=("${FILES[@]:0:$TRAIN_COUNT}")
    TEST_FILES=("${FILES[@]:$TRAIN_COUNT}")

    if [ ${#TRAIN_FILES[@]} -gt 0 ]; then
        log_info "正在上傳訓練集 (${#TRAIN_FILES[@]} files)..."
        edge-impulse-uploader --api-key "$EI_API_KEY" --category training --label "$LABEL" "${TRAIN_FILES[@]}" | tee -a "$LOG_FILE"
    fi

    if [ ${#TEST_FILES[@]} -gt 0 ]; then
        log_info "正在上傳測試集 (${#TEST_FILES[@]} files)..."
        edge-impulse-uploader --api-key "$EI_API_KEY" --category testing --label "$LABEL" "${TEST_FILES[@]}" | tee -a "$LOG_FILE"
    fi
else
    log_info "模式: 固定類別 ($CATEGORY)"
    edge-impulse-uploader --api-key "$EI_API_KEY" --category "$CATEGORY" --label "$LABEL" "${FILES[@]}" | tee "$LOG_FILE"
fi

log_info "完成！日誌已保存至: $LOG_FILE"
