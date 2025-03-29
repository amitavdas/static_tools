v_Sysroot             :=  /home/bari/HWD/mounts/temp/experiment/git/armv6-linux-musleabihf-cross 
v_Sysroot_Bin         :=  $(v_Sysroot)/bin 

v_Build_Dir           :=  $(PWD)/build 
v_Prefix_Dir          :=  $(v_Build_Dir)/pseudo_usr 
v_Release_Dir         :=  $(PWD)/releases 

v_Host_Platform       :=  armv6-linux-musleabihf 
v_Build_Platform      :=  x86_64-pc-linux-gnu 
v_Temporary_Platform  :=  gcc 
v_Strip_Program       :=  $(v_Host_Platform)-strip 

PATH                  :=  $(v_Sysroot_Bin):${PATH} 

define f_download
    v_Package_archive=$(shell PWD)/$(v_Package_name)-$(v_Package_version).tar.gz
    [ -f ${v_Package_archive} ] || wget --continue --output-document="$(v_Package_archive)" "https://github.com/libexpat/libexpat/releases/download/R_2_7_1/expat-$(v_Package_archive).tar.gz"

endef

default:
   @mkdir -p  $(v_Prefix_Dir) 


expact:
    v_
    $(call f_download, $(v_Package_name), $(v_Package_version))

#!/bin/bash

source ./00_preprocessing

v_Package_archive="${PWD}/${v_Package_name}-${v_Package_version}.tar.gz"


cd "${v_Build_Dir}" || exit 1

v_Package_dir="${v_Package_name}-${v_Package_version}"

[ -d "${v_Package_dir}" ] && rm -rf "${v_Package_dir}"

tar -xf "${v_Package_archive}"

cd "${v_Package_dir}"

export CFLAGS="-static -Os"
export CFLAGS="${CFLAGS} -I${v_Prefix_Dir}/include"
export LDFLAGS="-L${v_Prefix_Dir}/lib -static"

./configure --prefix="${v_Prefix_Dir}" \
	    --host="${v_Host_Platform}" \
	    --build="${v_Build_Platform}" \

make -j2
make install
# mkdir -p "${v_Release_Dir}"
#cp --no-dereference "${v_Package_Prefix}/bin/"* "${v_Release_Dir}"
