# 🔑 验证 Supabase Key 步骤

## 问题分析

虽然 RLS 策略已经正确配置，但前端仍然报 **401 错误**和 **RLS 策略违规**。

可能原因：
1. ❌ Supabase anon key 不正确或已过期
2. ❌ 浏览器或 Vercel 缓存了旧配置
3. ❌ Supabase 项目配置问题

---

## 🔍 步骤 1：验证 Supabase Anon Key

### 在 Supabase Dashboard 中：

1. 登录 **Supabase Dashboard**
2. 选择项目：**zoxjvuafzkymgxmsluif**
3. 点击左侧菜单 **⚙️ Settings** → **API**
4. 找到 **Project API keys** 部分
5. 复制 **anon** **public** key

### 对比 Key：

**项目中的 Key**（在 `config.js` 中）：
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpveGp2dWFmemt5bWd4bXNsdWlmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5NzY5NDMsImV4cCI6MjA3NTU1Mjk0M30.csyxXbV6IxuP8v4I-zi7TeTw1qTI2HDJU52U84K7Tas
```

**Dashboard 中的 Key**：
```
[你从 Dashboard 复制的 key]
```

### ❓ 是否匹配？
- ✅ **匹配** → Key 正确，跳到步骤 2
- ❌ **不匹配** → 需要更新 config.js

---

## 🔍 步骤 2：验证 Project URL

### 在 Supabase Dashboard 中：

1. 同样在 **Settings** → **API** 页面
2. 找到 **Project URL**

### 对比 URL：

**项目中的 URL**（在 `config.js` 中）：
```
https://zoxjvuafzkymgxmsluif.supabase.co
```

**Dashboard 中的 URL**：
```
[你从 Dashboard 看到的 URL]
```

### ❓ 是否匹配？
- ✅ **匹配** → URL 正确，跳到步骤 3
- ❌ **不匹配** → 需要更新 config.js

---

## 🔍 步骤 3：查看控制台详细错误

### 在浏览器中：

1. 按 **F12** 打开开发者工具
2. 切换到 **Console** 标签
3. 找到错误：`Error submitting enquiry: Object`
4. **点击展开 "Object"**
5. 截图完整的错误对象内容

---

## 🎯 请告诉我

1. **Anon Key 是否匹配？**
2. **Project URL 是否匹配？**
3. **控制台展开的错误详情是什么？**（截图）

根据这些信息，我可以确定真正的问题所在！
