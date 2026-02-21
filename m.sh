#!/bin/bash
set -e

FILE_NAME="fdsv3"

# 各種フラグ
ASM_FLG="--debug-info"
#LD_FLG="--dbgfile $FILE_NAME.dbg -Ln $FILE_NAME.lbl"
LD_FLG="--dbgfile $FILE_NAME.dbg"

pack()
{
	echo "Packing..."
	fdspacker pack $FILE_NAME.json $FILE_NAME.fds > /dev/null
	if [ "$?" -ne 0 ]; then
		echo	"Pakking Error"
	fi
}

case "$1" in
	"clean")
		rm	*.o *.fds *.lbl *.dbg
		;;
	"pack")
		pack
		;;
	"unpack")
		echo "UnPacking..."
		fdspacker unpack $FILE_NAME.fds unpack
		;;
	*)
		# ビルド日時タイトル表示用
		#date +"%y%m%d%H%M" > datetime.s

		echo "Assembling..."
		ca65 $FILE_NAME.s -g $ASM_FLG
		if [ "$?" -eq 0 ]; then
			echo "Linking..."
			ld65 -o $FILE_NAME.bin -C $FILE_NAME.cfg $FILE_NAME.o $LD_FLG
			if [ "$?" -eq 0 ]; then
				pack
			fi
		fi
		;;
esac
