# CMake 自定义函数快速参考

## 基本语法
```cmake
function(name arg1 arg2 ...)
    # 函数体
endfunction()
```

## 关键变量
| 变量 | 说明 |
|------|------|
| `${arg1}` | 命名参数 |
| `${ARGN}` | 额外参数列表 |
| `${ARGV}` | 所有参数 |
| `${ARGC}` | 参数数量 |
| `PARENT_SCOPE` | 修改父作用域变量 |

## 参数解析模板
```cmake
function(func_name)
    set(options OPT1 OPT2)           # 布尔选项
    set(oneValueArgs NAME VERSION)    # 单值参数
    set(multiValueArgs SOURCES LIBS)  # 多值参数
    cmake_parse_arguments(PREFIX "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # 使用: ${PREFIX_OPT1}, ${PREFIX_NAME}, ${PREFIX_SOURCES}
endfunction()
```

## 常用模式

### 返回值
```cmake
function(get_result out_var)
    set(${out_var} "result" PARENT_SCOPE)
endfunction()
```

### 遍历列表
```cmake
function(process_list)
    foreach(item IN LISTS ARGN)
        message(STATUS "${item}")
    endforeach()
endfunction()
```

### 条件判断
```cmake
function(check_condition value)
    if(value STREQUAL "yes")
        message(STATUS "条件满足")
    elseif(value MATCHES "pattern")
        message(STATUS "匹配模式")
    endif()
endfunction()
```

### 文件操作
```cmake
function(find_files out_var pattern)
    file(GLOB files ${pattern})
    set(${out_var} "${files}" PARENT_SCOPE)
endfunction()
```

## 目标操作
```cmake
function(add_definitions target)
    target_compile_definitions(${target} PRIVATE ${ARGN})
endfunction()

function(add_includes target)
    target_include_directories(${target} PRIVATE ${ARGN})
endfunction()

function(link_libraries target)
    target_link_libraries(${target} ${ARGN})
endfunction()
```

## 调用示例
```cmake
# 简单调用
my_function("arg1" "arg2")

# 使用选项
my_function(OPT1 NAME "myapp" SOURCES a.cpp b.cpp)

# 使用变量
set(my_list a.cpp b.cpp c.cpp)
my_function(${my_list})
```

## 常见错误
- ❌ 忘记 `PARENT_SCOPE` 导致变量未修改
- ❌ 函数名与内置命令冲突
- ❌ 参数解析时选项拼写错误
- ❌ 未检查变量是否定义就使用

## 调试技巧
```cmake
function(debug_print var)
    message(STATUS "${var} = ${${var}}")
endfunction()

debug_print(MY_VARIABLE)
```
