import numpy as np
from PIL import Image


image = Image.open('img.jpg')
new_image = image.resize((128,128))

img = np.array(new_image)

with open('Image.txt','w') as f:
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            s = bin(img[i,j])[2:]
            if len(s) != 8:
                s = '0'*(8-len(s)) + s
            if i == img.shape[0]-1 and j == img.shape[1]-1:
                f.write(f'{s}')
            else:
                f.write(f'{s}\n')
                
f.close()