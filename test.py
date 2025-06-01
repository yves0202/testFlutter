# -*- coding: utf-8 -*-
"""
FlutterFlow Translation Extractor

This script extracts translation keys and values from FlutterFlow project files.
It searches through Dart files, JSON files, and ARB files to find translation data.
"""

import os
import json
import re
import csv
from pathlib import Path
from typing import Dict, List, Set, Any
import argparse
import sys

class FlutterFlowTranslationExtractor:
    def __init__(self, project_path: str):
        self.project_path = Path(project_path)
        self.translations = {}
        self.translation_keys = set()
        self.languages = set()
        
    def extract_all_translations(self) -> Dict[str, Any]:
        """Extract translations from all supported file types"""
        print(f"Scanning FlutterFlow project: {self.project_path}")
        
        # Search for different types of translation files
        self.extract_from_arb_files()
        self.extract_from_json_files()
        self.extract_from_dart_files()
        self.extract_from_internationalization_files()
        
        print(f"\nExtraction complete!")
        print(f"   Found {len(self.translation_keys)} unique translation keys")
        print(f"   Found {len(self.languages)} languages: {', '.join(sorted(self.languages))}")
        
        return self.translations
    
    def extract_from_arb_files(self):
        """Extract translations from .arb files (App Resource Bundle)"""
        arb_files = list(self.project_path.rglob("*.arb"))
        
        if arb_files:
            print(f"Found {len(arb_files)} ARB files")
            
        for arb_file in arb_files:
            try:
                with open(arb_file, 'r', encoding='utf-8', errors='ignore') as f:
                    data = json.load(f)
                
                # Extract language code from filename (e.g., app_en.arb -> en)
                lang_code = self.extract_language_from_filename(arb_file.name)
                self.languages.add(lang_code)
                
                # Process ARB format
                for key, value in data.items():
                    if not key.startswith('@') and isinstance(value, str):
                        self.translation_keys.add(key)
                        if key not in self.translations:
                            self.translations[key] = {}
                        self.translations[key][lang_code] = value
                        
                print(f"   Processed {arb_file.name}: {len([k for k in data.keys() if not k.startswith('@')])} keys")
                
            except Exception as e:
                print(f"   Error processing {arb_file}: {e}")
    
    def extract_from_json_files(self):
        """Extract translations from JSON files"""
        # Look for translation-related JSON files
        json_patterns = [
            "**/translations/*.json",
            "**/assets/translations/*.json", 
            "**/lang/*.json",
            "**/languages/*.json",
            "**/i18n/*.json",
            "**/locales/*.json"
        ]
        
        json_files = []
        for pattern in json_patterns:
            json_files.extend(self.project_path.glob(pattern))
        
        # Also check for any JSON file that might contain translations
        all_json_files = list(self.project_path.rglob("*.json"))
        translation_json_files = [f for f in all_json_files if self.is_likely_translation_file(f)]
        
        all_translation_json = list(set(json_files + translation_json_files))
        
        if all_translation_json:
            print(f"Found {len(all_translation_json)} JSON translation files")
        
        for json_file in all_translation_json:
            try:
                with open(json_file, 'r', encoding='utf-8', errors='ignore') as f:
                    data = json.load(f)
                
                lang_code = self.extract_language_from_filename(json_file.name)
                self.languages.add(lang_code)
                
                # Handle nested JSON structures
                flattened = self.flatten_json(data)
                
                for key, value in flattened.items():
                    if isinstance(value, str) and value.strip():
                        self.translation_keys.add(key)
                        if key not in self.translations:
                            self.translations[key] = {}
                        self.translations[key][lang_code] = value
                
                print(f"   Processed {json_file.name}: {len(flattened)} keys")
                
            except Exception as e:
                print(f"   Error processing {json_file}: {e}")
    
    def extract_from_dart_files(self):
        """Extract translation keys and hardcoded strings from Dart files"""
        dart_files = list(self.project_path.rglob("*.dart"))
        
        if dart_files:
            print(f"Scanning {len(dart_files)} Dart files for translation patterns")
        
        # Patterns to look for in Dart files
        patterns = [
            # FlutterFlow translation patterns
            r'FFLocalizations\.of\(context\)\.getText\([\'"]([^\'"]+)[\'"]',
            r'getJsonField\([^,]+,\s*r?[\'"]([^\'"]+)[\'"]',
            
            # General Flutter localization patterns  
            r'AppLocalizations\.of\(context\)!\.([a-zA-Z_][a-zA-Z0-9_]*)',
            r'S\.of\(context\)\.([a-zA-Z_][a-zA-Z0-9_]*)',
            r'context\.l10n\.([a-zA-Z_][a-zA-Z0-9_]*)',
            
            # String literals that might be translatable
            r'Text\([\'"]([^\'"]{3,})[\'"]',
            r'title:\s*[\'"]([^\'"]{3,})[\'"]',
            r'label:\s*[\'"]([^\'"]{3,})[\'"]',
            r'hintText:\s*[\'"]([^\'"]{3,})[\'"]',
        ]
        
        found_keys = set()
        
        for dart_file in dart_files:
            try:
                with open(dart_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                
                for pattern in patterns:
                    matches = re.findall(pattern, content)
                    for match in matches:
                        if isinstance(match, tuple):
                            key = match[0]
                        else:
                            key = match
                        
                        # Filter out likely non-translatable strings
                        if self.is_likely_translatable(key):
                            found_keys.add(key)
                            self.translation_keys.add(key)
                            
                            # Add to translations if not already present
                            if key not in self.translations:
                                self.translations[key] = {}
                            
            except Exception as e:
                print(f"   Error processing {dart_file}: {e}")
        
        if found_keys:
            print(f"   Found {len(found_keys)} potential translation keys in Dart files")
    
    def extract_from_internationalization_files(self):
        """Extract from Flutter internationalization files"""
        intl_files = list(self.project_path.rglob("**/flutter_flow/internationalization.dart"))
        intl_files.extend(self.project_path.rglob("**/lib/l10n/*.dart"))
        
        if intl_files:
            print(f"Found {len(intl_files)} internationalization files")
        
        for intl_file in intl_files:
            try:
                with open(intl_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                
                # Look for translation map patterns
                map_pattern = r'static\s+const\s+Map<String,\s*Map<String,\s*String>>\s+\w+\s*=\s*({.*?});'
                map_matches = re.findall(map_pattern, content, re.DOTALL)
                
                for map_content in map_matches:
                    # Parse the map structure
                    self.parse_dart_translation_map(map_content)
                
                print(f"   Processed {intl_file.name}")
                
            except Exception as e:
                print(f"   Error processing {intl_file}: {e}")
    
    def parse_dart_translation_map(self, map_content: str):
        """Parse Dart translation map structure"""
        # This is a simplified parser for Dart maps
        # Look for patterns like: 'key': {'en': 'English text', 'es': 'Spanish text'}
        entry_pattern = r'[\'"]([^\'"]+)[\'"]\s*:\s*{([^}]+)}'
        entries = re.findall(entry_pattern, map_content)
        
        for key, translations_str in entries:
            self.translation_keys.add(key)
            if key not in self.translations:
                self.translations[key] = {}
            
            # Parse individual language translations
            lang_pattern = r'[\'"]([^\'"]+)[\'"]\s*:\s*[\'"]([^\'"]*)[\'"]'
            lang_matches = re.findall(lang_pattern, translations_str)
            
            for lang, text in lang_matches:
                self.languages.add(lang)
                self.translations[key][lang] = text
    
    def extract_language_from_filename(self, filename: str) -> str:
        """Extract language code from filename"""
        # Common patterns: app_en.arb, translations_es.json, etc.
        patterns = [
            r'_([a-z]{2,3})\.(?:arb|json)$',
            r'([a-z]{2,3})\.(?:arb|json)$', 
            r'app_([a-z]{2,3})',
            r'translations_([a-z]{2,3})',
        ]
        
        for pattern in patterns:
            match = re.search(pattern, filename.lower())
            if match:
                return match.group(1)
        
        # Default fallback
        return filename.split('.')[0].split('_')[-1] if '_' in filename else 'unknown'
    
    def is_likely_translation_file(self, file_path: Path) -> bool:
        """Check if a JSON file is likely to contain translations"""
        translation_indicators = [
            'translation', 'lang', 'locale', 'i18n', 'l10n', 
            'strings', 'messages', 'text', 'labels'
        ]
        
        filename_lower = file_path.name.lower()
        path_lower = str(file_path).lower()
        
        return any(indicator in filename_lower or indicator in path_lower 
                  for indicator in translation_indicators)
    
    def is_likely_translatable(self, text: str) -> bool:
        """Check if a string is likely to be translatable"""
        if len(text) < 2 or len(text) > 200:
            return False
        
        # Skip technical strings
        skip_patterns = [
            r'^[a-z]+[A-Z]',  # camelCase
            r'^\w+\.\w+',     # dot notation
            r'^[A-Z_]+$',     # CONSTANTS
            r'^\d+$',         # numbers only
            r'^[^\w\s]+$',    # symbols only
            r'https?://',     # URLs
            r'@',             # email-like
        ]
        
        for pattern in skip_patterns:
            if re.search(pattern, text):
                return False
        
        # Include strings with letters and reasonable length
        return bool(re.search(r'[a-zA-Z]', text)) and (' ' in text or len(text.split()) > 1)
    
    def flatten_json(self, data: Any, parent_key: str = '', separator: str = '.') -> Dict[str, Any]:
        """Flatten nested JSON structure"""
        items = []
        
        if isinstance(data, dict):
            for k, v in data.items():
                new_key = f"{parent_key}{separator}{k}" if parent_key else k
                items.extend(self.flatten_json(v, new_key, separator).items())
        elif isinstance(data, list):
            for i, v in enumerate(data):
                new_key = f"{parent_key}{separator}{i}" if parent_key else str(i)
                items.extend(self.flatten_json(v, new_key, separator).items())
        else:
            return {parent_key: data}
        
        return dict(items)
    
    def export_to_csv(self, output_path: str):
        """Export translations to CSV file"""
        if not self.translations:
            print("No translations found to export")
            return
        
        # Prepare CSV data
        all_languages = sorted(self.languages)
        headers = ['Translation Key'] + all_languages
        
        with open(output_path, 'w', newline='', encoding='utf-8') as csvfile:
            writer = csv.writer(csvfile)
            writer.writerow(headers)
            
            for key in sorted(self.translation_keys):
                row = [key]
                for lang in all_languages:
                    translation = self.translations.get(key, {}).get(lang, '')
                    row.append(translation)
                writer.writerow(row)
        
        print(f"Exported to: {output_path}")
        print(f"   {len(self.translation_keys)} translation keys")
        print(f"   {len(all_languages)} languages")
    
    def export_to_json(self, output_path: str):
        """Export translations to JSON file"""
        output_data = {
            'metadata': {
                'total_keys': len(self.translation_keys),
                'languages': sorted(self.languages),
                'extracted_from': str(self.project_path)
            },
            'translations': self.translations
        }
        
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(output_data, f, indent=2, ensure_ascii=False)
        
        print(f"Exported to: {output_path}")
    
    def print_summary(self):
        """Print extraction summary"""
        print(f"\nEXTRACTION SUMMARY")
        print(f"=" * 50)
        print(f"Project Path: {self.project_path}")
        print(f"Translation Keys: {len(self.translation_keys)}")
        print(f"Languages Found: {len(self.languages)}")
        print(f"Languages: {', '.join(sorted(self.languages))}")
        
        if self.translations:
            print(f"\nSample translations:")
            for i, (key, translations) in enumerate(list(self.translations.items())[:5]):
                print(f"   {key}:")
                for lang, text in translations.items():
                    text_preview = text[:50] + '...' if len(text) > 50 else text
                    print(f"     {lang}: {text_preview}")
                if i < 4:
                    print()


def main():
    # Simple usage without argparse for easier testing
    project_path = input("Enter FlutterFlow project path (or press Enter for current directory): ").strip()
    if not project_path:
        project_path = "."
    
    if not os.path.exists(project_path):
        print(f"Error: Project path does not exist: {project_path}")
        return
    
    # Extract translations
    print("Starting translation extraction...")
    extractor = FlutterFlowTranslationExtractor(project_path)
    extractor.extract_all_translations()
    
    # Export results
    csv_output = "flutterflow_translations.csv"
    json_output = "flutterflow_translations.json"
    
    extractor.export_to_csv(csv_output)
    extractor.export_to_json(json_output)
    
    # Print summary
    extractor.print_summary()
    
    print(f"\nFiles created:")
    print(f"  - {csv_output}")
    print(f"  - {json_output}")


if __name__ == "__main__":
    main()
