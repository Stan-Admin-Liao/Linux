#!/usr/bin/env python3
import cv2
import sys
import os
import glob

def process_images():
    # 1. 檢查參數是否充足 (需要 label 和 pic_dir)
    if len(sys.argv) != 3:
        print("使用說明: python bounding_box_batch.py [標籤名稱] [資料夾路徑]")
        print("範例: python bounding_box_batch.py Dog ./my_images")
        return

    label_text = sys.argv[1]
    input_dir = sys.argv[2]
    output_dir = "processed_results"

    # 2. 檢查資料夾是否存在
    if not os.path.isdir(input_dir):
        print(f"錯誤：找不到資料夾 '{input_dir}'")
        return

    # 3. 建立輸出資料夾
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # 4. 取得資料夾內所有圖片路徑 (支援多種格式)
    extensions = ("*.jpg", "*.jpeg", "*.png", "*.bmp")
    image_paths = []
    for ext in extensions:
        image_paths.extend(glob.glob(os.path.join(input_dir, ext)))

    if not image_paths:
        print("在資料夾中找不到任何圖片文件。")
        return

    print(f"開始處理，共找到 {len(image_paths)} 張圖片...")

    # 5. 批次處理
    for path in image_paths:
        img = cv2.imread(path)
        if img is None:
            continue

        h, w, _ = img.shape
        # 這裡示範畫一個佔圖片 80% 大小的框，你可以根據需求調整座標
        x, y, bw, bh = int(w*0.1), int(h*0.1), int(w*0.8), int(h*0.8)

        # 繪製矩形
        cv2.rectangle(img, (x, y), (x + bw, y + bh), (0, 255, 0), 3)
        
        # 繪製標籤
        cv2.putText(img, label_text, (x, max(y - 10, 30)),
                    cv2.FONT_HERSHEY_SIMPLEX, 1.2, (0, 255, 0), 3)

        # 儲存到輸出資料夾
        filename = os.path.basename(path)
        save_path = os.path.join(output_dir, f"labeled_{filename}")
        cv2.imwrite(save_path, img)
        print(f"已完成: {filename}")

    print(f"\n✅ 所有圖片處理完畢！結果儲存在: {output_dir}")

if __name__ == "__main__":
    process_images()
