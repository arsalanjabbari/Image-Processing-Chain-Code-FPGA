from PIL import Image
import numpy as np


def image_to_array(img_path):
    # Open the image using Pillow
    img = Image.open(img_path).convert('L')  # 'L' mode converts to grayscale

    # Resize the image to 64x64
    img = img.resize((64, 64))

    # Convert the image to a NumPy array
    img_array = np.array(img)

    for i in range(len(img_array)):
        for j in range(len(img_array[0])):
            if img_array[i][j] < 100:
                img_array[i][j] = 1
            else:
                img_array[i][j] = 0

    return img_array
l

# Replace 'your_image_path.png' with the path to your black & white image
image_path = './Pic 2_64 Pix.jpg'
result_array = image_to_array(image_path)

text_file = open("input.txt", "w")

for i in result_array:
    stringeman = ""
    for j in i:
        stringeman += str(j)

    text_file.write(stringeman + "\n")
text_file.close()

start_i = 0
start_j = 0

flag = False
for i in range(64):
    for j in range(64):
        if result_array[i][j] == 1:
            start_i = i
            start_j = j
            flag = True
            break
    if flag:
        break

########################################################################################################################
print("The Start I : ", start_i)
print("The Start J : ", start_j)
print(result_array[start_i][start_j])
directions = {0: (0, 1), 1: (-1, 1), 2: (-1, 0), 3: (-1, -1), 4: (0, -1), 5: (1, -1), 6: (1, 0), 7: (1, 1)}

current_i = start_i
current_j = start_j

path = []


while True:
    for direction in range(8):
        if result_array[current_i + directions[direction][0]][current_j + directions[direction][1]] == 1:
            if result_array[current_i + directions[(direction + 1) % 8][0]][current_j + directions[(direction + 1) % 8][1]] == 0:
                print("The Current State is ", (current_i, current_j))
                print("Run " + "Direction " + str(directions[direction]))
                current_i += directions[direction][0]
                current_j += directions[direction][1]
                path += [direction]
                break


    if current_i == start_i and current_j == start_j:
        break
print(path)