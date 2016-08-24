#!/bin/bash

#计时
SECONDS=0

#假设脚本放置在与项目相同的路径下
project_path=$(pwd)
#取当前时间字符串添加到文件结尾
now=$(date +"%Y_%m_%d_%H_%M_%S")

#指定项目的scheme名称
scheme="wowapp"
#指定要打包的配置名
configuration="Debug"
#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
export_method='ad-hoc'

#指定项目地址
workspace_path="$project_path/WowApp.xcworkspace"
#指定输出路径
output_path="~/Documents/"
#指定输出归档文件地址
archive_path="$output_path/wow_${now}.xcarchive"
#指定输出ipa地址
ipa_path="$output_path/wow_${now}.ipa"
#指定输出ipa名称
ipa_name="wow_${now}.ipa"
#获取执行命令时的commit message
commit_msg="$1"

#输出设定的变量值
echo "===workspace path: ${workspace_path}==="
echo "===archive path: ${archive_path}==="
echo "===ipa path: ${ipa_path}==="
echo "===export method: ${export_method}==="
echo "===commit msg: $1==="

#先清空前一次build
gym --workspace ${workspace_path} --scheme ${scheme} --clean --configuration ${configuration} --archive_path ${archive_path} --export_method ${export_method} --output_directory ${output_path} --output_name ${ipa_name} --include_bitcode --verbose

#上传到fir
fir publish ${ipa_path} -T eacafe6a24e4e7fa098aedb6d9ef636d -c "${commit_msg}"

#输出总用时
echo "===Finished. Total time: ${SECONDS}s==="
