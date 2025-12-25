#!/usr/bin/env python3
import sys
import cv2, os, glob
import numpy as np
from edge_impulse_linux.runner import ImpulseRunner

def main():
    if len(sys.argv) != 3:
        print("使用方式: python3 classify_od.py <model.eim路徑> <圖片資料夾路徑>")
        sys.exit(1)
    
    model_path = sys.argv[1]
    image_dir = sys.argv[2]
    output_dir = "processed_results"
    os.makedirs(output_dir, exist_ok=True)
    
    runner = ImpulseRunner(model_path)
    
    try:
        model_info = runner.init()
        target_width = model_info['model_parameters']['image_input_width']
        target_height = model_info['model_parameters']['image_input_height']
        
        # 修正 1: 支援多種副檔名
        image_files = []
        for ext in ('*.png', '*.jpg', '*.jpeg', '*.bmp'):
            image_files.extend(glob.glob(os.path.join(image_dir, ext)))
        
        if not image_files:
            print(f"在 {image_dir} 中找不到任何圖片。")
            return

        print(f"🚀 模型載入成功，開始處理 {len(image_files)} 張圖片...")

        for img_path in image_files:
            img = cv2.imread(img_path)
            if img is None:
                print(f"跳過: 無法讀取 {img_path}")
                continue
            
            orig_h, orig_w = img.shape[:2]
            
            # 前處理 (BGR -> Gray)
            img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            img_gray = cv2.cvtColor(img_rgb, cv2.COLOR_RGB2GRAY)
            img_resized = cv2.resize(img_gray, (target_width, target_height))
            img_processed = img_resized.astype('float32').flatten()
            
            # 執行推論
            result = runner.classify(img_processed)
            
            # 檢查是否有物件
            if 'bounding_boxes' in result['result']:
                boxes = result['result']['bounding_boxes']
                print(f"[{os.path.basename(img_path)}] 偵測到 {len(boxes)} 個物件")
                
                for box in boxes:
                    label = box['label']
                    score = box['value']
                    if score < 0.5: continue  # 過濾低信心度

                    scale_x, scale_y = orig_w / target_width, orig_h / target_height
                    x, y = int(box['x'] * scale_x), int(box['y'] * scale_y)
                    w, h = int(box['width'] * scale_x), int(box['height'] * scale_y)
                    
                    # 繪圖
                    cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)
                    cv2.putText(img, f"{label} {score:.2f}", (x, y - 10),
                                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

                # 修正 2: 儲存位置移到這裡（處理完所有框後存一次）
                filename = os.path.basename(img_path)
                save_path = os.path.join(output_dir, f"Labeled_{filename}")
                cv2.imwrite(save_path, img)
            else:
                print(f"[{os.path.basename(img_path)}] 沒有偵測到物件")

            print(f"耗時: {result['timing']['dsp'] + result['timing']['classification']} ms")

    finally:
        runner.stop()
        print("推論引擎關閉。")

if __name__ == "__main__":
    main()
