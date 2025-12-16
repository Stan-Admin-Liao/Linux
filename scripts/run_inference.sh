#!/bin/bash
# run_inference.sh -
set -e #

#
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#
log_info() {
echo -e "${GREEN}[INFO]${NC} $1"
}
log_error() {
echo -e "${RED}[ERROR]${NC} $1" >&2
}
log_warning() {
echo -e "${YELLOW}[WARNING]${NC} $1"
}

#
main() {
local MODEL_PATH="./models/model.eim"
local SCRIPT_PATH="./scripts/classify_od.py"
if [ $# -eq 0 ]; then
log_error "使用方式: $0 <圖片路徑>"
exit 1
fi

local IMAGE_PATH=$1

#
if [ ! -f "$MODEL_PATH" ]; then
log_error "can not find model: $MODEL_PATH"
exit 1
fi

if [ ! -f "$IMAGE_PATH" ]; then
log_error "can not find image: $IMAGE_PATH"
exit 1
fi

#
log_info "..."
chmod +x "$MODEL_PATH"

if python3 "$SCRIPT_PATH" "$MODEL_PATH" "$IMAGE_PATH"; then
log_info "success"
else
log_error "fail"
exit 1
fi
}

main "$@"

