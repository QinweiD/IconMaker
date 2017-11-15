#!/bin/sh
#0505自动裁剪导入logo
#for_Qway（Q_2929966129）


#裁剪logo文件路径
IMAGE_PATH="/Users/mac/Desktop/AutoIcon/桌面图标.png"
ASSET_PATH="/Users/mac/Desktop/Auto_iconTest/Auto_iconTest/Assets.xcassets/AppIcon.appiconset/"
JSON_PATH="/Users/mac/Desktop/AutoIcon/Contents.json"


##############此处为logo大小配置，目前已设置满足xcode打包需求，如无其他需要请勿修改##############
 name_array=("Icon-20x20@2x.png" "Icon-20x20@3x.png" "Icon-29x29@2x.png" "Icon-29x29@3x.png" "Icon-40x40@2x.png" "Icon-40x40@3x.png" "Icon-60x60@2x.png" "Icon-60x60@3x.png" "Icon-20x20@1x.png" "Icon-20x20@2x-1.png" "Icon-29x29@1x.png" "Icon-29x29@2x-1.png" "Icon-40x40@1x.png" "Icon-40x40@2x-1.png" "Icon-76x76@1x.png" "Icon-76x76@2x.png" "Icon-83.5x83.5@2x.png" "Icon-1024x1024@1x.png")
 size_array=("40" "60" "58" "87" "80" "120" "120" "180" "20" "40" "29" "58" "40" "80" "76" "152" "167" "1024")
mkdir $ASSET_PATH
for ((i=0;i<${#name_array[@]};++i)); do
    m_dir=$ASSET_PATH/${name_array[i]}
    cp $IMAGE_PATH $m_dir
    sips -Z ${size_array[i]} $m_dir
done
##############此处为logo大小配置，目前已设置满足xcode打包需求，如无其他需要请勿修改##############


#添加logo自动排序，此处请修改好Contents.json文件路径
cp ${JSON_PATH} ${ASSET_PATH}
