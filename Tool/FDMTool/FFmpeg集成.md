
1.在Link Binary With Libraries 里添加

libz.tbd
libbz2.tbd
libiconv.tbd
CoreMedia.framework
VideoToolbox.framework
AVFoundation.framework

2.将 【FFmpeg-iOS】 文件夹导入到项目中
3.设置 Header Search Paths 路径，为项目【FFmpeg-iOS】 文件夹中的 【include】文件夹
