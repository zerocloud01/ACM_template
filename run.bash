#!/bin/bash
# 用法: ./run.sh name

# 编译
g++ $1 -o tmp

"./tmp" < in.txt > out.txt

cat out.txt
