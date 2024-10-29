#!/bin/bash

# Precompile the standard library files.
g++-15 -std=c++23 -fmodules-ts -xc++-system-header algorithm
g++-15 -std=c++23 -fmodules-ts -xc++-system-header chrono
g++-15 -std=c++23 -fmodules-ts -xc++-system-header format
g++-15 -std=c++23 -fmodules-ts -xc++-system-header fstream
g++-15 -std=c++23 -fmodules-ts -xc++-system-header functional
g++-15 -std=c++23 -fmodules-ts -xc++-system-header limits
g++-15 -std=c++23 -fmodules-ts -xc++-system-header optional
g++-15 -std=c++23 -fmodules-ts -xc++-system-header print
g++-15 -std=c++23 -fmodules-ts -xc++-system-header set
g++-15 -std=c++23 -fmodules-ts -xc++-system-header stack
g++-15 -std=c++23 -fmodules-ts -xc++-system-header string
g++-15 -std=c++23 -fmodules-ts -xc++-system-header tuple
g++-15 -std=c++23 -fmodules-ts -xc++-system-header vector

# Order is important, dependencies must be built first.

g++-15 -std=c++23 -fmodules-ts -c Logging/Logging.cc -o Logging.o

# Independent modules
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/Validation.cc -o Validation.o
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/Queues.cc -o Queues.o
g++-15 -std=c++23 -fmodules-ts -c Shaders/VertBuffer.cc -o VertBuffer.o

# depends on validation
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/Instance.cc -o Instance.o

# depends on queues
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/SwapChain.cc -o SwapChain.o

# depends on queues and swap chain
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/PhysicalDevice.cc -o PhysicalDevice.o
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/LogicalDevice.cc -o LogicalDevice.o

# depends on devices or swap chain
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/Surface.cc -o Surface.o
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/GraphicsPipeline.cc -o GraphicsPipeline.o
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/RenderPass.cc -o RenderPass.o

#
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/Command.cc -o Command.o

# Depends on literally everything previous
g++-15 -std=c++23 -fmodules-ts -c VulkanLibrary/Presentation.cc -o Presentation.o

# Collates all the artifacts into the final app, and links with the GLFW dependencies
g++-15 -std=c++23 -fmodules-ts -o VulkanApp \
    VertBuffer.o \
    Logging.o \
    Instance.o \
    Validation.o \
    PhysicalDevice.o \
    LogicalDevice.o \
    Queues.o \
    Surface.o \
    SwapChain.o \
    GraphicsPipeline.o \
    RenderPass.o \
    Command.o \
    Presentation.o \
    main.cc \
    -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi

# Optional to remove all object intermediate files if you find them messy
# find . -name "*.o" -type f -delete