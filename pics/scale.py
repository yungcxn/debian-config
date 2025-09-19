from PIL import Image
import os
import sys

if len(sys.argv) < 2:
    print("Usage: python resize_image.py <input_image>")
    sys.exit(1)

input_path = sys.argv[1]
output_path = f"scaled-{input_path}"

# Desired maximum size for the longer side
max_size = 3000

# Open the image
with Image.open(input_path) as img:
    width, height = img.size
    
    # Find the largest integer scale factor that keeps both dimensions <= max_size
    max_scale_width = max_size // width
    max_scale_height = max_size // height
    integer_scale = min(max_scale_width, max_scale_height)
    
    # If no integer scaling is possible (image is already larger than max_size), use 1x
    if integer_scale < 1:
        integer_scale = 1
        print(f"Warning: Image is too large for integer upscaling. Using 1x scale.")
    
    # Calculate new dimensions using integer scaling
    new_width = width * integer_scale
    new_height = height * integer_scale
    
    # Resize using nearest neighbor to preserve pixel boundaries (true integer scaling)
    resized_img = img.resize((new_width, new_height), Image.NEAREST)
    
    # Save the resized image
    resized_img.save(output_path)

print(f"Image integer scaled by {integer_scale}x to {new_width}x{new_height} and saved to {output_path}")
print(f"Original: {width}x{height} → Scaled: {new_width}x{new_height}")

