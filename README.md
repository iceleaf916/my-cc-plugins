# My Claude Code Plugins

这是一个 Claude Code 插件集合项目,用于扩展 Claude 的功能,提升开发效率。

## 安装

### 从插件市场安装

插件市场地址: [https://gitlabwh.uniontech.com/ut000930/udcp-cc-plugins](https://gitlabwh.uniontech.com/ut000930/udcp-cc-plugins)

在 Claude Code 中执行以下命令安装所有插件:

```bash
/marketplace install https://gitlabwh.uniontech.com/ut000930/udcp-cc-plugins
```

如仅需安装单个插件，可指定插件名称:

```bash
/marketplace install https://gitlabwh.uniontech.com/ut000930/udcp-cc-plugins/fetch-mcp
/marketplace install https://gitlabwh.uniontech.com/ut000930/udcp-cc-plugins/go-formatter
/marketplace install https://gitlabwh.uniontech.com/ut000930/udcp-cc-plugins/udcp-skills
```

### 手动安装

克隆项目到本地:

```bash
git clone https://gitlabwh.uniontech.com/ut000930/udcp-cc-plugins.git
```

将插件目录放置到 Claude Code 的插件目录中。

## 依赖

- `goimports` - Go 代码格式化工具（go-formatter 插件使用）
- `jq` - JSON 处理工具

安装依赖:

```bash
# macOS
brew install goimports jq

# Linux
go install golang.org/x/tools/cmd/goimports@latest
sudo apt-get install jq
```

## 插件列表

### fetch-mcp

MCP API 数据获取插件，提供基于 MCP 协议的 HTTP 请求能力。

- **描述**: A plugin to fetch data from the MCP API
- **版本**: 1.0.0

### go-formatter

Go 代码自动格式化插件,提供以下功能:

- **格式化变更的 Go 文件**: 格式化当前工作区所有变更的 `.go` 文件
- **格式化最近提交**: 格式化最近一次提交修改的 Go 文件及其所在目录下的所有 `.go` 文件
- **自动格式化钩子**: 在写入或编辑 `.go` 文件时自动执行格式化

#### 命令

- `go-formatter:format-change-files` - 格式化所有变更的 Go 文件
- `go-formatter:format-recent-commit` - 格式化最近一次提交修改的 Go 文件

#### 钩子

- `PreToolUse` - 拦截 Write|Edit 操作,对 `.go` 文件自动执行 `goimports -w` 格式化

### udcp-skills

UDCP 开发技能集合插件,包含多个针对 UDCP 开发的专业指南。

- **版本**: 0.1.1
- **作者**: iceleaf

#### 技能列表

1. **go-frame-best-practices** - GoFrame 框架最佳实践
   - 项目结构与分层架构
   - 配置管理与数据校验
   - 数据库操作与事务处理
   - 中间件开发与 API 文档生成

2. **go-test-standards** - Golang 单元测试规范
   - 单元测试编写标准
   - 测试覆盖率要求
   - Mock 与测试辅助函数

3. **remote-troubleshoot** - 远程故障排查
   - 故障排查流程
   - 报告生成模板

## 项目结构

```
udcp-cc-plugins/
├── .claude-plugin/
│   └── marketplace.json          # 插件市场配置
├── fetch-mcp/                    # MCP 数据获取插件
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── .mcp.json
├── go-formatter/                 # Go 格式化插件
│   ├── .claude-plugin/
│   │   └── plugin.json
│   ├── commands/                 # 命令文件
│   ├── hooks/                    # 钩子配置
│   └── scripts/                  # 脚本文件
└── udcp-skills/                  # UDCP 开发技能集合
    ├── .claude-plugin/
    │   └── plugin.json
    └── skills/
        ├── go-frame-best-practices/
        ├── go-test-standards/
        └── remote-troubleshoot/
```
