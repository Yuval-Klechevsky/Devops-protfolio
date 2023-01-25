#!/bin/bash

Version=$(git describe --tags | cut -d '-' -f1 | awk -F. -v OFS=. '{$NF += 1 ; print }')

if [ "${Version}" = "" ];then
    Version="1.0.1"
else
    Version=$(git describe --tags | cut -d '-' -f1 | awk -F. -v OFS=. '{$NF += 1 ; print }')
fi
echo $Version

# if [ \$Version ]
# then
    # Version=\$(git describe --tags | cut -d '-' -f1 | awk -F. -v OFS=. '{\$NF += 1 ; print}')
    # echo "\${Version}" > v.txt
# else
    # Version="\$(git branch | grep '*'| cut -d '/' -f2).1"
    # echo "\$(git branch | grep '*'| cut -d '/' -f2).1" > v.txt
# fi
# nextnomatch=\$(echo \$Version | cut -d "." -f1,2)
# if [ \$nextnomatch != "\$(git branch | grep '*'| cut -d '/' -f2)" ]
# then
# Version="\$(git branch | grep '*'| cut -d '/' -f2).1"
# echo "\$(git branch | grep '*'| cut -d '/' -f2).1" > v.txt
# fi
# 
