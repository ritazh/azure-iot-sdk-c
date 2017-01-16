#!/bin/bash
#set -o pipefail
#

set -e

script_dir=$(cd "$(dirname "$0")" && pwd)
build_root=$(cd "${script_dir}/../.." && pwd)
log_dir=$build_root
run_e2e_tests=OFF
run_longhaul_tests=OFF
build_amqp=ON
build_http=ON
build_mqtt=ON
no_blob=OFF
use_wsio=OFF
skip_unittests=OFF
build_python=OFF
build_javawrapper=OFF
run_valgrind=0
build_folder=$build_root"/cmake/iotsdk_esp8266"
make=true
toolchainfile=" "
cmake_install_prefix=" "
no_logging=OFF
deps="curl git"
repo="https://github.com/espressif/ESP8266_RTOS_SDK.git"
repo_name="ESP8266_RTOS_SDK"
project_folder="examples/project_template/sample_lib"
azure_util="azure-c-shared-utility"
source_folder="${build_root}"
destination_folder="${build_folder}/${repo_name}/examples/project_template/sample_lib/azureiot"

deps_install ()
{
    echo "Install dependencies..."
    sudo apt-get update
    sudo apt-get install -y $deps
}

copy_files ()
{
	echo "Prcessing $1 from $2 to $3 "
    mapfile -t files < $1
    
    declare -i total=0
    for t in "${files[@]}"
	do
		src="${source_folder}/$2/${t}"
		dest="${destination_folder}/$3/${t}"
		dir=$(dirname "$dest")
    	mkdir -p $dir
    	cp "$src" "$dest"
    	total=total+1
	done
    echo "Copied ${total} files into $dir."
}

echo "Starting build script for Azure IoT ESP8266..."
#deps_install
#rm -r -f $build_folder
#mkdir -p $build_folder
pushd $build_folder
echo "Clone ESP8266 SDK..."
#git clone $repo
cd $repo_name
cd $project_folder
# temp
rm -r -f azureiot # remove this later, this is just a test
mkdir -p azureiot
cd azureiot
echo "Copying Azure IoT files ..."

filelist=$script_dir"/shared-util_filelist.txt"
copy_files $filelist "azure-c-shared-utility/adapters" "azure-c-shared-utility/src"

filelist=$script_dir"/shared-util-inc_filelist.txt"
copy_files $filelist "azure-c-shared-utility/inc/azure_c_shared_utility" "azure-c-shared-utility/inc/azure_c_shared_utility"

filelist=$script_dir"/shared-util-src_filelist.txt"
copy_files $filelist "azure-c-shared-utility/src" "azure-c-shared-utility/src"

filelist=$script_dir"/umqtt-inc_filelist.txt"
copy_files $filelist "azure-umqtt-c/inc/azure_umqtt_c" "azure-umqtt-c/inc/azure_umqtt_c"

filelist=$script_dir"/umqtt-src_filelist.txt"
copy_files $filelist "azure-umqtt-c/src" "azure-umqtt-c/src"

filelist=$script_dir"/iothub-client-inc_filelist.txt"
copy_files $filelist "iothub_client/inc" "iothub_client/inc"

filelist=$script_dir"/iothub-client-src_filelist.txt"
copy_files $filelist "iothub_client/src" "iothub_client/src"

echo "Copying Make files ..."
cp "${source_folder}/build_all/esp8266/Makefile_sample_lib" "${build_folder}/${repo_name}/examples/project_template/sample_lib/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_project" "${build_folder}/${repo_name}/examples/project_template/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_azureiot" "${destination_folder}/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_shared_utility" "${destination_folder}/azure-c-shared-utility/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_shared_utility_src" "${destination_folder}/azure-c-shared-utility/src/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_umqtt_c" "${destination_folder}/azure-umqtt-c/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_umqtt_c_src" "${destination_folder}/azure-umqtt-c/src/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_iothub_client" "${destination_folder}/iothub_client/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_iothub_client_src" "${destination_folder}/iothub_client/src/Makefile"
cp "${source_folder}/build_all/esp8266/Makefile_parson" "${destination_folder}/parson/Makefile"
# what aobut certs folder?

echo "Copying user files ..."
cp ${source_folder}/build_all/esp8266/user/* "${build_folder}/${repo_name}/examples/project_template/user/"

echo "Copying gen_misc files ..."
cp ${source_folder}/build_all/esp8266/gen_misc.sh "${build_folder}/${repo_name}/examples/project_template/"

echo "Set ENV"
export SDK_PATH="${build_folder}/${repo_name}"
export BIN_PATH="${build_folder}/${repo_name}/bin"
echo $SDK_PATH
echo "done"

popd
