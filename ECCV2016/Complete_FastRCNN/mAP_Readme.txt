Annotation_Complete1.zip中存放的是annotation，文件名就是image的名字
第一行是image的名字，后面每一行分别是一个ground truth。第一维是GT label，后面四维分别是这个object的bounding box的x1,y1,x2,y2 （左上，右下）

det_train_traintest_bed中存放的是fast rcnn对bed这一类检测的result，第一维是所在的图片，第二维是fastrcnn检测的分数，后面四维是这个object的bounding box的x1,y1,x2,y2 （左上，右下）
