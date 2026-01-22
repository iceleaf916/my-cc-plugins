# My Claude Code Plugins

这是一个 Claude Code 插件集合项目，用于扩展 Claude 的功能，提升开发效率。

## 插件列表

### go-formatter

Go 代码自动格式化插件，提供以下功能：

- **格式化变更的 Go 文件**：格式化当前工作区所有变更的 `.go` 文件
- **格式化最近提交**：格式化最近一次提交修改的 Go 文件及其所在目录下的所有 `.go` 文件
- **自动格式化钩子**：在写入或编辑 `.go` 文件时自动执行格式化

#### 命令

- `go-formatter:format-change-files` - 格式化所有变更的 Go 文件
- `go-formatter:format-recent-commit` - 格式化最近一次提交修改的 Go 文件

#### 钩子

- `PreToolUse` - 拦截 Write|Edit 操作，对 `.go` 文件自动执行 `goimports -w` 格式化

## 依赖

- `goimports` - Go 代码格式化工具
- `jq` - JSON 处理工具

## 项目结构

```
my-cc-plugins/
├── .claude-plugin/
│   └── marketplace.json          # 插件市场配置
├── go-formatter/                 # Go 格式化插件
│   ├── .claude-plugin/
│   │   └── plugin.json           # 插件元数据
│   ├── commands/                 # 命令文件
│   ├── hooks/                    # 钩子配置
│   └── scripts/                  # 脚本文件
```
