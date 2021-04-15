import cv2
import numpy as np
x_nums = 9 # x方向上的角点个数
y_nums = 3
world_point = np.zeros((x_nums * y_nums, 3), np.float32)+1700  # 生成x_nums*y_nums个坐标，每个坐标包含x,y,z三个元素
world_point[:, :2] = 100 * np.mgrid[:x_nums, :y_nums].T.reshape(-1, 2)  # mgrid[]生成包含两个二维矩阵的矩阵，每个矩阵都有x_nums列,y_nums行
world_point[:, :2]  =world_point[:, :2] +[-372,-1235]
print('world point:',world_point)