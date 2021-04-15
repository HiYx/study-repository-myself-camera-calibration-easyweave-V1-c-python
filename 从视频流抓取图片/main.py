
import cv2 

videoCapture = cv2.VideoCapture()
videoCapture.open('./20200904_111153_000_cam1_front.avi')

fps = videoCapture.get(cv2.CAP_PROP_FPS)
frames = videoCapture.get(cv2.CAP_PROP_FRAME_COUNT)
#fps是帧率，意思是每一秒刷新图片的数量，frames是一整段视频中总的图片数量。
print("fps=",fps,"frames=",frames)

#for i in range(int(frames)):

for i in range(int(560)):
    ret,frame = videoCapture.read()
    if i>550:
        cv2.imwrite("./1-1.avi(%d).jpg"%i,frame)


