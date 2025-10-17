# 🔧 Enquiry Submission Fix Guide

## ⚠️ 文件说明

### 这是**全新文件**，不是替换！

- **新文件**: `supabase_enquiries_fix.sql` ✨ **← 执行这个！**
- **旧文件**: `supabase_enquiries_policies.sql` （保留作为备份，不用删除）

---

## 📋 执行步骤

### Step 1: 打开 Supabase SQL Editor

1. 登录 **Supabase Dashboard**
2. 选择你的项目：**zoxiyuaf2kymgxmsluifsql**
3. 点击左侧菜单 **SQL Editor**

---

### Step 2: 执行新的修复脚本

1. 点击 **"New query"** 或打开现有的 query
2. 复制 **`supabase_enquiries_fix.sql`** 的全部内容
3. 粘贴到 SQL Editor 中
4. 点击 **"Run"** 按钮（或按 `Ctrl/Cmd + Enter`）

---

### Step 3: 验证执行结果

执行成功后，你应该看到 **3 个查询结果表格**：

#### 结果 1: Policies List (策略列表)
应该显示 **2 条策略**：
| policyname | cmd | with_check | qual |
|------------|-----|------------|------|
| Enable insert for all users | INSERT | true | - |
| Enable read access for authenticated users | SELECT | - | (auth.role() = 'authenticated') |

#### 结果 2: RLS Status (RLS 状态)
| tablename | rls_enabled |
|-----------|-------------|
| enquiries | true |

#### 结果 3: Success Message
✅ Enquiries RLS Policies have been completely reset and reconfigured!

---

## 🔍 如果执行失败

### 常见错误 1: "permission denied"
**解决方案**：
- 确保你使用的是项目的 **postgres** 角色
- 或者在 Supabase Dashboard → Database → Roles 中检查权限

### 常见错误 2: "relation does not exist"
**解决方案**：
- 先执行 `supabase_schema.sql` 创建 enquiries 表
- 或检查表名是否正确

---

## 🧪 测试步骤

执行脚本后，立即测试：

1. **访问网站**：https://web-project-naxiwell.vercel.app
2. **添加产品到购物车**
3. **填写询价表单**
4. **提交询价**
5. **应该成功**，并收到确认消息

---

## 📊 与旧脚本的区别

| 特性 | 旧脚本 (policies.sql) | 新脚本 (fix.sql) |
|------|----------------------|------------------|
| 清理现有策略 | ✅ 部分清理 | ✅ 完全清理 |
| RLS 重置 | ❌ 没有 | ✅ 完全禁用再启用 |
| 策略数量 | 2 条 | 2 条（但更明确） |
| 验证查询 | ❌ 只有消息 | ✅ 完整验证表格 |
| 策略命名 | 模糊 | 清晰明确 |

---

## ❓ 为什么需要新脚本？

旧脚本的问题：
1. 没有完全重置 RLS（可能有缓存的旧策略）
2. 策略命名不够明确
3. 缺少验证步骤

新脚本的改进：
1. ✅ 完全禁用再重新启用 RLS（清除缓存）
2. ✅ 使用更明确的策略名称和权限
3. ✅ 包含完整的验证查询
4. ✅ 显示策略的实际配置状态

---

## 🎯 执行后的预期结果

### 数据库层面
- ✅ enquiries 表启用 RLS
- ✅ 公共用户可以 INSERT（提交询价）
- ✅ 认证用户可以 SELECT（查看询价）

### 应用层面
- ✅ 客户可以成功提交询价表单
- ✅ 数据保存到 Supabase enquiries 表
- ✅ EmailJS 发送邮件通知到 stickypoooop@gmail.com

---

## 📞 需要帮助？

如果执行后仍然失败：
1. 截图 SQL Editor 的执行结果
2. 截图浏览器控制台的错误信息（F12 → Console）
3. 告诉我具体的错误提示
