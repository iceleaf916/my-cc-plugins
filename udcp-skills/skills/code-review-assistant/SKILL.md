---
name: code-review-assistant
description: Gerrit Code Review 辅助工具，支持 Golang、Qt/C++、Ansible 等多语言的代码审核。提供"必须修复/建议修复/可选改进"三级分级审核，生成 Markdown 报告和 Gerrit 评论格式（自动设置 Code-Review 评分）。检测到用户明确要求时可直接发布评论到 Gerrit。
category: review
tags:
  - code-review
  - gerrit
  - golang
  - cpp
  - qt
  - ansible
---

# Code Review Assistant

## Overview

提供结构化的 Gerrit Code Review 工作流程，支持多语言审核：
- Golang（初始完整支持）
- Qt/C++（预留框架）
- Ansible（预留框架）

## Gerrit Review 评分规则

| 问题类型 | Code Review Score | 说明 |
|---------|------------------|------|
| 无问题 | **+1** | 代码质量优秀，可直接合并 |
| 仅有 Nice to Have | **-1** | 有改进空间但不影响功能 |
| 有 Should Fix | **-2** | 应该修复的问题 |
| 有 Must Fix | **-2** | 必须修复的严重问题 |

## 使用方式

### 基本用法

```
/code-review-assistant <change_id>
```

### 自动发布评论

如果用户提示词中包含明确的发布请求（如"发布评论"、"提交评审"、"post review"、"发布到 Gerrit"等关键词），skill 会自动使用 Gerrit MCP 工具发布带评分的评论。

## 完整工作流程

### 阶段 1: 准备工作流

1. 确认 Gerrit Change ID
2. 使用 Gerrit MCP 工具获取变更基本信息：
   - `get_change_details` - 获取变更详情
   - `list_change_files` - 获取修改的文件列表
   - `get_commit_message` - 获取提交信息

### 阶段 2: 代码获取与解析

对每个修改的文件：
1. 使用 `get_file_diff` 获取差异内容
2. 识别文件类型（.go、.cpp、.hpp、.yml、.yaml 等）
3. 将文件分发给对应语言的分析器

### 阶段 3: 语言专项检查

#### Golang 分析器

检查规则详见 [references/golang-checks.md](references/golang-checks.md)。

**排除规则**:
- `vendor/` 目录及其所有文件不进行审核
- 不提示关于 vendor 目录存储方式的改进建议（如是否使用 go modules）

**按严重程度分类**:
- 🔴 **Must Fix** (-2): 错误处理缺失、SQL 注入、竞态条件、资源泄漏、空指针解引用
- 🟡 **Should Fix** (-2): 命名规范、函数过长、魔法数字、缺少注释、过度嵌套
- 🔵 **Nice to Have** (-1): 可用 stdlib、未使用变量/导入、可简化拼接

#### Qt/C++ 分析器（预留框架）

检查规则详见 [references/cpp-checks.md](references/cpp-checks.md)

#### Ansible 分析器（预留框架）

检查规则详见 [references/ansible-checks.md](references/ansible-checks.md)

### 阶段 4: 问题聚合与分级

1. 将各语言检查结果汇总
2. 按严重程度分类（Must Fix / Should Fix / Nice to Have）
3. 去重和优先级排序
4. 计算 Code-Review 评分：
   - 有 Must Fix 或 Should Fix → `-2`
   - 仅有 Nice to Have → `-1`
   - 无问题 → `+1`

### 阶段 5: 生成输出

使用模板生成两种输出：
- Markdown 审核报告（参考 [assets/review-summary-template.md](assets/review-summary-template.md)）
- Gerrit Review 评论格式（参考 [assets/gerrit-comment-template.md](assets/gerrit-comment-template.md)）

### 阶段 6: 条件性发布评审（仅在用户明确要求时）

**检测用户意图**：检查用户提示词是否包含以下关键词之一：
- "发布评论"
- "提交评审"
- "post review"
- "发布到 Gerrit"
- "submit review"

**如明确要求，使用 Gerrit MCP 工具发布**：

1. 使用 `post_review_comment` 工具发布行级评论
2. **必须**在 `labels` 参数中设置 `Code-Review` 分数：
   ```javascript
   {
     "change_id": "...",
     "file_path": "...",
     "line_number": ...,
     "message": "...",
     "labels": {
       "Code-Review": -2  // 或 -1 或 +1
     }
   }
   ```

**重要提醒**：
- 每次调用 `post_review_comment` 时，**必须**设置 `labels.Code-Review`
- 分数根据汇总 Summary 计算
- Verified 字段不设置，由 Gerrit 默认处理

## 输出格式

### Markdown 审核报告

```markdown
# Code Review Report

## Metadata
- **Change ID**: xxx
- **Author**: xxx
- **Subject**: xxx
- **Files Changed**: xx (xx insertions, xx deletions)

## Summary
- 🔴 Must Fix: X items → 建议 Score: -2
- 🟡 Should Fix: X items → 建议 Score: -2
- 🔵 Nice to Have: X items → 建议 Score: -1
- ✅ 无问题 → 建议 Score: +1

---

## 📌 Must Fix (-2)
...

## 📌 Should Fix (-2)
...

## 📌 Nice to Have (-1)
...

## ✅ Positive Points
...
```

### Gerrit Review 评论格式

```
Code Review Summary:
- Must Fix: 2
- Should Fix: 3
- Nice to Have: 1
- 建议 Score: -2

---

Must Fix:
1. [pkg/service/user.go:123] 错误处理缺失
   Suggestion: 添加错误检查处理

...

Overall: -2 (需修复严重问题后合并)
```

## 检查规则参考

- [references/golang-checks.md](references/golang-checks.md) - Golang 检查规则
- [references/cpp-checks.md](references/cpp-checks.md) - Qt/C++ 检查规则（预留）
- [references/ansible-checks.md](references/ansible-checks.md) - Ansible 检查规则（预留）

### Golang 检查项索引

#### 🔴 Must Fix (-2)

| ID | 问题描述 | 检测方式 |
|----|---------|---------|
| GO-MF001 | 错误处理缺失 | 检测未处理的返回值 `err` |
| GO-MF002 | SQL 注入风险 | 检测字符串拼接构建 SQL |
| GO-MF003 | 竞态条件 | 检测未保护的共享变量访问 |
| GO-MF004 | 资源泄漏 | 检测未关闭的 `defer` 缺失 |
| GO-MF005 | 空指针解引用 | 检测未检查 nil 的指针操作 |

#### 🟡 Should Fix (-2)

| ID | 问题描述 | 检测方式 |
|----|---------|---------|
| GO-SF001 | 命名不符合规范 | 检测非规范命名（包/变量/函数） |
| GO-SF002 | 函数过长 | 统计函数行数 > 100 |
| GO-SF003 | 魔法数字 | 检测数字字面量（非 0/1） |
| GO-SF004 | 缺少注释的复杂逻辑 | 检测复杂判断/循环无注释 |
| GO-SF005 | 过度嵌套 | 检测嵌套层级 > 3 |

#### 🔵 Nice to Have (-1)

| ID | 问题描述 | 检测方式 |
|----|---------|---------|
| GO-NH001 | 可使用 stdlib | 检测自实现有 stdlib 等效功能的函数 |
| GO-NH002 | 变量未使用 | 检测声明但未使用的变量 |
| GO-NH003 | 导入未使用 | 检测未使用的 import |
| GO-NH004 | 可简化的字符串拼接 | 检测可用 `+` 简化的 `fmt.Sprintf` |

## 扩展指南

### 添加新的检查规则

在对应语言的 `references` 文件中添加检查项，格式：
```markdown
### [检查ID] 检查名称

- **描述**: 检查项的详细描述
- **严重程度**: Must Fix / Should Fix / Nice to Have
- **检测方式**: 如何通过代码分析发现此问题
- **示例**:
  ```go
  // Bad
  // ...
  // Good
  // ...
  ```
- **建议修改**: 具体的修改建议
```

### 添加新语言支持

1. 创建 `references/<lang>-checks.md` 文件
2. 按三级分类组织检查项
3. 更新本文挡"阶段 3: 语言专项检查"部分
