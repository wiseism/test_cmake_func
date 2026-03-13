cmake_minimum_required(VERSION 3.10)
project(CustomFunctionDemo)

set(CMAKE_CXX_STANDARD 11)

# 定义版本宏
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
set(VERSION_PATCH 0)

# 包含高级函数定义
include(${CMAKE_CURRENT_SOURCE_DIR}/advanced_functions.cmake)

message(STATUS "=== CMake 自定义函数示例 ===")

# 示例1: 简单的自定义函数 - 打印信息
function(print_info message_text)
    message(STATUS "[INFO] ${message_text}")
endfunction()

# 调用简单函数
print_info("这是第一个自定义函数调用")

# 示例2: 带参数的函数 - 创建源文件列表
function(create_source_list output_var)
    set(source_list "")
    foreach(arg IN LISTS ARGN)
        list(APPEND source_list ${arg})
    endforeach()
    set(${output_var} "${source_list}" PARENT_SCOPE)
endfunction()

# 调用函数创建源文件列表
create_source_list(MY_SOURCES main.cpp helper.cpp utils.cpp)
message(STATUS "源文件列表: ${MY_SOURCES}")

# 示例3: 带返回值的函数 - 检查文件是否存在
function(file_exists result_var file_path)
    if(EXISTS ${file_path})
        set(${result_var} TRUE PARENT_SCOPE)
    else()
        set(${result_var} FALSE PARENT_SCOPE)
    endif()
endfunction()

# 调用函数检查文件
file_exists(main_exists "${CMAKE_CURRENT_SOURCE_DIR}/main.cpp")
message(STATUS "main.cpp 存在: ${main_exists}")

# 示例4: 带默认参数的函数 - 配置编译选项
function(configure_compiler target_name)
    set(options DEBUG RELEASE)
    set(oneValueArgs STANDARD)
    set(multiValueArgs DEFINITIONS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    message(STATUS "配置目标: ${target_name}")
    
    if(ARGS_DEBUG)
        message(STATUS "  模式: Debug")
    elseif(ARGS_RELEASE)
        message(STATUS "  模式: Release")
    endif()
    
    if(ARGS_STANDARD)
        message(STATUS "  标准: C++${ARGS_STANDARD}")
    endif()
    
    if(ARGS_DEFINITIONS)
        message(STATUS "  定义: ${ARGS_DEFINITIONS}")
    endif()
endfunction()

# 调用带选项的函数
configure_compiler(my_app DEBUG STANDARD "14" DEFINITIONS "ENABLE_LOGGING" "USE_THREADS")

# 示例5: 实用函数 - 添加子目录并打印信息
function(add_subdirectory_safe dir_name)
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${dir_name})
        message(STATUS "添加子目录: ${dir_name}")
        add_subdirectory(${dir_name})
    else()
        message(WARNING "子目录不存在: ${dir_name}")
    endif()
endfunction()

# 示例6: 函数嵌套调用
function(print_separator)
    message(STATUS "========================================")
endfunction()

function(print_section section_name)
    print_separator()
    message(STATUS "章节: ${section_name}")
    print_separator()
endfunction()

print_section("函数嵌套调用示例")

# 示例7: 操作列表的函数
function(filter_sources output_var pattern)
    set(filtered "")
    foreach(source IN LISTS ARGN)
        if(source MATCHES ${pattern})
            list(APPEND filtered ${source})
        endif()
    endforeach()
    set(${output_var} "${filtered}" PARENT_SCOPE)
endfunction()

set(all_sources main.cpp test_main.cpp helper.cpp test_helper.cpp utils.cpp)
filter_sources(test_sources "test_" ${all_sources})
message(STATUS "测试源文件: ${test_sources}")

# 示例8: 创建可执行文件的便捷函数
function(create_executable exe_name)
    set(options USE_PCH)
    set(oneValueArgs OUTPUT_DIR)
    set(multiValueArgs SOURCES LIBRARIES INCLUDE_DIRS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    message(STATUS "创建可执行文件: ${exe_name}")
    
    if(ARGS_SOURCES)
        add_executable(${exe_name} ${ARGS_SOURCES})
        message(STATUS "  源文件: ${ARGS_SOURCES}")
    endif()
    
    if(ARGS_INCLUDE_DIRS)
        target_include_directories(${exe_name} PRIVATE ${ARGS_INCLUDE_DIRS})
        message(STATUS "  包含目录: ${ARGS_INCLUDE_DIRS}")
    endif()
    
    if(ARGS_LIBRARIES)
        target_link_libraries(${exe_name} ${ARGS_LIBRARIES})
        message(STATUS "  链接库: ${ARGS_LIBRARIES}")
    endif()
    
    if(ARGS_OUTPUT_DIR)
        set_target_properties(${exe_name} PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY ${ARGS_OUTPUT_DIR}
        )
        message(STATUS "  输出目录: ${ARGS_OUTPUT_DIR}")
    endif()
endfunction()

message(STATUS "=== 示例完成 ===")
