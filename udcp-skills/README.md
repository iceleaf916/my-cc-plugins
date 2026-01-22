# GoFrame Best Practices Plugin

GoFrame 框架开发最佳实践指南插件，提供项目结构、分层架构、配置管理、数据库操作、中间件开发等开发规范。

## 简介

此插件汇总了 GoFrame 框架的官方最佳实践，帮助开发者在使用 GoFrame 框架进行业务开发时遵循统一的规范和标准。

## 触发方式

当你在对话中提到以下关键词时，此 Skill 会被自动触发：
- "go-frame 最佳实践"
- "go-frame 开发规范"
- "go-frame 项目结构"
- "go-frame 分层架构"
- "go-frame 路由注册"
- "go-frame 数据库操作"
- "go-frame 事务处理"
- "go-frame 配置管理"
- "go-frame 中间件"
- "go-frame API 文档"
- "go-frame 校验参数"

## 内容概览

### 项目目录结构
- 标准 GoFrame 项目布局
- internal、api、cmd、manifest 等目录的作用

### 分层架构设计
- Controller 层（请求接收）
- Logic 层（业务逻辑）
- Model 层（数据模型）

### 配置管理
- YAML 配置文件示例
- 使用 `g.Cfg()` 单例读取配置

### 数据校验
- Struct 标签校验
- Map 数据校验

### 数据库操作
- 基础 CRUD 操作
- 事务处理

### 中间件开发
- 统一响应格式中间件
- 错误处理中间件

### API 文档生成
- 启用 Swagger UI
- 丰富 API 文档的技巧

## 安装

此插件已集成到 `my-cc-plugins` 项目中，无需额外安装。

## 参考资源

- [GoFrame 官方文档](https://goframe.org/)
- [GoFrame GitHub](https://github.com/gogf/gf)
- [GoFrame 示例项目](https://github.com/gogf/gf-demo-user)

## 许可证

MIT
