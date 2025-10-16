# 📧 EmailJS 配置步骤

## Step 1: 注册 EmailJS 账户

1. 访问：https://www.emailjs.com/
2. 点击 **"Sign Up"** 注册免费账户
3. 使用你的邮箱注册（建议用 Gmail）
4. 验证邮箱并登录

---

## Step 2: 添加邮件服务 (Email Service)

1. 登录后，进入 **"Email Services"** 页面
2. 点击 **"Add New Service"**
3. 选择 **"Gmail"** 作为邮件服务
4. 点击 **"Connect Account"**
5. 使用 **stickypoooop@gmail.com** 登录并授权
6. 服务创建成功后，**复制 Service ID**（类似：`service_xxxxxxx`）

---

## Step 3: 创建邮件模板 (Email Template)

1. 进入 **"Email Templates"** 页面
2. 点击 **"Create New Template"**
3. 设置模板内容：

### 模板设置：
- **Template Name**: `enquiry_notification`
- **Subject**: `新询价 - {{customer_name}} ({{company_name}})`
- **Content** (复制下面的内容):

```
您收到一条新的产品询价！

客户信息：
------------------------------
姓名：{{customer_name}}
公司：{{company_name}}
邮箱：{{customer_email}}
电话：{{customer_phone}}
地址：{{customer_address}}

产品清单：
------------------------------
{{products_list}}

备注信息：
------------------------------
{{notes}}

------------------------------
提交时间：{{submission_time}}

此邮件由 NaxiWell Industrial 自动发送
```

4. 点击 **"Save"**
5. **复制 Template ID**（类似：`template_xxxxxxx`）

---

## Step 4: 获取 Public Key

1. 进入 **"Account"** → **"General"** 页面
2. 找到 **"Public Key"** 部分
3. **复制 Public Key**（类似：`xxxxxxxxxxxxxxxxxxx`）

---

## Step 5: 将配置信息提供给我

完成以上步骤后，请提供以下三个信息：

```
Service ID: service_xxxxxxx
Template ID: template_xxxxxxx
Public Key: xxxxxxxxxxxxxxxxxxx
```

---

## 🎯 配置完成后

将这三个值告诉我，我会创建配置文件并更新代码。

---

## ❓ 常见问题

### Q1: Gmail 授权失败？
**解决**：检查 Gmail 账户的"安全性较低的应用访问权限"设置

### Q2: 免费账户限制？
**回答**：每月 200 封邮件，对测试和小规模使用足够

### Q3: 邮件进入垃圾箱？
**解决**：
1. 将 service@emailjs.com 加入联系人
2. 首次收到邮件时标记为"非垃圾邮件"

---

## 📝 备注

- EmailJS 使用你的 Gmail 账户发送邮件
- 邮件的 "From" 地址会是你的 Gmail
- 所有询价邮件会发送到 stickypoooop@gmail.com
- 每封邮件包含完整的客户信息和产品清单
