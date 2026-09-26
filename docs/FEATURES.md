# MixBox 面板功能详细说明

## 📊 仪表板（Dashboard）
- 实时流量监控（入站/出站）
- 网关运行状态
- CPU/内存/磁盘使用率
- 活跃连接数
- 快速启停功能

---

## 🔗 订阅管理（Subscription）

### 功能特性
- **添加订阅**：支持多种格式
  - Clash 订阅链接（`clash://...`）
  - ShadowSocks (SS)
  - ShadowSocksR (SSR)
  - V2Ray/Vmess
  - Trojan
  - VLESS
  - 自定义混合格式

- **订阅列表**
  - 订阅名称和链接
  - 最后更新时间
  - 节点数量统计
  - 订阅状态（正常/失败/过期）
  - 自动更新周期设置（1小时/6小时/12小时/24小时/自定义）

- **订阅操作**
  ```
  ├── 手动更新订阅
  ├── 编辑订阅链接
  ├── 删除订阅
  ├── 测试订阅延迟
  ├── 订阅预览（节点列表）
  └── 定时自动更新
  ```

- **订阅转换**
  - 自动解析不同格式
  - 统一存储为内部格式
  - 支持自定义过滤规则

### API 接口
```
POST   /api/subscriptions/add       # 添加订阅
GET    /api/subscriptions           # 获取订阅列表
DELETE /api/subscriptions/:id       # 删除订阅
PUT    /api/subscriptions/:id       # 更新订阅
POST   /api/subscriptions/:id/test  # 测试订阅
POST   /api/subscriptions/:id/update # 立即更新
GET    /api/subscriptions/:id/nodes # 获取订阅中的节点
```

---

## 📋 规则管理（Rules）

### 规则类型
1. **GeoIP 规则**
   - 国内直连
   - 国外代理
   - 自定义地区规则

2. **域名规则**
   - 精确匹配
   - 前缀匹配
   - 正则表达式
   - 域名列表（批量导入）

3. **IPCIDR 规则**
   - IP 段路由
   - CIDR 表示法

4. **基于应用的规则**
   - 按应用 UID 分流
   - 应用黑名单/白名单

### 规则操作
```
├── 创建规则组
├── 导入规则文件（.txt / .yaml）
├── 编辑规则
├── 删除规则
├── 启用/禁用规则
├── 规则优先级排序
├── 规则预览和测试
└── 规则导出备份
```

### 规则配置示例
```yaml
# 规则组配置
groups:
  - name: 国内直连
    type: domain
    action: direct
    rules:
      - domain: baidu.com
      - domain-suffix: qq.com
      - domain-prefix: .github
      
  - name: 代理规则
    type: domain
    action: proxy
    proxy-policy: 自动选择
    rules:
      - domain: google.com
      - domain-suffix: facebook.com
      
  - name: 游戏加速
    type: geoip
    action: proxy
    proxy-policy: 游戏节点
    regions:
      - US
      - JP
```

### API 接口
```
POST   /api/rules/group/add         # 创建规则组
GET    /api/rules/groups            # 获取所有规则组
PUT    /api/rules/group/:id         # 编辑规则组
DELETE /api/rules/group/:id         # 删除规则组
POST   /api/rules/import            # 导入规则文件
POST   /api/rules/test              # 测试规则（输入域名/IP）
GET    /api/rules/export            # 导出规则
```

---

## 🔄 内核更新（Kernel Update）

### Mihomo 内核管理

#### 当前版本信息
- 当前版本号
- 编译时间
- Commit Hash
- 构建参数

#### 自动更新功能
```
├── 检查最新版本
│   ├── 官方 GitHub Release
│   ├── 自定义仓库源
│   └── 本地编译版本
│
├── 更新渠道设置
│   ├── 稳定版（Stable）
│   ├── 测试版（Beta）
│   ├── 每日构建（Nightly）
│   └── 自定义构建源
│
├── 更新操作
│   ├── 检查更新
│   ├── 预下载
│   ├── 自动更新计划
│   ├── 一键更新
│   └── 回滚到上一个版本
│
└── 更新状态
    ├── 下载进度
    ├── 校验和验证（SHA256）
    ├── 更新日志
    └── 更新历史记录
```

#### 更新流程
```
用户点击"检查更新"
    ↓
连接到版本源（GitHub/自定义）
    ↓
比对版本号（当前 vs 最新）
    ↓
若有新版本，显示更新提示和 Changelog
    ↓
用户确认更新
    ↓
后台下载新版本二进制
    ↓
SHA256 校验和验证
    ↓
备份当前版本
    ↓
替换二进制文件
    ↓
重启 Mihomo 服务
    ↓
验证启动成功
    ↓
显示更新完成/失败信息
    ↓
若失败自动回滚到上一个版本
```

#### 版本源配置
```json
{
  "sources": [
    {
      "name": "官方 (MetaCubeX)",
      "repo": "MetaCubeX/mihomo",
      "channel": "stable",
      "enabled": true
    },
    {
      "name": "自定义构建",
      "repo": "your-org/mihomo-builds",
      "channel": "custom",
      "enabled": false
    }
  ],
  "updateChannel": "stable",
  "autoUpdate": {
    "enabled": false,
    "schedule": "0 2 * * *"  // 每天凌晨2点
  }
}
```

### API 接口
```
GET    /api/kernel/version          # 获取当前版本信息
GET    /api/kernel/check-update     # 检查更新
GET    /api/kernel/changelog        # 获取更新日志
POST   /api/kernel/update           # 执行更新
POST   /api/kernel/rollback         # 回滚版本
GET    /api/kernel/update-status    # 更新进度
GET    /api/kernel/history          # 版本历史
PUT    /api/kernel/config           # 配置更新源
```

---

## 🔐 节点管理（Nodes）

### 功能特性
- 节点列表展示
- 添加/编辑/删除节点
- 节点延迟测试（TCPing/HTTP Ping）
- 节点分组
- 节点状态监控
- 批量操作

### 节点类型支持
- Socks5
- HTTP
- SS (ShadowSocks)
- SSR (ShadowSocksR)
- Vmess
- VLESS
- Trojan
- Hysteria

---

## 🎯 代理策略（Policies）

### 策略类型
- **直连**：不走代理
- **代理**：选定节点或策略
- **自动选择**：根据延迟自动选择最优节点
- **负载均衡**：轮询分配流量
- **故障转移**：主节点失败切换备用
- **URL 测试**：定期检测节点可用性

### 策略管理
```
├── 创建策略
├── 编辑策略规则
├── 删除策略
├── 策略排序
├── 测试策略延迟
├── 实时切换策略
└── 策略历史记录
```

---

## 📡 DNS 管理（DNS）

### DNS 功能
- 多 DNS 源配置
- DNS 劫持设置
- 缓存管理
- 域名拦截列表
- DNS 查询日志

---

## 📊 日志与监控（Logs & Monitor）

### 实时监控
- 实时流量图表
- 活跃连接列表
- 连接详情（来源/目的地/协议/流量）

### 日志
- 访问日志（连接/DNS）
- 错误日志
- 系统日志
- 日志导出和分析

---

## 🛠️ 系统管理（System）

### 系统控制
- 启动/停止/重启 Mihomo
- 系统重启
- 服务状态监控
- 资源使用情况

### 备份恢复
- 配置备份（本地/云存储）
- 配置还原
- 备份版本管理

### 高级设置
- Mihomo 高级参数调优
- 性能优化选项
- 日志级别设置
- 调试模式

---

## 🔑 用户与权限（Auth）

### 认证方式
- 用户名/密码
- Token 认证
- 设备指纹识别

### 权限控制
- 不同用户权限等级
- 操作审计日志

---

## 📱 技术栈建议

### 后端
```
├── Go / Python Flask
├── RESTful API
├── WebSocket (实时推送)
├── SQLite/PostgreSQL (数据存储)
└── gRPC (与 Mihomo 通信)
```

### 前端
```
├── React / Vue 3
├── TypeScript
├── TailwindCSS / Material-UI
├── WebSocket 客户端
└── ECharts (数据可视化)
```

### 部署
```
├── Docker 容器化
├── systemd 服务单元
└── ARMv8 交叉编译支持
```

---

## 🚀 实现优先级建议

### Phase 1 (MVP)
- [ ] 仪表板展示
- [ ] 订阅管理（添加/更新）
- [ ] 基本规则配置
- [ ] 内核版本显示

### Phase 2
- [ ] 内核自动更新
- [ ] 规则导入导出
- [ ] 节点延迟测试
- [ ] 日志查看

### Phase 3
- [ ] 策略管理
- [ ] DNS 配置
- [ ] 实时监控数据
- [ ] 备份恢复

### Phase 4
- [ ] 用户权限系统
- [ ] 高级调优选项
- [ ] 插件系统
- [ ] 移动端适配
