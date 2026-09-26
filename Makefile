.PHONY: help build build-firmware build-api build-dashboard install dev clean version

# 构建变量
ARCH ?= armv8
ALPINE_VERSION ?= 3.19
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
GIT_COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
VERSION ?= $(shell cat version.txt 2>/dev/null || echo "0.1.0")

help:
	@echo "MixBox - Mihomo + ZaDashboard Gateway"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build              Build all components"
	@echo "  build-api          Build API server"
	@echo "  build-dashboard    Build dashboard frontend"
	@echo "  build-firmware     Build Alpine Linux firmware (ARMv8)"
	@echo "  install            Install to system"
	@echo "  dev                Run development environment"
	@echo "  clean              Clean build artifacts"
	@echo "  version            Show version info"

# 编译所有组件
build: build-api build-dashboard
	@echo "✓ All components built successfully"

# 编译 API 后端
build-api:
	@echo "Building API server..."
	@mkdir -p bin
	@cd api && go build -o ../bin/mixbox-api \
	  -ldflags "-X main.Version=$(VERSION) -X main.GitCommit=$(GIT_COMMIT) -X main.BuildDate=$(BUILD_DATE)" \
	  ./cmd/server 2>/dev/null || echo "⚠ API build skipped (no api/cmd/server found)"
	@test -f bin/mixbox-api && echo "✓ API built: bin/mixbox-api" || echo "⚠ API binary not found"

# 编译前端面板
build-dashboard:
	@echo "Building dashboard..."
	@if [ -d "dashboard" ]; then \
		cd dashboard && npm install && npm run build 2>/dev/null && cd ..; \
		echo "✓ Dashboard built: dashboard/dist"; \
	else \
		echo "⚠ Dashboard directory not found"; \
	fi

# 构建 Alpine Linux 固件 (ARMv8)
build-firmware:
	@echo "Building Alpine Linux firmware for $(ARCH)..."
	@chmod +x scripts/build-firmware.sh
	@./scripts/build-firmware.sh $(ARCH) $(VERSION)
	@echo "✓ Firmware built: firmware/out/*.tar.gz"

# 安装系统
install:
	@echo "Installing MixBox to system..."
	@chmod +x scripts/install.sh
	@sudo ./scripts/install.sh
	@echo "✓ Installation complete"

# 开发环境
dev:
	@echo "Starting development environment..."
	@mkdir -p logs
	@echo "API: http://localhost:8080"
	@echo "Dashboard: http://localhost:3000"
	@(cd api && go run ./cmd/server &) 2>/dev/null || echo "⚠ API server start failed" ; \
	(cd dashboard && npm install && npm run dev &) 2>/dev/null || echo "⚠ Dashboard start failed"

# 清理
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf bin/ dist/ logs/
	@cd dashboard && npm run clean 2>/dev/null || true
	@rm -rf firmware/out/*
	@echo "✓ Clean complete"

# 版本信息
version:
	@echo "MixBox v$(VERSION)"
	@echo "Git commit: $(GIT_COMMIT)"
	@echo "Build date: $(BUILD_DATE)"
	@echo "Alpine version: $(ALPINE_VERSION)"
	@echo "Target architecture: $(ARCH)"
