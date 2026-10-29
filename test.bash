#!/bin/bash

ng () {
	echo ${1}行目のテスト失敗
	res=1
}

res=0
a=坂田
["$a" = 坂田　] || ng "$LINENO"
[ "$a" = 坂田 ] || ng "$LINENO"

exit $res
