#!/bin/bash
# batch_upload.sh - 增强版批量上传脚本
set -e

DATA_DIR="data/collected"

# 1. 开启 nullglob，如果没有匹配到文件，变量将为空而不是保留通配符
shopt -s nullglob

for label_dir in "$DATA_DIR"/*; do
    # 确保它是一个目录
    [ -d "$label_dir" ] || continue
    
    LABEL=$(basename "$label_dir")
    
    # 2. 获取所有支持的图片格式
    IMAGES=("$label_dir"/*.jpg "$label_dir"/*.jpeg "$label_dir"/*.png "$label_dir"/*.bmp)
    
    # 3. 检查数组是否为空
    if [ ${#IMAGES[@]} -eq 0 ]; then
        echo "跳过目录 $LABEL：未找到图片文件。"
        continue
    fi

    echo "正在上传标签 [$LABEL] 的图片，共 ${#IMAGES[@]} 张..."
    
    # 调用您的上传脚本
    ./scripts/upload_data.sh "$LABEL" "${IMAGES[@]}"
done

# 关闭 nullglob 恢复环境
shopt -u nullglob
