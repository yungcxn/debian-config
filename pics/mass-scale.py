from PIL import Image
import os
import sys

if len(sys.argv) < 3:
    print("Usage: python resize_image.py <input_folder> <output_folder>")
    sys.exit(1)

input_folder = sys.argv[1]
output_folder = sys.argv[2]

if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# Desired maximum size for the longer side
max_size = 3000

# Get all files in the input folder
files = sorted(os.listdir(input_folder))
counter = 1

for file_name in files:
    input_path = os.path.join(input_folder, file_name)
    
    # Skip non-files
    if not os.path.isfile(input_path):
        continue
    
    try:
        with Image.open(input_path) as img:
            width, height = img.size
            
            # Find the largest integer scale factor <= max_size
            max_scale_width = max_size // width
            max_scale_height = max_size // height
            integer_scale = min(max_scale_width, max_scale_height)
            
            if integer_scale < 1:
                integer_scale = 1
                print(f"Warning: {file_name} is too large. Using 1x scale.")
            
            new_width = width * integer_scale
            new_height = height * integer_scale
            
            # Resize using nearest neighbor
            resized_img = img.resize((new_width, new_height), Image.NEAREST)
            
            output_file = os.path.join(output_folder, f"{counter}.png")
            resized_img.save(output_file)
            
            print(f"{file_name}: {width}x{height} → {new_width}x{new_height} saved as {output_file}")
            counter += 1
    
    except Exception as e:
        print(f"Skipping {file_name}: {e}")

