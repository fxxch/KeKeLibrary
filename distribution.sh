echo ""
echo "=================================================="
echo "==  准备发布前的版本号自增处理  "
echo "=================================================="
# 获取文件KeKeLibrary.podspec第23行的内容赋值给变量ver_old
versionString_old=$(sed -n 23p KeKeLibrary.podspec)
echo "version_old:"${versionString_old}

#开始拼接新版本号完整字符串
head="    s.version      = \""
#从文件version1.txt里面获取【大版本号】(1p就是第1行，np就是第n行)
version1=$(sed -n 1p version1.txt)
#从文件version2.txt里面获取【中版本号】(1p就是第1行，np就是第n行)
version2=$(sed -n 1p version2.txt)
#===== 小版本号自增 =====
#从文件version3.txt里面获取【小版本号】(1p就是第1行，np就是第n行)
version3Old=$(sed -n 1p version3.txt)
#小版本号+1
version3=$(($version3Old+1))
#将新的小版本号保存到文件version3.txt里面(1s就是第1行，ns就是第n行)
sed -i '' "1s/${version3Old}/${version3}/" version3.txt

versionFull=${version1}.${version2}.${version3}
versionString_new=${head}${versionFull}\"

#将新的完整版本号保存到文件KeKeLibrary.podspec里面(20s就是第20行，ns就是第n行)
sed -i '' "23s/${versionString_old}/${versionString_new}/" KeKeLibrary.podspec
echo "version_new:"${versionString_new}

echo ""
echo "=================================================="
echo "==  开始发布到cocoapods  "
echo "=================================================="
git add .
git commit  -a -m "update"
git push -u origin master

#添加tag
git tag ${versionFull}
#上传tag
git push --tags
git push origin master
#验证
#pod lib  lint --verbose --use-libraries --allow-warnings
#pod spec lint  KeKeLibrary.podspec --verbose --use-libraries --allow-warnings
#上传
pod trunk push KeKeLibrary.podspec --verbose --use-libraries --allow-warnings
pod setup
pod repo update
pod search KeKeLibrary

#上传成功后查找
#pod search WMCloverSdk

#错误： 如果trunk 报错：[!] Authentication token is invalid or unverified. Either verify it with the email that was sent or register a new session.
#解决办法：pod trunk register 349230334@qq.com 'KeKeLibrary' --description='KeKeLibrary'

