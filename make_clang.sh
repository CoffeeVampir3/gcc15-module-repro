#!/bin/bash

# Set the Clang compiler and C++ standard
CLANG=clang++
CXXSTANDARD=-std=c++23

# Set module cache path
MODULECACHEPATH="./module_cache"

# Create module cache directory if it doesn't exist
mkdir -p $MODULECACHEPATH

# Common compiler flags
COMMONFLAGS="$CXXSTANDARD -fmodules -fbuiltin-module-map -fimplicit-modules -fmodules-cache-path=$MODULECACHEPATH"

# Precompile the standard library modules
$CLANG $COMMONFLAGS -c <(echo "import std;")

# Compile modules
$CLANG $COMMONFLAGS -c Logging/Logging.cc -o Logging.pcm

# Independent modules
$CLANG $COMMONFLAGS -c VulkanLibrary/Validation.cc -o Validation.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/Queues.cc -o Queues.pcm
$CLANG $COMMONFLAGS -c Shaders/VertBuffer.cc -o VertBuffer.pcm

# Modules with dependencies
$CLANG $COMMONFLAGS -c VulkanLibrary/Instance.cc -o Instance.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/SwapChain.cc -o SwapChain.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/PhysicalDevice.cc -o PhysicalDevice.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/LogicalDevice.cc -o LogicalDevice.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/Surface.cc -o Surface.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/GraphicsPipeline.cc -o GraphicsPipeline.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/RenderPass.cc -o RenderPass.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/Command.cc -o Command.pcm
$CLANG $COMMONFLAGS -c VulkanLibrary/Presentation.cc -o Presentation.pcm

# Compile the main application
$CLANG $COMMONFLAGS -c main.cc -o main.o

# Link everything together
$CLANG $CXXSTANDARD -o VulkanApp \
    *.pcm \
    main.o \
    -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi