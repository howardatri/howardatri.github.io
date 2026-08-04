# Hugo 博客操作手册

## 快速开始

### 本地预览

```bash
hugo server -D
```

访问 http://localhost:1313

---

## 写新文章

### 0. 批量创建文章（推荐）

项目根目录提供了 `new-posts.ps1` 脚本，可一次创建多篇：

```powershell
# 批量创建多篇（英文标题）
.\new-posts.ps1 -Titles "Post-One","Post-Two","Post-Three" -Tags "tech,hugo" -Category "tech"

# 创建草稿（draft=true，编辑完再发布）
.\new-posts.ps1 -Titles "Draft-Post" -Draft

# 从文本文件读取标题（每行一个）
.\new-posts.ps1 -List .\titles.txt
```

创建后编辑 `content/posts/` 下对应的 `.md` 文件，填入内容即可。

> **注意**：PowerShell 中变量名不区分大小写，脚本内 `$draft` 类变量与 `$Draft` 参数会冲突，已用 `$draftState` 规避。自定义脚本时避开同名变量。

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

> **⚠️ 两个最容易踩的坑**（图片不显示的 90% 原因，务必遵守）：
>
> 1. **文件名不能有空格**：从微信/截图工具粘贴下来的图片名常带空格（如 `Pasted image xxx.png`），浏览器会自动转义导致 404。**务必改名为下划线**（如 `Pasted_image_xxx.png`）。
> 2. **必须用绝对路径 `/images/` 开头**：写成 `![图](/images/xxx.png)`。不要写相对路径（如 `![图](xxx.png)`），否则 Hugo 会把它拼到文章 URL 下而找不到。

操作步骤：

1. 将图片放入 `static/images/` 目录，**重命名为无空格的下划线格式**（如 `Pasted_image_20251114192225.png`）
2. 在文章中引用，**路径必须以 `/images/` 开头**：

```markdown
![图片描述](/images/Pasted_image_20251114192225.png)
```

> **注意**：引用里的文件名要和 `static/images/` 里的**实际文件名完全一致**（含大小写、下划线）。改 md 里的引用而不改实际文件名，照样会加载失败。

**快速自查**：

```powershell
# 检查 static/images 下是否有带空格的文件名（应无输出）
Get-ChildItem static/images | Where-Object { $_.Name -match ' ' }
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

按顺序排查：

1. **文件名是否含空格**：图片放 `static/images/` 后，改名去掉空格（用下划线）
2. **引用是否用绝对路径**：必须写 `/images/文件名.png`，不能只写 `文件名.png`
3. **文件名是否完全一致**：md 里的引用和实际文件必须完全匹配（含大小写、下划线）
4. 用 `hugo server -D` 本地预览验证，F12 查看 Network 里图片请求是否 404

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
