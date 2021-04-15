# OpenCV_test_3.py

# this program tracks a red ball
# (no motor control is performed to move the camera, we will get to that later in the tutorial)

import os
import os
import sys
import cv2
import numpy as np
import time 
import datetime
import zhuanma


def getFileList(dir, fileList=[]):
    """
    遍历一个目录,输出所有文件名
    param dir: 待遍历的文件夹
    param fileList : 保存文件名的列表
    return fileList: 文件名列表
    """
    newDir = dir
    if os.path.isfile(dir):
        fileList.append(dir)
    elif os.path.isdir(dir):
        for s in os.listdir(dir):
            # 如果需要忽略某些文件夹，使用以下代码
            # if s == "xxx":
            # continue
            newDir = os.path.join(dir, s)
            getFileList(newDir, fileList)
    return fileList

def readStrFromFile(filePath):
    """
    从文件中读取字符串str
    param filePath: 文件路径
    return string : 文本字符串
    """
    with open(filePath, "rb") as f:
        string = f.read()
    return string


def readLinesFromFile(filePath):
    """
    从文件中读取字符串列表list
    param filePath: 文件路径
    return lines  : 文本字符串列表
    """
    with open(filePath, "rb") as f:
        lines = f.readlines()
    return lines


def writeStrToFile(filePath, string):
    """
    将字符串写入文件中
    param filePath: 文件路径
    param string  : 字符串str
    """
    with open(filePath, "wb") as f:
        f.write(string)


def appendStrToFile(filePath, string):
    """
    将字符串追加写入文件中
    param filePath: 文件路径
    param string  : 字符串str
    """
    with open(filePath, "ab") as f:
        f.write(string)


def dumpToFile(filePath, content):
    """
    将数据类型序列化存入本地文件
    param filePath: 文件路径
    param content : 待保存的内容(list, dict, tuple, ...)
    """
    import pickle
    with open(filePath, "wb") as f:
        pickle.dump(content, f)


def loadFromFile(filePath):
    """
    从本地文件中加载序列化的内容
    param filePath: 文件路径
    return content: 序列化保存的内容(e.g. list, dict, tuple, ...)
    """
    import pickle
    with open(filePath) as f:
        content = pickle.load(f)
    return content

def jiema(string):
    """
    将字符串转为unicode编码
    param string: 待转码的字符串
    return      : unicode编码的字符串
    """
    from zhuanma import strdecode
    return strdecode(string)


def filterReturnChar(string):
    """
    过滤字符串中的"\r"字符
    :param string:
    :return: 过滤了"\r"的字符串
    """
    return string.replace("\r", "")


def encodeUTF8(string):
    """
    将字符串转码为UTF-8编码
    :param string:
    :return: UTF-8编码的字符串
    """
    return jiema(string).encode("utf-8")


def filterCChar(string):
    """
    过滤出字符串中的汉字
    :param string: 待过滤字符串
    :return: 汉字字符串
    """
    import re
    hanzi = re.compile(u"[\u4e00-\u9fa5]+", re.U)
    return "".join(re.findall(hanzi, string))

def read_file(file):
        """
        read .md or .txt format file
        :param file: .md or .txt format file
        :return: data
        """
        with open('example.md') as f:
            lines = f.readlines()
        data = []
        for line in lines:
            data.append([int(i) for i in line.strip().split(' ')])
        return np.array(data)


def Operations4(var1):
    #var1 = '长风破浪会有时'+os.linesep+'直挂云帆济沧海'+os.linesep
    var1 = var1 +os.linesep
    appendStrToFile('times.txt', encodeUTF8(var1))
    #str_utf8 =readStrFromFile('report/example.md')
    #print("UTF-8 编码：", str_utf8)
    #print("UTF-8 解码：", str_utf8.decode('UTF-8','strict'))
    return 


###################################################################################################
def main():
    capWebcam = cv2.VideoCapture(1)  # declare a VideoCapture object and associate to webcam, 0 => use 1st webcam
    capWebcam2 = cv2.VideoCapture(2) 
    # show original resolution
    print("default resolution1 = " + str(capWebcam.get(cv2.CAP_PROP_FRAME_WIDTH)) + "x" + str(
        capWebcam.get(cv2.CAP_PROP_FRAME_HEIGHT)))
    print("default resolution1 = " + str(capWebcam.get(cv2.CAP_PROP_FPS)) + "xfps" )

    print("default resolution2 = " + str(capWebcam2.get(cv2.CAP_PROP_FRAME_WIDTH)) + "x" + str(
        capWebcam2.get(cv2.CAP_PROP_FRAME_HEIGHT)))
    print("default resolution2 = " + str(capWebcam2.get(cv2.CAP_PROP_FPS)) + "xfps" )

    capWebcam.set(cv2.CAP_PROP_FRAME_WIDTH, 640.0)  # change resolution to 320x240 for faster processing
    capWebcam.set(cv2.CAP_PROP_FRAME_HEIGHT, 480.0)

    capWebcam2.set(cv2.CAP_PROP_FRAME_WIDTH, 640.0)  # change resolution to 320x240 for faster processing
    capWebcam2.set(cv2.CAP_PROP_FRAME_HEIGHT, 480.0)

    # show updated resolution
    print("updated resolution1 = " + str(capWebcam.get(cv2.CAP_PROP_FRAME_WIDTH)) + "x" + str(
        capWebcam.get(cv2.CAP_PROP_FRAME_HEIGHT)))
    print("updated resolution2 = " + str(capWebcam2.get(cv2.CAP_PROP_FRAME_WIDTH)) + "x" + str(
        capWebcam2.get(cv2.CAP_PROP_FRAME_HEIGHT)))

    if capWebcam.isOpened() == False:  # check if VideoCapture object was associated to webcam successfully
        print("error: capWebcam not accessed successfully\n\n")  # if not, print error message to std out
        os.system("pause")  # pause until user presses a key so user can see error message
        return  # and exit function (which exits program)
    if capWebcam2.isOpened() == False:  # check if VideoCapture object was associated to webcam successfully
        print("error: capWebcam not accessed successfully\n\n")  # if not, print error message to std out
        os.system("pause")  # pause until user presses a key so user can see error message
        return  # and exit function (which exits program)

    # end if
    i=0
    index = 0
    
    start = time.clock()
    while cv2.waitKey(1) != 27 and capWebcam.isOpened():  # until the Esc key is pressed or webcam connection is lost
        blnFrameReadSuccessfully, imgOriginal = capWebcam.read()  # read next frame
        blnFrameReadSuccessfully2, imgOriginal2 = capWebcam2.read()  # read next frame
        if not blnFrameReadSuccessfully or imgOriginal is None:  # if frame was not read successfully
            print("error: frame not read from webcam\n")  # print error message to std out
            os.system("pause")  # pause until user presses a key so user can see error message
            break  # exit while loop (which exits program)
        # end if

        #cv2.namedWindow("imgOriginal", cv2.WINDOW_AUTOSIZE)  # create windows, use WINDOW_AUTOSIZE for a fixed window size
        cv2.imshow("imgOriginal", imgOriginal)  # show windows
        cv2.imshow("imgOriginal2", imgOriginal2)  # show windows
        i=i+1

        if i >30*5:
            cv2.imwrite("./a/%0.6d.jpg"%index,imgOriginal)
            cv2.imwrite("./b/%0.6d.jpg"%index,imgOriginal2)
            index =index+1
            end = time.clock()
            seconds = end-start
            m, s = divmod(seconds, 60)
            h, m = divmod(m, 60)
            print("%d:%02d:%02d" % (h, m, s))
            
            Operations4(str(seconds))
            i=0
    # end while

    cv2.destroyAllWindows()  # remove windows from memory

    return


if __name__ == '__main__':
    main()