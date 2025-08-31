#!/bin/bash

# Script to add Task Management files to Xcode project
# This script will help you add all the new files to your Xcode project

echo "🚀 Adding Task Management files to Xcode project..."

# Get the current directory
PROJECT_DIR="$(pwd)"
PROJECT_NAME="Kollaborate"

echo "📁 Project directory: $PROJECT_DIR"
echo "📱 Project name: $PROJECT_NAME"

# Check if we're in the right directory
if [ ! -f "$PROJECT_DIR/Kollaborate.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: Kollaborate.xcodeproj not found in current directory"
    echo "Please run this script from the Kollaborate project root directory"
    exit 1
fi

echo "✅ Found Xcode project"

# List all the files that need to be added
echo ""
echo "📋 Files to be added to Xcode project:"
echo "1. Model/Task.swift"
echo "2. Services/TaskService.swift"
echo "3. Core/Feed/View/TaskManagementView.swift"
echo "4. Core/Feed/ViewModel/TaskManagementViewModel.swift"
echo "5. Core/Components/TaskRowView.swift"
echo "6. Core/Components/TaskDetailView.swift"
echo "7. Core/ThreadCreation/View/AddTaskView.swift"
echo ""

# Check if files exist
echo "🔍 Checking if files exist..."

FILES=(
    "Model/Task.swift"
    "Services/TaskService.swift"
    "Core/Feed/View/TaskManagementView.swift"
    "Core/Feed/ViewModel/TaskManagementViewModel.swift"
    "Core/Components/TaskRowView.swift"
    "Core/Components/TaskDetailView.swift"
    "Core/ThreadCreation/View/AddTaskView.swift"
)

for file in "${FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (missing)"
    fi
done

echo ""
echo "🎯 Next steps:"
echo ""
echo "1. Open Xcode and open your Kollaborate.xcodeproj file"
echo ""
echo "2. In the Project Navigator (left sidebar), you'll need to add these files:"
echo ""
echo "   📁 Model folder:"
echo "   - Right-click on 'Model' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose 'Model/Task.swift'"
echo ""
echo "   📁 Services folder:"
echo "   - Right-click on 'Services' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose 'Services/TaskService.swift'"
echo ""
echo "   📁 Core/Feed/View folder:"
echo "   - Right-click on 'Core/Feed/View' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose 'Core/Feed/View/TaskManagementView.swift'"
echo ""
echo "   📁 Core/Feed/ViewModel folder:"
echo "   - Right-click on 'Core/Feed/ViewModel' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose 'Core/Feed/ViewModel/TaskManagementViewModel.swift'"
echo ""
echo "   📁 Core/Components folder:"
echo "   - Right-click on 'Core/Components' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose both 'TaskRowView.swift' and 'TaskDetailView.swift'"
echo ""
echo "   📁 Core/ThreadCreation/View folder:"
echo "   - Right-click on 'Core/ThreadCreation/View' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose 'AddTaskView.swift'"
echo ""
echo "3. For each file, make sure 'Add to target' is checked for your main app target"
echo ""
echo "4. After adding all files, build the project (⌘+B)"
echo ""
echo "🎉 The Task Management feature will then be ready to use!"
echo ""
echo "💡 Tip: You can also select multiple files at once by holding ⌘ while selecting them"
