import matrepr

img_1 = [[1, 1, 1, 0, 0, 1, 1, 1],
		[1, 1, 0, 1, 0, 1, 1, 1],
		[1, 0, 1, 1, 0, 1, 1, 1],
		[1, 1, 1, 1, 0, 1, 1, 1],
		[1, 1, 1, 1, 0, 1, 1, 1],
		[1, 1, 1, 1, 0, 1, 1, 1],
		[1, 1, 1, 1, 0, 1, 1, 1],
		[1, 1, 1, 0, 0, 0, 1, 1]]

img_0 = [[1, 1, 1, 0, 0, 1, 1, 1],
		[1, 1, 0, 0, 0, 0, 1, 1],
		[1, 0, 0, 1, 1, 0, 0, 1],
		[1, 0, 1, 1, 1, 1, 0, 1],
		[1, 0, 1, 1, 1, 1, 0, 1],
		[1, 0, 0, 1, 1, 0, 0, 1],
		[1, 1, 0, 0, 0, 0, 1, 1],
		[1, 1, 1, 0, 0, 1, 1, 1]]

img_plus = [[1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 0, 0, 1, 1, 1],
		[1, 1, 1, 0, 0, 1, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 0, 0, 1, 1, 1],
		[1, 1, 1, 0, 0, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1]]

img_b2 = [[1, 1, 1, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 0],
		[1, 1, 1, 1, 1, 1, 1, 0],
		[1, 1, 1, 1, 1, 1, 1, 0],
		[1, 1, 1, 1, 1, 1, 0, 0],
		[1, 1, 1, 1, 1, 0, 0, 0],
		[1, 1, 1, 1, 0, 0, 0, 0],
		[1, 0, 0, 0, 0, 0, 0, 0]]

def convert_bits(img):
    for i in range(len(img)):
        for j in range(len(img[i])):
            if img[i][j] == 0:
                img[i][j] = -1

def flatten_img(img):
    return [pixel for row in img for pixel in row]

imgs = [img_0, img_1, img_plus, img_b2]

for img in imgs:
    convert_bits(img)

N = 64 # no. neurons
W = [[0 for _ in range(N)] for _ in range(N)] # initialize empty weight matrix W
patterns = [flatten_img(img) for img in imgs]

for pattern in patterns:
    for i in range(N):
        for j in range(N):
            if i != j:
                W[i][j] += pattern[i] * pattern[j]

for i in range(N):
    W[i][i] = 0

matrepr.mprint(W)