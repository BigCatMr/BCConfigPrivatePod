#!/bin/bash
#这个是指定运算shell脚本的解释器，liux一般使用bash
#终端的颜色控制命令
#字体青蓝色
Cyan='\033[0;36m'
#终端默认颜色
Default='\033[0;m'
# 字符串里既可以双引号也可以单引号，单引号里不识别变量，单引号里不能出现单独的单引号（使用转义符也不行），但可成对出现，作为字符串拼接使用。
# 双引号里识别变量，双引号里可以出现转义字符
projectName=""
httpsRepo=""
sshRepo=""
homePage=""
confirmed="n"

getProjectName() {
  #read是liux指令。用于从命令行读取内容，-p表示输入的提示，读取内容赋值给projectName变量
  read -p "Enter Project Name: " projectName
  #判断projectName是否为空
  if test -z "$projectName"; then
    getProjectName
  fi
   #${#}用来获取字符串的长度
  projectNameLength=${#projectName}
  #ge为关系运算符，检测左边的数是否大于等于右边，如果是则返回true
  if [ $projectNameLength -ge 31 ]; then
    echo "项目名称的长度不能大于30"
    getProjectName
  fi
}

getHTTPSRepo() {
  read -p "Enter HTTPS Repo URL: " httpsRepo

  if test -z "$httpsRepo"; then
    getHTTPSRepo
  fi
}

getSSHRepo() {
  read -p "Enter SSH Repo URL: " sshRepo

  if test -z "$sshRepo"; then
    getSSHRepo
  fi
}

getHomePage() {
  read -p "Enter Home Page URL: " homePage

  if test -z "$homePage"; then
    getHomePage
  fi
}

getInfomation() {
  getProjectName
  getHTTPSRepo
  getSSHRepo
  getHomePage
#-e 代表开始转义的意思，bash中可以直接创建变量，访问变量名采用${var} 和 $var
  echo -e "\n${Default}================================================"
  echo -e "  Project Name  :  ${Cyan}${projectName}${Default}"
  echo -e "  HTTPS Repo    :  ${Cyan}${httpsRepo}${Default}"
  echo -e "  SSH Repo      :  ${Cyan}${sshRepo}${Default}"
  echo -e "  Home Page URL :  ${Cyan}${homePage}${Default}"
  echo -e "================================================\n"
}

echo -e "\n"
git pull origin master --tags
echo -e "\n"
echo -e "\n"
# -a 为and的意思
while [ "$confirmed" != "y" -a "$confirmed" != "Y" ]
do
  # if 条件为真，则then fi之间的语句会执行
  if [ "$confirmed" == "n" -o "$confirmed" == "N" ]; then
    getInfomation
  fi
  read -p "confirm? (y/n):" confirmed
done

licenseFilePath="../${projectName}/FILE_LICENSE"
gitignoreFilePath="../${projectName}/gitignore"
specFilePath="../${projectName}/${projectName}.podspec"
extensionSpecFilePath="../${projectName}/${projectName}_Extension.podspec"
readmeFilePath="../${projectName}/readme.md"
uploadFilePath="../${projectName}/upload.sh"
uploadExtensionFilePath="../${projectName}/upload_extension.sh"
podfilePath="../${projectName}/Podfile"
demovcPath="../${projectName}/${projectName}/Source/DemoViewController.swift"
targetPath="../${projectName}/${projectName}/Source/Target/Target_${projectName}.swift"
extensionPath="../${projectName}/${projectName}/Extension/${projectName}_Extension.swift"
vcPath="../${projectName}/${projectName}/ViewController.swift"

#递归创建目录
mkdir -p "../${projectName}/${projectName}/Source/Target"
mkdir -p "../${projectName}/${projectName}/Extension"

#-f 强制覆盖拷贝
#拷贝FILE_LICENSE文件
echo "copy to $licenseFilePath"
cp -f ./templates/FILE_LICENSE "$licenseFilePath"

#拷贝gitignore忽略文件
echo "copy to $gitignoreFilePath"
cp -f ./templates/gitignore    "$gitignoreFilePath"

#拷贝模板repo源文件
echo "copy to $specFilePath"
cp -f ./templates/pod.podspec  "$specFilePath"

#拷贝extension格式的模板repo源文件
echo "copy to $extensionSpecFilePath"
cp -f ./templates/pod_extension.podspec  "$extensionSpecFilePath"

#拷贝readme文件
echo "copy to $readmeFilePath"
cp -f ./templates/readme.md    "$readmeFilePath"

#拷贝上传repo源文件至远端仓库的脚本文件
echo "copy to $uploadFilePath"
cp -f ./templates/upload.sh    "$uploadFilePath"

#拷贝上传repo源文件至远端仓库的extension格式的脚本文件
echo "copy to $uploadExtensionFilePath"
cp -f ./templates/upload_extension.sh    "$uploadExtensionFilePath"

#拷贝Podfile文件
echo "copy to $podfilePath"
cp -f ./templates/Podfile      "$podfilePath"

#拷贝几个targer-action相关的文件
echo "copy to $demovcPath"
cp -f ./templates/DemoViewController.swift      "$demovcPath"
echo "copy to $targetPath"
cp -f ./templates/Target.swift      "$targetPath"
echo "copy to $extensionPath"
cp -f ./templates/Extension.swift      "$extensionPath"
echo "copy to $vcPath"
cp -f ./templates/ViewController.swift      "$vcPath"

echo "editing..."

#强制修改
#修改忽略文件
sed -i "" "s%__ProjectName__%${projectName}%g" "$gitignoreFilePath"
#修改readme文件中的内容
sed -i "" "s%__ProjectName__%${projectName}%g" "$readmeFilePath"
#修改Podfile文件
sed -i "" "s%__ProjectName__%${projectName}%g" "$podfilePath"
#修改upload.sh脚本文件
sed -i "" "s%__ProjectName__%${projectName}%g" "$uploadFilePath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$uploadExtensionFilePath"

#修改repo源文件中的相关信息
sed -i "" "s%__ProjectName__%${projectName}%g" "$specFilePath"
sed -i "" "s%__HomePage__%${homePage}%g"      "$specFilePath"
sed -i "" "s%__HTTPSRepo__%${httpsRepo}%g"    "$specFilePath"

sed -i "" "s%__ProjectName__%${projectName}%g" "$extensionSpecFilePath"
sed -i "" "s%__HomePage__%${homePage}%g"      "$extensionSpecFilePath"
sed -i "" "s%__HTTPSRepo__%${httpsRepo}%g"    "$extensionSpecFilePath"


sed -i "" "s%__ProjectName__%${projectName}%g" "$demovcPath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$targetPath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$extensionPath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$vcPath"

# 运行ruby库直接操作xcodeproj文件，需要懂一点ruby的语法，主要就是对工程加入一些引用文件
ruby add_files.rb $projectName swift 1
echo "edit finished"

echo "cleaning..."
cd ../$projectName
git init
# 在我们自己的本地仓库对远程仓库起的别名，这个别名只能在我们自己的本地仓库使用，在真正的远程仓库那边，远程仓库的名字是一个绝对唯一的URL(比如:git@github.com:michaelliao/learngit.git)，而不是origin
# > /dev/null LIUNX指令表示输出到空设备，表示丢掉输出信息
git remote add origin $sshRepo  &> /dev/null
# 删除相关的本地缓存文件
git rm -rf --cached ./Pods/     &> /dev/null
git rm --cached Podfile.lock    &> /dev/null
git rm --cached .DS_Store       &> /dev/null
git rm -rf --cached $projectName.xcworkspace/           &> /dev/null
git rm -rf --cached $projectName.xcodeproj/xcuserdata/`whoami`.xcuserdatad/xcschemes/$projectName.xcscheme &> /dev/null
git rm -rf --cached $projectName.xcodeproj/project.xcworkspace/xcuserdata/ &> /dev/null
# 安装相关库，更新其他库版本
# pod update --verbose --no-repo-update
pod install
echo "clean finished"
echo "finished"
