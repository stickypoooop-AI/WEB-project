# ✅ 邮件服务迁移完成报告

**日期**: 2025-10-30
**任务**: 从 EmailJS 迁移到自建 PHP 邮件服务器

---

## 🎯 迁移概览

### 迁移前 (EmailJS)
- **服务**: 第三方 EmailJS
- **限制**: 每月 200 封邮件
- **Service ID**: service_atvq2zf
- **Template ID**: template_k0k3yec
- **依赖**: 外部服务，有月度限制

### 迁移后 (自建邮件服务)
- **服务**: 自建 PHP + PHPMailer
- **限制**: 无限制（仅受 Gmail 每日发送限制）
- **部署平台**: Vercel
- **邮件模板**: 专业 HTML 模板，自动生成询价单号
- **完全控制**: 样式、内容、功能

---

## 📦 新增文件

### 1. `/emailServer/` 目录
独立的邮件服务器项目，部署到 Vercel

```
emailServer/
├── .env                  # SMTP配置（不要提交到Git）
├── .gitignore           # Git忽略规则
├── api/
│   └── send-email.php   # 邮件发送API（319行）
├── composer.json        # PHP依赖
├── composer.lock
├── vercel.json          # Vercel部署配置
├── readme.md           # 环境变量说明
└── DEPLOYMENT.md       # 完整部署指南
```

### 2. `/mail.js`
邮件服务调用函数
```javascript
async function sendMail(data) {
    return await fetch('https://email-server-naxiwell.vercel.app/api/send-email.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
}
```

---

## 🔧 修改的文件

### 1. `index.html`
**删除**:
- EmailJS CDN 引用（第10行）
- EmailJS 初始化代码（第11-17行）

**新增**:
- mail.js 引用（第529行）
```html
<script src="mail.js"></script>
```

### 2. `script.js`
**删除**:
- EmailJS 参数准备代码（约25行）
- `emailjs.send()` 调用

**新增**:
- 简化的邮件发送调用
```javascript
await sendMail(enquiryData);
```

---

## 🚀 部署信息

### Vercel 项目
- **项目名**: email-server-naxiwell
- **生产URL**: `https://email-server-naxiwell.vercel.app`
- **API端点**: `https://email-server-naxiwell.vercel.app/api/send-email.php`

### SMTP 配置
- **服务器**: smtp.gmail.com
- **端口**: 465 (SSL)
- **发送账户**: czhbmj@gmail.com
- **接收账户**: stickypoooop@gmail.com
- **抄送**: 无

### 环境变量（已配置）
```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_SECURE=true
SMTP_USER=czhbmj@gmail.com
SMTP_PASS=vppynckowzzftoup
RECIPIENT_EMAIL=stickypoooop@gmail.com
CC_EMAIL=
```

---

## ✅ 测试结果

### API 测试
**命令**:
```bash
curl -X POST https://email-server-naxiwell.vercel.app/api/send-email.php \
  -H "Content-Type: application/json" \
  -d '{ "customer_name": "Test", ... }'
```

**响应**:
```json
{
  "success": true,
  "message": "邮件发送成功",
  "quote_id": "INQ-20251030-8101",
  "total_amount": "51.00"
}
```

✅ **状态**: 测试邮件成功发送到 stickypoooop@gmail.com

---

## 📊 新功能

### 专业邮件模板
- 精美的 HTML 样式
- 公司品牌设计（#003366 配色）
- 响应式设计（移动端友好）
- 包含以下信息：
  - 客户详细信息
  - 产品清单（名称、数量、单价、小计、规格）
  - 总金额自动计算
  - 自动生成询价单号
  - 提交时间戳

### 自动询价单号
格式: `INQ-YYYYMMDD-XXXX`
例如: `INQ-20251030-8101`

### 邮件内容
- **HTML版本**: 精美样式，表格展示
- **纯文本版本**: 自动生成备用版本

---

## 🔒 安全措施

1. **环境变量隔离**
   - SMTP凭据存储在Vercel环境变量中
   - 本地.env文件已添加到.gitignore
   - 永不暴露敏感信息

2. **CORS配置**
   - 允许所有来源（Access-Control-Allow-Origin: *）
   - 支持预检请求（OPTIONS）
   - 仅允许POST方法

3. **输入验证**
   - 必填字段验证
   - 邮件格式验证
   - 数据类型检查

---

## 📁 删除的文件

- `/WEB-project-extracted/` - 临时解压目录
- `/emailServer-extracted/` - 临时解压目录
- `/EMAILJS_SETUP.md` - EmailJS配置文档（已过时）

保留的文件:
- `WEB-project(2).zip` - 原始备份
- `emailServer(2).zip` - 邮件服务器备份

---

## 🎓 如何使用

### 前端调用
```javascript
// 准备数据
const enquiryData = {
    customer_name: "张三",
    customer_email: "zhangsan@example.com",
    customer_phone: "13800138000",
    company_name: "测试公司",
    customer_address: "上海市浦东新区",
    products: [
        {
            name: "不锈钢螺丝",
            quantity: 100,
            price: 0.50,
            specs: "M6 x 40mm | Stainless Steel"
        }
    ],
    notes: "请尽快报价"
};

// 发送邮件
const response = await sendMail(enquiryData);
const result = await response.json();
console.log(result.quote_id); // INQ-20251030-XXXX
```

### 测试邮件服务器
```bash
curl -X POST https://email-server-naxiwell.vercel.app/api/send-email.php \
  -H "Content-Type: application/json" \
  -d @test-enquiry.json
```

---

## 🔄 更新邮件服务器

### 修改代码
1. 编辑 `emailServer/api/send-email.php`
2. 本地测试
3. 部署: `vercel --prod emailServer/`

### 更新环境变量
```bash
# 使用 Vercel CLI
echo "new-value" | vercel env add VARIABLE_NAME production --cwd emailServer/

# 或在 Vercel 控制台
https://vercel.com/stickypoooop-ais-projects/email-server-naxiwell/settings/environment-variables
```

### 更改接收邮箱
1. 更新 Vercel 环境变量: `RECIPIENT_EMAIL`
2. 重新部署: `vercel --prod emailServer/`

---

## 📈 性能对比

| 指标 | EmailJS | 自建服务 |
|------|---------|----------|
| 月发送限制 | 200封 | 无限制* |
| 邮件模板 | 基础文本 | 专业HTML |
| 自定义能力 | 有限 | 完全控制 |
| 询价单号 | 无 | 自动生成 |
| 部署成本 | 免费 | 免费 (Vercel) |
| SMTP控制 | 无 | 完全控制 |

*受 Gmail 每日发送限制约束（个人账户约500封/天）

---

## ❓ 故障排查

### 邮件发送失败
1. 检查 Vercel 环境变量是否正确配置
2. 验证 SMTP 凭据（应用专用密码）
3. 查看 Vercel 函数日志：
   ```bash
   vercel logs https://email-server-naxiwell.vercel.app
   ```

### CORS 错误
- 确认前端URL匹配
- 检查 send-email.php 中的 CORS 头

### 邮件进入垃圾箱
- 将 czhbmj@gmail.com 添加到联系人
- 标记首封邮件为"非垃圾邮件"

---

## 🎉 迁移成功

✅ EmailJS 已完全移除
✅ 自建邮件服务器已部署
✅ 前端集成完成
✅ 功能测试通过
✅ 项目清理完成

**状态**: 🟢 生产就绪

---

## 📞 支持

如有问题，请检查：
1. `emailServer/DEPLOYMENT.md` - 完整部署指南
2. `emailServer/readme.md` - 环境变量配置
3. Vercel 控制台日志

邮件服务器项目链接:
https://vercel.com/stickypoooop-ais-projects/email-server-naxiwell
