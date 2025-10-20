# 🇨🇳 添加中文名称支持 - 执行指南

## 📋 问题说明

当前情况：切换到中文后，分类和材料的名称仍然显示英文。

**原因**：数据库中的 `categories` 和 `materials` 表缺少 `name_zh` 字段。

## 🔧 解决方案

执行 `add_chinese_names.sql` 脚本来：
1. 为 categories 表添加 `name_zh` 字段
2. 为 materials 表添加 `name_zh` 字段
3. 为 products 表添加 `description_zh` 字段
4. 为所有现有分类和材料填充中文名称

## 📝 执行步骤

### 步骤 1: 登录 Supabase Dashboard

1. 访问 [Supabase Dashboard](https://supabase.com/dashboard)
2. 选择你的项目

### 步骤 2: 打开 SQL Editor

1. 点击左侧菜单的 **"SQL Editor"**
2. 点击 **"New query"** 创建新查询

### 步骤 3: 复制并执行 SQL 脚本

1. 打开 `add_chinese_names.sql` 文件
2. 复制**全部内容**
3. 粘贴到 Supabase SQL Editor
4. 点击 **"Run"** 或按 `Ctrl/Cmd + Enter` 执行

### 步骤 4: 验证执行结果

执行成功后，你应该看到类似以下输出：

```
✅ Added name_zh columns to categories and materials tables
✅ Updated categories with Chinese names
✅ Updated materials with Chinese names
✅ Added description_zh column to products table

=== CATEGORIES WITH CHINESE NAMES ===
name            | display_name      | name_zh
----------------|-------------------|----------
anchors         | Anchors           | 锚栓
bolts           | Bolts             | 螺栓
nuts            | Nuts              | 螺母
one-way-clutch  | One Way Clutch    | 单向离合器
rivets          | Rivets            | 铆钉
screws          | Screws            | 螺丝
two-way-clutch  | two-way-clutch    | 双向离合器
washers         | Washers           | 垫圈

=== MATERIALS WITH CHINESE NAMES ===
name              | display_name      | name_zh
------------------|-------------------|----------
aluminum          | Aluminum          | 铝
brass             | Brass             | 黄铜
carbon-steel      | Carbon Steel      | 碳钢
nylon             | Nylon             | 尼龙
rubber            | Rubber            | 橡胶
stainless-steel   | Stainless Steel   | 不锈钢
te-gcr            | Te Gcr            | Te Gcr
```

### 步骤 5: 测试网站

1. 打开你的网站
2. 按 **Ctrl+Shift+R** (Windows) 或 **Cmd+Shift+R** (Mac) 强制刷新
3. 点击 **"中文"** 按钮切换语言
4. 验证分类和材料是否显示为中文

## ✅ 预期结果

执行脚本后，切换到中文时应该看到：

### 分类侧边栏
```
Before (英文)          After (中文)
─────────────────────────────────
All Products        →  所有产品
Bolts               →  螺栓
Nuts                →  螺母
One Way Clutch      →  单向离合器
Rivets              →  铆钉
Screws              →  螺丝
two-way-clutch      →  双向离合器
```

### 材料筛选
```
Before (英文)          After (中文)
─────────────────────────────────
All Materials       →  所有材料
Aluminum            →  铝
Brass               →  黄铜
Carbon Steel        →  碳钢
Nylon               →  尼龙
Rubber              →  橡胶
Stainless Steel     →  不锈钢
```

### 产品卡片
```
Before: "Stainless Steel | M6 x 40mm"
After:  "不锈钢 | M6 x 40mm"
```

### 管理界面
管理员界面的分类和材料列表也会显示中文名称。

## 🎯 中文翻译对照表

### 分类 (Categories)
| English Name | 中文名称 |
|--------------|---------|
| Screws | 螺丝 |
| Bolts | 螺栓 |
| Nuts | 螺母 |
| Washers | 垫圈 |
| Anchors | 锚栓 |
| Rivets | 铆钉 |
| One Way Clutch | 单向离合器 |
| two-way-clutch | 双向离合器 |

### 材料 (Materials)
| English Name | 中文名称 |
|--------------|---------|
| Stainless Steel | 不锈钢 |
| Carbon Steel | 碳钢 |
| Brass | 黄铜 |
| Aluminum | 铝 |
| Rubber | 橡胶 |
| Nylon | 尼龙 |
| Te Gcr | Te Gcr |

## 💡 添加新的分类或材料

执行脚本后，在管理面板添加新分类或材料时，可以填写中文名称：

### 添加分类示例
```
Category name: washers
Display name: Washers
Chinese name (optional): 垫圈  ← 填写中文名称
```

### 添加材料示例
```
Material name: stainless-steel
Display name: Stainless Steel
Chinese name (optional): 不锈钢  ← 填写中文名称
```

### 添加产品时填写中文描述
```
Description: High-quality stainless steel screws...
Chinese Description (optional): 优质不锈钢螺丝...  ← 填写中文描述
```

## 🔍 故障排除

### 问题 1: 执行脚本后仍然显示英文

**解决方案**:
1. 强制刷新浏览器（Ctrl+Shift+R 或 Cmd+Shift+R）
2. 清除浏览器缓存
3. 检查浏览器控制台是否有错误

### 问题 2: SQL 执行失败

**可能原因**:
- 网络连接问题
- 权限不足
- 表结构已经改变

**解决方案**:
1. 确保你是项目的管理员
2. 重新执行脚本
3. 检查 Supabase 日志中的错误信息

### 问题 3: 某些分类或材料没有中文

**解决方案**:
1. 检查数据库中是否有该分类/材料
2. 手动在管理面板编辑并添加中文名称
3. 或在 SQL Editor 中手动执行：
   ```sql
   UPDATE categories SET name_zh = '中文名' WHERE name = 'english-name';
   ```

## 📞 需要帮助？

如果遇到问题：
1. 检查 Supabase SQL Editor 的错误消息
2. 查看浏览器控制台的错误日志
3. 确认数据库表结构是否正确

## ✨ 完成确认

执行脚本后，你应该能够：
- ✅ 看到分类侧边栏显示中文（如：螺丝、螺栓、螺母等）
- ✅ 看到材料筛选显示中文（如：不锈钢、碳钢、黄铜等）
- ✅ 看到产品卡片中的材料显示中文
- ✅ 在管理界面看到分类和材料的中文名称
- ✅ 切换语言时，所有动态内容都自动更新

---

**创建日期**: 2025-10-20
**文件**: `add_chinese_names.sql`
**状态**: 准备执行
