# 🚀 Vercel 部署指南

## 快速部署步骤

### 第一步：确认 Supabase 数据库已设置

1. 登录 [Supabase Dashboard](https://supabase.com/dashboard)
2. 选择项目：`https://zoxjvuafzkymgxmsluif.supabase.co`
3. 进入 **SQL Editor**
4. 复制 `supabase_schema.sql` 的内容
5. 执行 SQL 创建表和数据

### 第二步：在 Vercel 部署

#### 配置选项

**Vercel Team**: `stickypoooop-ai's project` (或选择 Hobby)

**Project Name**: `naxiwell-industrial` (可以自定义)

**Framework Preset**: **Other** (静态网站)

**Environment Variables**:
- ✅ **不需要填写！**项目使用默认配置即可工作
- 如果需要自定义，可以添加：

| Key | Value | 说明 |
|-----|-------|------|
| `SUPABASE_URL` | `https://zoxjvuafzkymgxmsluif.supabase.co` | 可选 |
| `SUPABASE_ANON_KEY` | `eyJhbGciOiJIUz...` | 可选 |
| `ADMIN_KEY` | `12345678901234567890123456789012` | 可选 |

**Build Settings**:
- **Build Command**: 留空
- **Output Directory**: `./`
- **Install Command**: 留空

#### 点击 "Deploy"

等待 1-2 分钟完成部署。

### 第三步：获取部署 URL

部署完成后，你会得到一个 URL，例如：
- `https://naxiwell-industrial.vercel.app`
- 或 `https://naxiwell-industrial-xxx.vercel.app`

## 📝 Vercel 配置说明

### 当前配置 (vercel.json)

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
```

这个配置添加了基本的安全响应头。

### 环境变量工作原理

项目使用了灵活的配置系统：

1. **默认配置** (`config.js`):
   - 包含硬编码的 Supabase 凭证
   - 开箱即用，无需额外配置

2. **可选覆盖** (`env.js`):
   - 本地开发时可创建 `env.js` 覆盖默认值
   - 已在 `.gitignore` 中排除

3. **配置优先级**:
   ```
   window.ENV (env.js) > 默认值 (config.js)
   ```

## ✅ 部署后测试清单

访问你的部署 URL 并测试：

### 前台功能
- [ ] 首页正常显示
- [ ] 产品列表加载（应该显示 24 个产品）
- [ ] 搜索功能正常
- [ ] 筛选功能正常
- [ ] 产品详情页正常
- [ ] 添加到购物车正常
- [ ] 提交询价表单成功

### 管理后台
- [ ] 点击 Admin 按钮
- [ ] 使用密钥登录：`12345678901234567890123456789012`
- [ ] 查看产品列表
- [ ] 添加新产品
- [ ] 编辑产品
- [ ] 删除产品

### 数据库验证
在 Supabase Dashboard 中检查：
- [ ] Products 表有 24 条记录
- [ ] 提交询价后 Enquiries 表有新记录

## 🔄 更新部署

### 方法 1: Git Push 自动部署

```bash
# 修改代码后
git add .
git commit -m "Your changes"
git push origin main
```

Vercel 会自动检测到 push 并重新部署。

### 方法 2: Vercel Dashboard 手动部署

1. 访问 [Vercel Dashboard](https://vercel.com/dashboard)
2. 选择你的项目
3. 点击 "Redeploy"

## 🎨 自定义域名（可选）

1. 在 Vercel 项目设置中点击 **Domains**
2. 添加你的自定义域名
3. 按照指引配置 DNS 记录

## 🔧 故障排除

### 问题：产品不显示

**解决方案：**
1. 检查浏览器控制台是否有错误
2. 确认 Supabase 数据库已正确设置
3. 验证 `supabase_schema.sql` 已执行
4. 检查 Supabase RLS 策略是否允许公开读取

### 问题：管理员操作失败

**解决方案：**
1. 确认已登录管理员账户
2. 检查管理员密钥是否正确
3. 查看浏览器控制台错误信息
4. 验证 Supabase 连接正常

### 问题：Vercel 构建失败

**解决方案：**
1. 确认 `vercel.json` 格式正确
2. 检查是否有语法错误
3. 查看 Vercel 构建日志
4. 尝试重新部署

## 📊 监控和分析

### Vercel Analytics

在项目设置中启用 Vercel Analytics 可以查看：
- 页面访问量
- 性能指标
- 错误率

### Supabase Logs

在 Supabase Dashboard 中查看：
- API 调用记录
- 数据库查询日志
- 错误日志

## 🔒 安全建议

1. **修改管理员密钥**：
   - 在生产环境中使用强密钥
   - 定期更换密钥

2. **启用 Supabase RLS**：
   - 已在 schema 中配置
   - 定期审查策略

3. **监控访问**：
   - 使用 Vercel 和 Supabase 的日志功能
   - 设置异常告警

4. **HTTPS**：
   - Vercel 自动提供 HTTPS
   - 确保所有请求使用 HTTPS

## 📞 需要帮助？

- **Vercel 文档**: https://vercel.com/docs
- **Supabase 文档**: https://supabase.com/docs
- **项目仓库**: https://github.com/stickypoooop-AI/WEB-project

---

祝部署顺利！🎉
