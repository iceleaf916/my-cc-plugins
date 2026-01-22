---
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(goimports *)
description: 使用goimports -w xxx.go命令格式化所有变更的golang文件
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`

# 你的任务

利用 git 命令找出所有的已修改的.go 源码文件，然后使用 goimports -w xxx.go 来全部格式化一下
