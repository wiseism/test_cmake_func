#!/bin/bash

echo "========================================"
echo "  CMake 自定义函数测试脚本"
echo "========================================"
echo ""

# 创建构建目录
BUILD_DIR="build"
if [ -d "$BUILD_DIR" ]; then
    echo "清理旧的构建目录..."
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
echo "创建构建目录: $BUILD_DIR"
echo ""

# 运行 CMake 配置
echo "运行 CMake 配置..."
cd "$BUILD_DIR"
cmake ..
echo ""

# 运行构建
echo "运行构建..."
cmake --build .
echo ""

# 运行程序（如果构建成功）
if [ -f "demo_advanced" ] || [ -f "demo_advanced.exe" ]; then
    echo "========================================"
    echo "  运行程序"
    echo "========================================"
    if [ -f "demo_advanced" ]; then
        ./demo_advanced
    else
        ./demo_advanced.exe
    fi
else
    echo "程序未找到"
fi

cd ..
echo ""
echo "========================================"
echo "  测试完成"
echo "========================================"
