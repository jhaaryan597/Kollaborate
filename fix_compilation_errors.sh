#!/bin/bash

# Script to fix compilation errors by adding missing files to Xcode project

echo "🔧 Fixing compilation errors by adding missing files to Xcode project..."

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
echo "📋 Files that need to be added to fix compilation errors:"
echo "1. Model/Repost.swift"
echo "2. Model/DirectMessage.swift"
echo "3. Services/RepostService.swift"
echo "4. Services/DirectMessageService.swift"
echo "5. Core/Components/ShareSheet.swift"
echo "6. Core/Components/ViewModel/CommentViewModel.swift"
echo ""

# Check if files exist
echo "🔍 Checking if files exist..."

FILES=(
    "Model/Repost.swift"
    "Model/DirectMessage.swift"
    "Services/RepostService.swift"
    "Services/DirectMessageService.swift"
    "Core/Components/ShareSheet.swift"
    "Core/Components/ViewModel/CommentViewModel.swift"
)

for file in "${FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (missing)"
    fi
done

echo ""
echo "🎯 To fix the compilation errors, you need to add these files to Xcode:"
echo ""
echo "1. Open Xcode and open your Kollaborate.xcodeproj file"
echo ""
echo "2. In the Project Navigator (left sidebar), add these files:"
echo ""
echo "   📁 Model folder:"
echo "   - Right-click on 'Model' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose both 'Repost.swift' and 'DirectMessage.swift'"
echo ""
echo "   📁 Services folder:"
echo "   - Right-click on 'Services' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose both 'RepostService.swift' and 'DirectMessageService.swift'"
echo ""
echo "   📁 Core/Components folder:"
echo "   - Right-click on 'Core/Components' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose 'ShareSheet.swift'"
echo ""
echo "   📁 Core/Components/ViewModel folder:"
echo "   - Right-click on 'Core/Components/ViewModel' folder"
echo "   - Select 'Add Files to Kollaborate'"
echo "   - Choose 'CommentViewModel.swift'"
echo ""
echo "3. For each file, make sure 'Add to target' is checked for your main app target"
echo ""
echo "4. After adding all files, build the project (⌘+B)"
echo ""
echo "🎉 The compilation errors should be resolved!"
echo ""
echo "💡 Tip: You can select multiple files at once by holding ⌘ while selecting them"
echo ""
echo "🔗 Also, don't forget to run the corrected_tables.sql in your Supabase database"
echo "   to create the missing database tables for reposts and direct messages."
