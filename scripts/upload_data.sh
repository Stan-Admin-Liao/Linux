#!/bin/bash
# upload_data.sh - 簡化版 Edge Impulse 上傳工具

set -e 

# --- 顏色與日誌 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# --- 預設值 ---
MODE="split" 
LABEL=""
FILES=()
LOG_DIR="logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p "$LOG_DIR"

show_usage() {
    echo -e "${GREEN}使用說明:${NC}"
    echo "  $0 [選項] <標籤> <檔案...>"
    echo ""
    echo "選項:"
    echo "  --train   	上傳至訓練集 (Training)"
    echo "  --test    	強制上傳至測試集 (Testing)"
    echo "  (無選項)      預設自動分配模式 (8:2 分配至訓練集與測試集)"
    echo ""
    echo "範例:"
    echo "  $0  --train coffee *.jpg "
    exit 0
}

# --- 檢查環境變數 ---
if [ -z "$EI_API_KEY" ]; then
    log_error "未設定 EI_API_KEY。"
    log_error "請執行: export EI_API_KEY='your_key'"
    exit 1
fi

# --- 參數解析 ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        --train)
            MODE="training"
            shift
            ;;
        --test)
            MODE="testing"
            shift
            ;;
        -h|--help)
            show_usage
            ;;
        -*)
            log_error "未知選項: $1"
            show_usage
            ;;
        *)
            if [ -z "$LABEL" ]; then
                LABEL="$1"
            else
                FILES+=("$1")
            fi
            shift
            ;;
    esac
done

# 驗證參數
if [ -z "$LABEL" ] || [ ${#FILES[@]} -eq 0 ]; then
    log_error "錯誤: 必須提供標籤與檔案。"
    show_usage
    exit 1
fi
#確認檔案路徑
if [ ! -e "${FILES[0]}" ]; then
    log_error "錯誤: 指定的路徑不存在 -> ${FILES[0]}"
    exit 1
fi

# --- 執行上傳 ---
LOG_FILE="$LOG_DIR/upload_${LABEL}_${MODE}_${TIMESTAMP}.log"

log_info "----------------------------------------"
log_info "標籤: $LABEL | 模式: $MODE"
[ "$MODE" == "split" ] && log_warning "模式提醒: 伺服器將自動執行 80/20 分配"
log_info "檔案數量: ${#FILES[@]}"
log_info "----------------------------------------"

edge-impulse-uploader \
    --api-key "$EI_API_KEY" \
    --category "$MODE" \
    --label "$LABEL" \
    "${FILES[@]}" 2>&1 | grep -E "\[[0-9]+/[0-9]+\]|Failed|Success|Done" | tee "$LOG_FILE"


log_info "日誌: $LOG_FILE"
