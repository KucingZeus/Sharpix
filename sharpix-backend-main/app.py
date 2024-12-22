from flask import Flask, request, send_file
import numpy as np
import cv2
import io
from PIL import Image

app = Flask(__name__)

def apply_high_pass_filter(image):
    rows, cols = image.shape
    crow, ccol = rows // 2, cols // 2

    mask = np.zeros((rows, cols), np.uint8)
    r = 30  # Jari-jari untuk filter
    cv2.circle(mask, (ccol, crow), r, 1, thickness=-1)

    f_transform = np.fft.fft2(image)
    f_transform_shifted = np.fft.fftshift(f_transform)

    f_transform_filtered = f_transform_shifted * (1 - mask)

    f_transform_filtered_shifted = np.fft.ifftshift(f_transform_filtered)
    image_filtered = np.fft.ifft2(f_transform_filtered_shifted)
    image_filtered = np.abs(image_filtered)

    return image_filtered

@app.route('/upload', methods=['POST'])
def restore_image():
    if 'image' not in request.files:
        return {"error": "No image provided"}, 400

    file = request.files['image']

    image = Image.open(file).convert('L')
    image = np.array(image)

    restored_image = apply_high_pass_filter(image)

    _, buffer = cv2.imencode('.png', restored_image)
    img_io = io.BytesIO(buffer)

    return send_file(img_io, mimetype='image/png', as_attachment=True, download_name='restored_image.png')

if __name__ == '__main__':
    app.run(debug=True)
