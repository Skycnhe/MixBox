# MixBox - Mihomo + ZaDashboard 旁路由网关

基于 **Mihomo** 内核和 **ZaDashboard** 管理面板的 ARMv8 旁路由网关透明代理系统。所有功能集中在统一的网页面板中，支持自动固件生成和发布。

## 🎯 主要特性

- **Mihomo 内核**：高性能代理引擎
- **ZaDashboard 面板**：集中式管理控制，支持规则配置、流量监控、策略管理
- **旁路由架构**：透明代理，无缝接入现有网络
- **ARMv8 支持**：支持树莓派、Orange Pi 等 ARM 设备
- **自动发布**：CI/CD 流程自动编译和发布固件
- **完整功能集成**：DNS、DHCP、流量监控、负载均衡

## 📁 项目结构

```
MixBox/
├── docs/                      # 文档
│   ├── README.md
│   ├── INSTALL.md
│   └── CONFIGURATION.md
├── dashboard/                 # ZaDashboard 前端面板
│   ├── src/
│   ├── public/
│   └── package.json
├── core/                      # Mihomo 核心配置
│   ├── config/
│   │   ├── config.yaml
│   │   └── rules.yaml
│   └── scripts/
├── gateway/                   # 网关透明代理配置
│   ├── iptables/
│   ├── tproxy/
│   └── dns-hijack/
├── firmware/                  # 固件构建
│   ├── buildroot/
│   ├── patches/
│   └── configs/
├── scripts/                   # 辅助脚本
│   ├── install.sh
│   ├── build.sh
│   ├── deploy.sh
│   └── cleanup.sh
├── .github/workflows/         # CI/CD 工作流
│   ├── build-firmware.yml
│   └── release.yml
├── docker/                    # Docker 支持
│   └── Dockerfile
└── Makefile
```

## 🚀 快速开始

### 前置要求
- ARMv8 设备（树莓派 4B+、Orange Pi 5 等）
- Ubuntu/Debian 系统
- Docker（可选）

### 安装

```bash
git clone https://github.com/Skycnhe/MixBox.git
cd MixBox
chmod +x scripts/install.sh
sudo ./scripts/install.sh
```

### 编译固件

```bash
make firmware-armv8
```

### 启动服务

```bash
sudo systemctl start mixbox
sudo systemctl enable mixbox
```

### 访问面板

打开浏览器访问：`http://your-device-ip:9095`

## 📋 配置说明

### Mihomo 配置 (core/config/config.yaml)
```yaml
listen: 0.0.0.0
port: 7890
socks-port: 7891
redir-port: 7892
tproxy-port: 7893

mode: rule
log-level: info

dns:
  enable: true
  listen: 0.0.0.0:53
  enhanced-mode: fake-ip

rules:
  - 本地网络：直连
  - 代理规则：根据配置
```

### 网关透明代理
- TPROXY 透明代理
- iptables 规则链
- DNS 劫持

### ZaDashboard 功能
- 实时流量监控
- 代理策略配置
- 规则管理
- 节点编辑
- 性能统计

## 🔨 开发指南

### 本地开发

```bash
# 开发环境
make dev

# 启动 Dashboard
cd dashboard && npm install && npm run dev

# 启动 Mihomo
./scripts/run-mihomo-dev.sh
```

### 编译构建

```bash
# 编译 ARMv8 固件
make build-firmware ARCH=armv8

# 编译 ARM64 变体
make build-firmware ARCH=arm64
```

## 📦 自动发布流程

CI/CD 流程会自动：

1. **编译固件**：为支持的 ARMv8 平台
2. **生成镜像**：rootfs 镜像
3. **签名验证**：GPG 签名
4. **自动发布**：GitHub Releases

**触发条件**：
- 推送到 `main` 分支时自动构建最新版本
- 创建版本标签时发布正式版本

## 📖 使用文档

- [安装指南](./docs/INSTALL.md)
- [配置文档](./docs/CONFIGURATION.md)
- [常见问题](./docs/FAQ.md)
- [开发者指南](./docs/DEVELOPMENT.md)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License - 详见 [LICENSE](./LICENSE)

## 📞 支持

- GitHub Issues：报告问题
- Discussions：讨论功能
- Email：maintainer@example.com

---

**最后更新**：2026-09-26
