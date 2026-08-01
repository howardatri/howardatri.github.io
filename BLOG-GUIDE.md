# Hugo 博客操作手册

## 快速开始

### 本地预览

```bash
hugo server -D
```

访问 http://localhost:1313

---

## 写新文章

### 1. 创建文章

```bash
hugo new content posts/文章标题.md
```

### 2. 编辑文章

打开 `content/posts/文章标题.md`，修改 Front Matter 和内容：

```markdown
+++
title = '文章标题'
date = '2026-07-26T10:00:00+08:00'
draft = false  # 改为 false 才会发布
tags = ['标签1', '标签2']
categories = ['分类']
description = '文章描述'
+++

这里是文章内容...

## 二级标题

正文内容...
```

### 3. Front Matter 说明

| 字段 | 说明 | 示例 |
|------|------|------|
| `title` | 文章标题 | `'我的文章'` |
| `date` | 发布时间 | `'2026-07-26T10:00:00+08:00'` |
| `draft` | 草稿状态 | `true`/`false` |
| `tags` | 标签 | `['技术', 'Hugo']` |
| `categories` | 分类 | `'技术'` |
| `description` | 描述 | `'这篇文章介绍了...'` |
| `cover` | 封面图 | 见下方说明 |
| `ShowToc` | 显示目录 | `true`/`false` |

### 4. 添加封面图

```markdown
+++
title = '文章标题'
date = '2026-07-26T10:00:00+08:00'
draft = false

cover:
  image: '/images/cover.jpg'
  alt: '封面描述'
  caption: '图片来源：xxx'
+++
```

封面图放在 `static/images/` 目录下。

### 5. 发布文章

```bash
# 1. 确保 draft = false
# 2. 提交并推送
git add -A
git commit -m "post: 文章标题"
git push origin main
```

GitHub Actions 会自动部署，1-2 分钟后上线。

---

## 常用操作

### 添加页面

```bash
# 关于页（已有）
hugo new content about.md

# 友链页（已有）
hugo new content friends.md

# 自定义页面
hugo new content custom-page.md
```

### 图片使用

1. 将图片放入 `static/images/` 目录
2. 在文章中引用：

```markdown
![图片描述](/images/图片名.png)
```

### 代码块

````markdown
```python
print("Hello, World!")
```
````

### 数学公式

```markdown
行内公式：$E = mc^2$

块级公式：
$$
\sum_{i=1}^{n} x_i = x_1 + x_2 + ... + x_n
$$
```

### 引用

```markdown
> 这是一段引用文字
```

### 提示框

```markdown
{{</* hint info */>}}
这是一条提示信息
{{</* /hint */>}}
```

---

## 文件结构

```
howardatri.github.io/
├── content/              # 文章和页面
│   ├── posts/           # 博客文章
│   ├── about.md         # 关于页
│   ├── archives.md      # 归档页
│   ├── search.md        # 搜索页
│   └── friends.md       # 友链页
├── static/              # 静态文件
│   ├── images/          # 图片
│   └── tools/           # 工具页面
├── layouts/             # 自定义布局
├── themes/PaperMod/     # 主题
└── hugo.toml            # 配置文件
```

---

## 部署流程

```bash
# 1. 本地预览
hugo server -D

# 2. 确认无误后，提交
git add -A
git commit -m "描述你的修改"

# 3. 推送
git push origin main

# 4. 等待 GitHub Actions 部署（1-2分钟）
# 访问 https://howardatri.github.io
```

---

## 常见问题

### Q: 文章不显示？

检查 `draft` 是否为 `false`

### Q: 图片不显示？

确认图片放在 `static/images/` 目录，路径以 `/images/` 开头

### Q: 本地预览正常，线上不正常？

GitHub Actions 构建可能有缓存，等待几分钟或手动触发 Actions

### Q: 如何修改网站标题？

编辑 `hugo.toml` 中的 `title` 字段

### Q: 如何添加新的导航菜单？

编辑 `hugo.toml` 中的 `[menu]` 部分

---

## 快捷键（PaperMod）

| 快捷键 | 功能 |
|--------|------|
| `c` | 切换目录显示 |
| `g` | 回到顶部 |
| `h` | 回到首页 |
| `t` | 切换主题 |
| `/` | 跳转搜索页 |
