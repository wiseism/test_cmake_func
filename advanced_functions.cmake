cmake_minimum_required(VERSION 3.10)
project(AdvancedCustomFunctions)

set(CMAKE_CXX_STANDARD 14)

message(STATUS "")
message(STATUS "========================================")
message(STATUS "  CMake 自定义函数高级示例")
message(STATUS "========================================")

# ============================================================================
# 函数1: 平台检测和配置
# ============================================================================
function(configure_platform target_name)
    if(WIN32)
        message(STATUS "配置 Windows 平台: ${target_name}")
        target_compile_definitions(${target_name} PRIVATE PLATFORM_WINDOWS)
    elseif(APPLE)
        message(STATUS "配置 macOS 平台: ${target_name}")
        target_compile_definitions(${target_name} PRIVATE PLATFORM_MACOS)
    elseif(UNIX)
        message(STATUS "配置 Linux 平台: ${target_name}")
        target_compile_definitions(${target_name} PRIVATE PLATFORM_LINUX)
    endif()
endfunction()

# ============================================================================
# 函数2: 设置编译警告级别
# ============================================================================
function(set_warnings target_name level)
    if(level STREQUAL "none")
        message(STATUS "警告级别: 关闭")
    elseif(level STREQUAL "low")
        message(STATUS "警告级别: 低")
        if(MSVC)
            target_compile_options(${target_name} PRIVATE /W1)
        else()
            target_compile_options(${target_name} PRIVATE -Wall)
        endif()
    elseif(level STREQUAL "medium")
        message(STATUS "警告级别: 中")
        if(MSVC)
            target_compile_options(${target_name} PRIVATE /W3)
        else()
            target_compile_options(${target_name} PRIVATE -Wall -Wextra)
        endif()
    elseif(level STREQUAL "high")
        message(STATUS "警告级别: 高")
        if(MSVC)
            target_compile_options(${target_name} PRIVATE /W4)
        else()
            target_compile_options(${target_name} PRIVATE -Wall -Wextra -Wpedantic)
        endif()
    endif()
endfunction()

# ============================================================================
# 函数3: 收集目录下所有源文件
# ============================================================================
function(collect_sources output_var directory)
    file(GLOB_RECURSE sources 
        ${directory}/*.cpp 
        ${directory}/*.cc 
        ${directory}/*.cxx
    )
    set(${output_var} "${sources}" PARENT_SCOPE)
    message(STATUS "从 ${directory} 收集到 ${CMAKE_MATCH_COUNT} 个源文件")
endfunction()

# ============================================================================
# 函数4: 条件编译配置
# ============================================================================
function(enable_feature target_name feature_name enabled)
    if(enabled)
        string(TOUPPER ${feature_name} feature_upper)
        string(REPLACE " " "_" feature_upper ${feature_upper})
        target_compile_definitions(${target_name} PRIVATE ENABLE_${feature_upper})
        message(STATUS "启用功能: ${feature_name}")
    else()
        message(STATUS "禁用功能: ${feature_name}")
    endif()
endfunction()

# ============================================================================
# 函数5: 创建静态库
# ============================================================================
function(create_static_library lib_name)
    set(options EXPORT_SYMBOLS)
    set(oneValueArgs OUTPUT_DIR)
    set(multiValueArgs SOURCES INCLUDE_DIRS PUBLIC_HEADERS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    message(STATUS "创建静态库: ${lib_name}")
    
    if(ARGS_SOURCES)
        add_library(${lib_name} STATIC ${ARGS_SOURCES})
        message(STATUS "  源文件数: ${ARGS_SOURCES}")
    endif()
    
    if(ARGS_INCLUDE_DIRS)
        target_include_directories(${lib_name} PUBLIC ${ARGS_INCLUDE_DIRS})
    endif()
    
    if(ARGS_PUBLIC_HEADERS)
        set_target_properties(${lib_name} PROPERTIES
            PUBLIC_HEADER "${ARGS_PUBLIC_HEADERS}"
        )
    endif()
    
    if(ARGS_EXPORT_SYMBOLS)
        target_compile_definitions(${lib_name} PRIVATE LIB_EXPORTS)
    endif()
endfunction()

# ============================================================================
# 函数6: 创建测试目标
# ============================================================================
function(create_test_target test_name)
    set(options VALGRIND COVERAGE)
    set(oneValueArgs WORKING_DIRECTORY)
    set(multiValueArgs SOURCES LIBRARIES DEFINITIONS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    message(STATUS "创建测试目标: ${test_name}")
    
    if(ARGS_SOURCES)
        add_executable(${test_name} ${ARGS_SOURCES})
    endif()
    
    if(ARGS_LIBRARIES)
        target_link_libraries(${test_name} ${ARGS_LIBRARIES})
    endif()
    
    if(ARGS_DEFINITIONS)
        target_compile_definitions(${test_name} PRIVATE ${ARGS_DEFINITIONS})
    endif()
    
    if(ARGS_VALGRIND)
        message(STATUS "  启用 Valgrind 检测")
    endif()
    
    if(ARGS_COVERAGE)
        message(STATUS "  启用代码覆盖率")
    endif()
    
    add_test(NAME ${test_name} COMMAND ${test_name})
endfunction()

# ============================================================================
# 函数7: 安装配置
# ============================================================================
function(install_target target_name)
    set(options INCLUDE_HEADERS)
    set(oneValueArgs DESTINATION)
    set(multiValueArgs HEADERS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ARGS_DESTINATION)
        set(ARGS_DESTINATION bin)
    endif()
    
    message(STATUS "安装目标: ${target_name} -> ${ARGS_DESTINATION}")
    install(TARGETS ${target_name}
        RUNTIME DESTINATION ${ARGS_DESTINATION}
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )
    
    if(ARGS_INCLUDE_HEADERS AND ARGS_HEADERS)
        install(FILES ${ARGS_HEADERS} DESTINATION include)
        message(STATUS "  安装头文件: ${ARGS_HEADERS}")
    endif()
endfunction()

# ============================================================================
# 函数8: 版本信息设置
# ============================================================================
function(set_version_info target_name major minor patch)
    set_target_properties(${target_name} PROPERTIES
        VERSION ${major}.${minor}.${patch}
        SOVERSION ${major}
    )
    target_compile_definitions(${target_name} PRIVATE
        VERSION_MAJOR=${major}
        VERSION_MINOR=${minor}
        VERSION_PATCH=${patch}
        VERSION_STRING="${major}.${minor}.${patch}"
    )
    message(STATUS "设置版本: ${major}.${minor}.${patch}")
endfunction()

# ============================================================================
# 函数9: 打印配置摘要
# ============================================================================
function(print_config_summary)
    message(STATUS "")
    message(STATUS "========================================")
    message(STATUS "  配置摘要")
    message(STATUS "========================================")
    message(STATUS "项目名称: ${PROJECT_NAME}")
    message(STATUS "CMake 版本: ${CMAKE_VERSION}")
    message(STATUS "构建类型: ${CMAKE_BUILD_TYPE}")
    message(STATUS "C++ 标准: C++${CMAKE_CXX_STANDARD}")
    message(STATUS "编译器: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
    message(STATUS "系统: ${CMAKE_SYSTEM_NAME}")
    message(STATUS "处理器: ${CMAKE_SYSTEM_PROCESSOR}")
    message(STATUS "========================================")
    message(STATUS "")
endfunction()

# ============================================================================
# 函数10: 查找并链接库
# ============================================================================
function(find_and_link_library target_name lib_name)
    set(options REQUIRED)
    set(oneValueArgs COMPONENT)
    set(multiValueArgs TARGETS)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(ARGS_REQUIRED)
        set(find_mode REQUIRED)
    else()
        set(find_mode)
    endif()
    
    if(ARGS_COMPONENT)
        find_package(${lib_name} ${find_mode} COMPONENTS ${ARGS_COMPONENT})
    else()
        find_package(${lib_name} ${find_mode})
    endif()
    
    if(${lib_name}_FOUND)
        message(STATUS "找到库: ${lib_name}")
        if(ARGS_TARGETS)
            foreach(target IN LISTS ARGS_TARGETS)
                target_link_libraries(${target_name} ${target})
                message(STATUS "  链接目标: ${target}")
            endforeach()
        else()
            target_link_libraries(${target_name} ${lib_name})
        endif()
    else()
        message(WARNING "未找到库: ${lib_name}")
    endif()
endfunction()

# ============================================================================
# 演示函数调用
# ============================================================================

message(STATUS "")
message(STATUS "--- 演示函数调用 ---")

# 创建演示可执行文件
add_executable(demo_advanced main.cpp)

# 调用平台配置函数
configure_platform(demo_advanced)

# 调用警告设置函数
set_warnings(demo_advanced "medium")

# 调用功能启用函数
enable_feature(demo_advanced "logging" TRUE)
enable_feature(demo_advanced "debug mode" FALSE)

# 调用版本设置函数
set_version_info(demo_advanced 1 2 3)

# 打印配置摘要
print_config_summary()

message(STATUS "")
message(STATUS "========================================")
message(STATUS "  高级示例完成")
message(STATUS "========================================")
