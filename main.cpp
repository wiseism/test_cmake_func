#include <iostream>

int main() {
    std::cout << "CMake 自定义函数示例程序" << std::endl;
    std::cout << "版本: " << VERSION_MAJOR << "." << VERSION_MINOR << "." << VERSION_PATCH << std::endl;
    
#ifdef ENABLE_LOGGING
    std::cout << "日志功能已启用" << std::endl;
#endif

#ifdef PLATFORM_WINDOWS
    std::cout << "平台: Windows" << std::endl;
#elif defined(PLATFORM_MACOS)
    std::cout << "平台: macOS" << std::endl;
#elif defined(PLATFORM_LINUX)
    std::cout << "平台: Linux" << std::endl;
#endif

    return 0;
}
