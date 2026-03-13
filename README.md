# CMake 自定义函数完整示例

## 基本语法

```cmake
function(函数名 参数1 参数2 ...)
    # 函数体
    # 使用 ${参数1} ${参数2} 访问参数
endfunction()
```

## 核心概念

### 1. 参数传递
- **命名参数**: 直接在函数定义中指定参数名
- **可变参数**: 使用 `ARGN` 获取额外参数
- **PARENT_SCOPE**: 使用 `PARENT_SCOPE` 在函数外修改变量

### 2. 参数解析
```cmake
cmake_parse_arguments(
    PREFIX              # 前缀
    "OPTIONS"           # 选项（无值）
    "ONE_VALUE_ARGS"    # 单值参数
    "MULTI_VALUE_ARGS"  # 多值参数
    ${ARGN}             # 传入的参数
)
```

## 示例函数

### 简单函数
```cmake
function(print_info message_text)
    message(STATUS "[INFO] ${message_text}")
endfunction()

print_info("Hello CMake")
```

### 带返回值的函数
```cmake
function(file_exists result_var file_path)
    if(EXISTS ${file_path})
        set(${result_var} TRUE PARENT_SCOPE)
    else()
        set(${result_var} FALSE PARENT_SCOPE)
    endif()
endfunction()

file_exists(exists "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp")
message(STATUS "文件存在: ${exists}")
```

### 使用 cmake_parse_arguments
```cmake
function(configure_compiler target_name)
    set(options DEBUG RELEASE)
    set(oneValueArgs STANDARD)
    set(multiValueArgs DEFINITIONS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARGS_DEBUG)
        message(STATUS "Debug 模式")
    endif()
    
    if(ARGS_STANDARD)
        message(STATUS "C++ 标准: ${ARGS_STANDARD}")
    endif()
    
    if(ARGS_DEFINITIONS)
        message(STATUS "定义: ${ARGS_DEFINITIONS}")
    endif()
endfunction()

configure_compiler(my_app DEBUG STANDARD "14" DEFINITIONS "ENABLE_LOGGING")
```

### 操作列表
```cmake
function(filter_sources output_var pattern)
    set(filtered "")
    foreach(source IN LISTS ARGN)
        if(source MATCHES ${pattern})
            list(APPEND filtered ${source})
        endif()
    endforeach()
    set(${output_var} "${filtered}" PARENT_SCOPE)
endfunction()

set(all_sources main.cpp test_main.cpp helper.cpp)
filter_sources(test_sources "test_" ${all_sources})
```

## 实用函数示例

### 平台检测
```cmake
function(configure_platform target_name)
    if(WIN32)
        target_compile_definitions(${target_name} PRIVATE PLATFORM_WINDOWS)
    elseif(APPLE)
        target_compile_definitions(${target_name} PRIVATE PLATFORM_MACOS)
    elseif(UNIX)
        target_compile_definitions(${target_name} PRIVATE PLATFORM_LINUX)
    endif()
endfunction()
```

### 设置警告级别
```cmake
function(set_warnings target_name level)
    if(level STREQUAL "high")
        if(MSVC)
            target_compile_options(${target_name} PRIVATE /W4)
        else()
            target_compile_options(${target_name} PRIVATE -Wall -Wextra -Wpedantic)
        endif()
    endif()
endfunction()
```

### 创建可执行文件
```cmake
function(create_executable exe_name)
    set(options USE_PCH)
    set(oneValueArgs OUTPUT_DIR)
    set(multiValueArgs SOURCES LIBRARIES INCLUDE_DIRS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValue_ARGS}" ${ARGN})

    add_executable(${exe_name} ${ARGS_SOURCES})
    
    if(ARGS_INCLUDE_DIRS)
        target_include_directories(${exe_name} PRIVATE ${ARGS_INCLUDE_DIRS})
    endif()
    
    if(ARGS_LIBRARIES)
        target_link_libraries(${exe_name} ${ARGS_LIBRARIES})
    endif()
endfunction()
```

## 最佳实践

1. **函数命名**: 使用描述性名称，如 `create_executable`、`configure_warnings`
2. **参数解析**: 对于复杂函数，始终使用 `cmake_parse_arguments`
3. **作用域**: 记住函数有自己的作用域，需要使用 `PARENT_SCOPE` 修改外部变量
4. **文档**: 为函数添加注释说明用途和参数
5. **模块化**: 将常用函数放入单独的 `.cmake` 文件中

## 运行示例

```bash
# 运行测试脚本
./test.sh

# 或手动构建
mkdir build && cd build
cmake ..
cmake --build .
./demo_advanced
```

## 输出示例

```
-- 配置 macOS 平台: demo_advanced
-- 警告级别: 中
-- 启用功能: logging
-- 设置版本: 1.2.3
-- 项目名称: AdvancedCustomFunctions
-- C++ 标准: C++14
```
