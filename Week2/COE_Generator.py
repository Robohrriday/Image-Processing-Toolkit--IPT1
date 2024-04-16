import numpy as np
from PIL import Image

image = Image.open('./img.jpg')
new_image = image.resize((128,128))

img = np.array(new_image)

with open('ip.coe','w') as f:
    f.write('memory_initialization_radix = 10;\n')
    f.write('memory_initialization_vector = \n')
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            if i == img.shape[0]-1 and j == img.shape[1]-1:
                f.write(f'{img[i,j]};')
            else:
                f.write(f'{img[i,j]},\n')
                
f.close()