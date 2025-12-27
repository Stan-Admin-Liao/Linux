#!/usr/bin/env python3
import sys
import cv2, os, glob
import numpy as np
from edge_impulse_linux.runner import ImpulseRunner

def main():
    if len(sys.argv) != 3:
        print("使用方式: python3 classify_image.py <model.eim路徑> <圖片資料夾路徑>")
        sys.exit(1)
    
    model_path = sys.argv[1]
    image_dir = sys.argv[2]
    output_dir = "processed_results"
    os.makedirs(output_dir, exist_ok=True)
    
    # 初始化 Runner
    runner = ImpulseRunner(model_path)
    
    try:
        model_info = runner.init()
        # 從 model_parameters 獲取資訊，避開可能缺失的 project['sensortype']
        target_width = model_info['model_parameters']['image_input_width']
        target_height = model_info['model_parameters']['image_input_height']
        

        is_grayscale = True 

        image_files = []
        for ext in ('*.png', '*.jpg', '*.jpeg', '*.bmp'):
            image_files.extend(glob.glob(os.path.join(image_dir, ext)))
        
        if not image_files:
            print(f"在 {image_dir} 中找不到任何圖片。")
            return

        print(f"🚀 模型載入成功！")
        print(f"模型輸入尺寸: {target_width}x{target_height} ({'灰階' if is_grayscale else '彩色'})")
        print(f"開始處理 {len(image_files)} 張圖片...\n")

        for img_path in image_files:
            img = cv2.imread(img_path)
            if img is None:
                print(f"跳過: 無法讀取 {img_path}")
                continue
            
            # --- 圖片前處理 ---
            # 1. 轉為 RGB
            img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            # 2. 縮放
            img_resized = cv2.resize(img_rgb, (target_width, target_height))
            
            # 3. 如果是灰階模型，必須轉為單通道
            if is_grayscale:
                img_final = cv2.cvtColor(img_resized, cv2.COLOR_RGB2GRAY)
            else:
                img_final = img_resized

            # 4. 展平 (Flatten) 數據
            img_features = img_final.flatten().tolist()
            
            # --- 執行推論 ---
            res = runner.classify(img_features)
            
            # --- 處理分類結果 ---
            if 'classification' in res['result']:
                predictions = res['result']['classification']
                
                # 找出最高分的類別
                top_label = max(predictions, key=predictions.get)
                top_score = predictions[top_label]
                
                print(f"[{os.path.basename(img_path)}] 結果: {top_label} ({top_score:.2f})")
                
                # 在原始圖上標註文字
                display_text = f"{top_label}: {top_score:.2f}"
                cv2.putText(img, display_text, (20, 50),
                            cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0, 255, 0), 3)

                # 儲存圖片
                filename = os.path.basename(img_path)
                cv2.imwrite(os.path.join(output_dir, f"Result_{filename}"), img)
            else:
                print(f"[{os.path.basename(img_path)}] 錯誤: 無法獲得分類數據")

    finally:
        runner.stop()
        print("\n任務完成，推論引擎已關閉。")

if __name__ == "__main__":
    main()
