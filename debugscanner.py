# -*- coding: utf-8 -*-
"""
FlutterFlow Project Debug Scanner
This script will help us understand how FlutterFlow stores translations in your project
"""

import os
import json
import re
from pathlib import Path

def debug_flutterflow_project(project_path):
    """Debug FlutterFlow project to understand translation storage"""
    project = Path(project_path)
    print(f"Debugging FlutterFlow project: {project}")
    print("=" * 60)
    
    # 1. Show project structure
    print("\n1. PROJECT STRUCTURE:")
    show_project_structure(project)
    
    # 2. Find all files that might contain translations
    print("\n2. POTENTIAL TRANSLATION FILES:")
    find_potential_translation_files(project)
    
    # 3. Search for translation patterns in all files
    print("\n3. SEARCHING FOR TRANSLATION PATTERNS:")
    search_translation_patterns(project)
    
    # 4. Look for specific FlutterFlow files
    print("\n4. FLUTTERFLOW SPECIFIC FILES:")
    find_flutterflow_files(project)
    
    # 5. Search for any mention of languages or translations
    print("\n5. FILES MENTIONING 'LANGUAGE' OR 'TRANSLATION':")
    search_for_language_mentions(project)

def show_project_structure(project_path, max_depth=2):
    """Show the basic project structure"""
    def show_tree(path, prefix="", depth=0):
        if depth > max_depth:
            return
        
        items = []
        try:
            items = list(path.iterdir())
        except PermissionError:
            return
            
        # Sort: directories first, then files
        dirs = [item for item in items if item.is_dir()]
        files = [item for item in items if item.is_file()]
        
        for item in sorted(dirs) + sorted(files):
            if item.name.startswith('.'):
                continue
                
            is_last = item == (sorted(dirs) + sorted(files))[-1]
            current_prefix = "└── " if is_last else "├── "
            print(f"{prefix}{current_prefix}{item.name}")
            
            if item.is_dir() and depth < max_depth:
                next_prefix = prefix + ("    " if is_last else "│   ")
                show_tree(item, next_prefix, depth + 1)
    
    show_tree(project_path)

def find_potential_translation_files(project_path):
    """Find files that might contain translations"""
    # File patterns to look for
    patterns = {
        "ARB files": "*.arb",
        "JSON files": "*.json", 
        "Dart files": "*.dart",
        "YAML files": "*.yaml",
        "Properties files": "*.properties"
    }
    
    for file_type, pattern in patterns.items():
        files = list(project_path.rglob(pattern))
        if files:
            print(f"\n{file_type} ({len(files)} found):")
            for file in files[:10]:  # Show first 10
                relative_path = file.relative_to(project_path)
                file_size = file.stat().st_size if file.exists() else 0
                print(f"  - {relative_path} ({file_size} bytes)")
            if len(files) > 10:
                print(f"  ... and {len(files) - 10} more")

def search_translation_patterns(project_path):
    """Search for translation patterns in files"""
    # Common translation patterns
    patterns = [
        (r'FFLocalizations\.of\(context\)\.getText\([\'"]([^\'"]+)[\'"]', "FFLocalizations.getText"),
        (r'AppLocalizations\.of\(context\)\.([a-zA-Z_][a-zA-Z0-9_]*)', "AppLocalizations"),
        (r'S\.of\(context\)\.([a-zA-Z_][a-zA-Z0-9_]*)', "S.of(context)"),
        (r'[\'"]([a-zA-Z_][a-zA-Z0-9_]*)[\'"]:\s*[\'"]([^\'"]+)[\'"]', "Key-value pairs"),
        (r'getText\([\'"]([^\'"]+)[\'"]', "getText calls"),
        (r'translate\([\'"]([^\'"]+)[\'"]', "translate calls"),
    ]
    
    found_patterns = {}
    
    # Search in dart files
    dart_files = list(project_path.rglob("*.dart"))
    print(f"Searching {len(dart_files)} Dart files...")
    
    for dart_file in dart_files:
        try:
            with open(dart_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            for pattern, pattern_name in patterns:
                matches = re.findall(pattern, content)
                if matches:
                    if pattern_name not in found_patterns:
                        found_patterns[pattern_name] = []
                    
                    relative_path = dart_file.relative_to(project_path)
                    found_patterns[pattern_name].append((relative_path, matches[:5]))  # First 5 matches
        
        except Exception as e:
            continue
    
    # Display findings
    if found_patterns:
        for pattern_name, findings in found_patterns.items():
            print(f"\n{pattern_name}:")
            for file_path, matches in findings[:3]:  # Show first 3 files
                print(f"  File: {file_path}")
                for match in matches:
                    if isinstance(match, tuple):
                        print(f"    - {match[0]} -> {match[1]}")
                    else:
                        print(f"    - {match}")
    else:
        print("No translation patterns found in Dart files")

def find_flutterflow_files(project_path):
    """Look for FlutterFlow-specific files"""
    flutterflow_patterns = [
        "**/flutter_flow/**/*.dart",
        "**/lib/flutter_flow/**/*",
        "**/flutter_flow/internationalization.dart",
        "**/custom_code/**/*.dart",
        "**/.flutter_flow_schema.json",
        "**/project_config.json"
    ]
    
    for pattern in flutterflow_patterns:
        files = list(project_path.glob(pattern))
        if files:
            print(f"\nPattern: {pattern}")
            for file in files:
                relative_path = file.relative_to(project_path)
                print(f"  - {relative_path}")
                
                # If it's a dart file, show a snippet
                if file.suffix == '.dart':
                    try:
                        with open(file, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                            
                        # Look for translation-related content
                        lines = content.split('\n')
                        for i, line in enumerate(lines[:50]):  # First 50 lines
                            if any(keyword in line.lower() for keyword in ['translation', 'localization', 'gettext', 'language']):
                                print(f"    Line {i+1}: {line.strip()}")
                    except:
                        pass

def search_for_language_mentions(project_path):
    """Search for files that mention language or translation"""
    keywords = ['language', 'translation', 'locale', 'i18n', 'l10n', 'getText', 'localization']
    
    # Search in all text files
    file_patterns = ['*.dart', '*.json', '*.yaml', '*.md', '*.txt']
    
    found_files = {}
    
    for pattern in file_patterns:
        for file in project_path.rglob(pattern):
            try:
                with open(file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read().lower()
                
                for keyword in keywords:
                    if keyword in content:
                        if file not in found_files:
                            found_files[file] = []
                        found_files[file].append(keyword)
                        
            except Exception:
                continue
    
    if found_files:
        for file, keywords_found in list(found_files.items())[:10]:  # Show first 10
            relative_path = file.relative_to(project_path)
            print(f"\n{relative_path}")
            print(f"  Keywords: {', '.join(set(keywords_found))}")
            
            # Show relevant lines
            try:
                with open(file, 'r', encoding='utf-8', errors='ignore') as f:
                    lines = f.readlines()
                
                relevant_lines = []
                for i, line in enumerate(lines):
                    if any(keyword in line.lower() for keyword in keywords_found):
                        relevant_lines.append(f"    Line {i+1}: {line.strip()}")
                        if len(relevant_lines) >= 3:  # Show max 3 lines per file
                            break
                
                for line in relevant_lines:
                    print(line)
                    
            except:
                pass
    else:
        print("No files found mentioning translation keywords")

def main():
    # Get project path
    project_path = input("Enter your FlutterFlow project path (or press Enter for current directory): ").strip()
    if not project_path:
        project_path = "."
    
    project_path = os.path.abspath(project_path)
    
    if not os.path.exists(project_path):
        print(f"Error: Path does not exist: {project_path}")
        return
    
    debug_flutterflow_project(project_path)
    
    print(f"\n" + "=" * 60)
    print("Debug scan complete!")
    print("Please share the output above so we can understand how your")
    print("FlutterFlow project stores translations and create a proper extractor.")

if __name__ == "__main__":
    main()
