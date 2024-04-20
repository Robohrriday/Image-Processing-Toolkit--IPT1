import numpy as np
from PIL import Image

image = Image.open('img.jpg')
new_image = image.resize((128,128))

img = np.array(new_image)

modified_img = np.zeros(shape = (img.shape[0]+2, img.shape[0]+2))
modified_img[1:-1, 1:-1] = img
modified_img[0, 1:-1] = img[0,:]
modified_img[-1, 1:-1] = img[-1,:]
modified_img[1:-1, 0] = img[:,0]
modified_img[1:-1, -1] = img[:,-1]
modified_img[0,0], modified_img[0,-1], modified_img[-1,-1], modified_img[-1,0] = img[0,0], img[0, -1], img[-1,-1], img[-1,0]

with open('ip.coe','w') as f:
    f.write('memory_initialization_radix = 10;\n')
    f.write('memory_initialization_vector = \n')
    for i in range(modified_img.shape[0]):
        for j in range(modified_img.shape[1]):
            if i == modified_img.shape[0]-1 and j == modified_img.shape[1]-1:
                f.write(f'{int(modified_img[i,j])};')
            else:
                f.write(f'{int(modified_img[i,j])},\n')
                
f.close()