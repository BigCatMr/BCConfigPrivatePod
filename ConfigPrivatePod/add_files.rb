#Xcodeproj, 一个 CocoaPods 官方提供的用于修改 xcode 工程文件的 ruby 类库
require 'xcodeproj'
#工程名字
projectName = ARGV[0]
#语言
lan = ARGV[1]
#是否为extension
extension = ARGV[2]
#项目路径 ruby脚本上一级目录下、的名字为项目名字的文件夹
project_path = "../#{projectName}"
#工程启动文件
project_file_path = "../#{projectName}/#{projectName}.xcodeproj"
#source文件夹
main_file_path = "../#{projectName}/#{projectName}/Source" 

extension_suffix = lan == "oc" ? "Category" : "Extension"

extension_file_path = "../#{projectName}/#{projectName}/#{extension_suffix}" 

#查找.xcodeproj并打开
project = Xcodeproj::Project.open(project_file_path)

def add_group(relative_path, project, group)
    # 特定目录的父路径
    path = File.expand_path(relative_path)
    # 引入source文件夹到工程中
    # 返回filename中的最后一条斜线后面的部分。若给出了参数suffix且它和filename的尾部一致时，该方法会将其删除并返回结果
    parent_group_reference = project.main_group[group].new_group(File.basename(path))
#    puts group + " 文件夹 " + path
    
    # 返回一个数组包含于指定通配符匹配的文件名
    Dir.glob(path + "/*") do |item|

        if File.directory?(item)
            parent = File.basename(File.dirname(item))
            add_group(item, project, group + "/" + parent)
        else
            parent = File.basename(File.dirname(item))
#            puts group + "/" + parent + " 文件 " + item
            file = project.main_group[group + "/" + parent].new_reference(item)
             # 添加引用
            project.targets.first.add_file_references([file])
        end
    end
end

def add_specs(project_relative_path, project, group)
    project_path = File.expand_path(project_relative_path)
    Dir.glob(project_path + "/*.podspec") do |item|
        file = project.main_group[group].new_reference(item)
        file.set_explicit_file_type('text.script.ruby')
        file.set_last_known_file_type('text.script.ruby')
    end
end

if extension == "1"
    # 添加source文件夹到工程
    add_group(main_file_path, project, projectName)
     # 添加extension文件夹到工程
    add_group(extension_file_path, project, projectName)
end
add_specs(project_path, project, projectName)

# 保存工程
project.save
