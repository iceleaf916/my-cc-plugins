#!/bin/bash
set -e

# 找出最近提交修改的 .go 文件
modified_go_files=$(git diff --name-only HEAD~1 HEAD | grep '\.go$')

if [ -z "$modified_go_files" ]; then
    echo "最近一次提交没有修改 .go 文件"
    exit 0
fi

# 收集所有需要格式化的文件（修改的文件所在目录下的所有 .go 文件）
files_to_format=$(echo "$modified_go_files" | xargs -I {} dirname {} | sort -u | xargs -I {} find {} -name '*.go' -type f | sort -u)

# 使用 goimports 格式化
for file in $files_to_format; do
    goimports -w "$file"
done

echo "已完成格式化：共 $(echo "$files_to_format" | wc -l) 个 .go 文件"
