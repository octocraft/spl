#!/bin/bash
set -eu

if [ -z ${TEST_PKG_BIN_DIR+x} ]; then
    TEST_PKG_BIN_DIR="./"
fi

opts1=$1
src=$2
filename=${src##*/}
name=${filename%%-*}
binpath=${TEST_PKG_BIN_DIR}$name

if [ "$opts1" = "xvf" ]; then

    opts2=$3
    dst=$4
    target=$dst/$binpath        

    mkdir -p $dst/$TEST_PKG_BIN_DIR

    printf "#!/bin/bash\necho test\n" > "$target"
    chmod u+x "$target"

    printf "x " 
fi

printf "$binpath\n"
exit 0

