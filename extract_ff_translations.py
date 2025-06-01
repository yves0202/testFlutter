# -*- coding: utf-8 -*-
"""
FlutterFlow Targeted Translation Extractor
Extracts translations from FlutterFlow internationalization.dart file
"""

import os
import json
import re
import csv
from pathlib import Path

def extract_flutterflow_translations(project_path):
    """Extract translations from FlutterFlow internationalization.dart"""
    project = Path(project_path)
    internationalization_file = project / "lib" / "flutter_flow" / "internationalization.dart"
    
    if not internationalization_file.exists():
        print(f"ERROR: Internationalization file not found: {internationalization_file}")
        return None
    
    print(f"SUCCESS: Found internationalization file: {internationalization_file}")
    
    try:
        with open(internationalization_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # Extract languages from the languages() method
        languages = extract_languages(content)
        print(f"Languages found: {languages}")
        
        # Extract the kTranslationsMap
        translations_map = extract_translations_map(content)
        print(f"Translation keys found: {len(translations_map)}")
        
        # Create structured output
        result = {
            'languages': languages,
            'translations': translations_map,
            'source_file': str(internationalization_file)
        }
        
        return result
        
    except Exception as e:
        print(f"ERROR: Error reading internationalization file: {e}")
        return None

def extract_languages(content):
    """Extract supported languages from the content"""
    # Look for: static List<String> languages() => ['en', 'sg', 'fr'];
    lang_pattern = r"static List<String> languages\(\) => \[(.*?)\];"
    match = re.search(lang_pattern, content)
    
    if match:
        lang_string = match.group(1)
        # Extract individual language codes
        lang_codes = re.findall(r"'([^']+)'", lang_string)
        return lang_codes
    
    return []

def extract_translations_map(content):
    """Extract the kTranslationsMap from the content"""
    translations = {}
    
    # Look for the kTranslationsMap definition - it's a list that gets reduced
    # Pattern: final kTranslationsMap = <Map<String, Map<String, String>>>[
    map_pattern = r"final kTranslationsMap = <Map<String, Map<String, String>>>\[(.*?)\]\.reduce\("
    match = re.search(map_pattern, content, re.DOTALL)
    
    if not match:
        print("ERROR: Could not find kTranslationsMap list in the file")
        return translations
    
    list_content = match.group(1)
    
    # Extract individual map sections (each section is a separate map in the list)
    # Look for sections starting with // comments and containing translation maps
    sections = re.split(r'\s*//\s*[A-Za-z]+\s*\n', list_content)
    
    for section in sections:
        if not section.strip():
            continue
            
        # Extract individual translation entries from each section
        # Pattern: 'key': { 'en': 'text', 'fr': 'texte', 'sg': '' },
        entry_pattern = r"'([^']+)':\s*\{([^}]+)\}"
        entries = re.findall(entry_pattern, section)
        
        for key, translation_block in entries:
            if key in translations:
                print(f"WARNING: Duplicate key found: {key}")
            
            translations[key] = {}
            
            # Extract language-specific translations
            # Pattern: 'en': 'text', 'fr': 'texte'
            lang_pattern = r"'([^']+)':\s*'([^']*)'"
            lang_translations = re.findall(lang_pattern, translation_block)
            
            for lang_code, text in lang_translations:
                translations[key][lang_code] = text
    
    return translations

def display_translations(data):
    """Display translations in a readable format"""
    if not data or not data['translations']:
        print("ERROR: No translations to display")
        return
    
    languages = data['languages']
    translations = data['translations']
    
    print(f"\nTRANSLATION SUMMARY")
    print(f"=" * 80)
    print(f"Languages: {', '.join(languages)}")
    print(f"Translation keys: {len(translations)}")
    
    print(f"\nTRANSLATIONS:")
    print(f"-" * 80)
    
    # Header
    header = f"{'Key':<15}"
    for lang in languages:
        header += f" | {lang.upper():<25}"
    print(header)
    print("-" * len(header))
    
    # Translation rows
    for key, lang_dict in translations.items():
        row = f"{key:<15}"
        for lang in languages:
            text = lang_dict.get(lang, '')
            # Truncate long text
            display_text = text[:23] + '..' if len(text) > 25 else text
            row += f" | {display_text:<25}"
        print(row)

def export_to_csv(data, output_file):
    """Export translations to CSV file"""
    if not data or not data['translations']:
        print("ERROR: No translations to export")
        return
    
    languages = data['languages']
    translations = data['translations']
    
    with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        
        # Write header
        header = ['Translation Key'] + [lang.upper() for lang in languages]
        writer.writerow(header)
        
        # Write translation rows
        for key, lang_dict in translations.items():
            row = [key]
            for lang in languages:
                row.append(lang_dict.get(lang, ''))
            writer.writerow(row)
    
    print(f"SUCCESS: Exported to CSV: {output_file}")

def export_to_json(data, output_file):
    """Export translations to JSON file"""
    if not data:
        print("ERROR: No data to export")
        return
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"SUCCESS: Exported to JSON: {output_file}")

def create_sango_template(data, output_file):
    """Create a CSV template for adding Sango translations"""
    if not data or not data['translations']:
        print("ERROR: No translations to create template from")
        return
    
    languages = data['languages']
    translations = data['translations']
    
    with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        
        # Write header with Sango column highlighted
        header = ['Translation Key'] + [lang.upper() for lang in languages] + ['SANGO_NEW']
        writer.writerow(header)
        
        # Write translation rows with empty Sango column for new translations
        for key, lang_dict in translations.items():
            row = [key]
            for lang in languages:
                row.append(lang_dict.get(lang, ''))
            row.append('')  # Empty Sango column for manual input
            writer.writerow(row)
    
    print(f"SUCCESS: Created Sango template: {output_file}")
    print(f"   NOTE: Fill in the SANGO_NEW column with your translations")

def analyze_sango_coverage(data):
    """Analyze how much Sango translation coverage exists"""
    if not data or not data['translations']:
        return
    
    translations = data['translations']
    languages = data['languages']
    
    if 'sg' not in languages:
        print("ERROR: Sango (sg) not found in languages list")
        return
    
    total_keys = len(translations)
    sango_translated = 0
    missing_sango = []
    existing_sango = []
    
    for key, lang_dict in translations.items():
        sango_text = lang_dict.get('sg', '')
        if sango_text.strip():
            sango_translated += 1
            existing_sango.append((key, sango_text))
        else:
            missing_sango.append(key)
    
    coverage_percent = (sango_translated / total_keys) * 100 if total_keys > 0 else 0
    
    print(f"\nSANGO TRANSLATION ANALYSIS")
    print(f"=" * 50)
    print(f"Total translation keys: {total_keys}")
    print(f"Sango translations: {sango_translated}")
    print(f"Missing Sango: {len(missing_sango)}")
    print(f"Coverage: {coverage_percent:.1f}%")
    
    if existing_sango:
        print(f"\nExisting Sango translations:")
        for key, text in existing_sango[:5]:  # Show first 5
            en_text = translations[key].get('en', '')
            print(f"   - {key}: '{text}' (EN: '{en_text}')")
        if len(existing_sango) > 5:
            print(f"   ... and {len(existing_sango) - 5} more")
    
    if missing_sango:
        print(f"\nKeys missing Sango translation (showing first 10):")
        for key in missing_sango[:10]:
            en_text = translations[key].get('en', '')
            fr_text = translations[key].get('fr', '')
            print(f"   - {key}")
            print(f"     EN: '{en_text}'")
            if fr_text:
                print(f"     FR: '{fr_text}'")
            print()
        if len(missing_sango) > 10:
            print(f"   ... and {len(missing_sango) - 10} more missing")

def group_translations_by_page(data):
    """Group translations by page/section for easier management"""
    if not data or not data['translations']:
        return
    
    # Try to group by examining the original file structure
    # Since we can see comments like // HomePage, // Detalle, etc.
    print(f"\nTRANSLATIONS BY CATEGORY")
    print(f"=" * 50)
    
    # This is a simplified grouping - in a real scenario, we'd parse the comments
    # For now, just show some stats
    translations = data['translations']
    
    # Count non-empty translations per language
    lang_stats = {}
    for lang in data['languages']:
        non_empty = sum(1 for trans in translations.values() if trans.get(lang, '').strip())
        lang_stats[lang] = non_empty
    
    for lang, count in lang_stats.items():
        percent = (count / len(translations)) * 100 if translations else 0
        print(f"{lang.upper()}: {count}/{len(translations)} ({percent:.1f}%)")

def main():
    # Get project path
    project_path = input("Enter your FlutterFlow project path (or press Enter for current directory): ").strip()
    if not project_path:
        project_path = "."
    
    project_path = os.path.abspath(project_path)
    
    if not os.path.exists(project_path):
        print(f"ERROR: Path does not exist: {project_path}")
        return
    
    print(f"Extracting translations from: {project_path}")
    
    # Extract translations
    data = extract_flutterflow_translations(project_path)
    
    if not data:
        print("ERROR: Failed to extract translations")
        return
    
    # Display results
    display_translations(data)
    
    # Analyze Sango coverage
    analyze_sango_coverage(data)
    
    # Show language statistics
    group_translations_by_page(data)
    
    # Export files
    csv_file = "flutterflow_translations_extracted.csv"
    json_file = "flutterflow_translations_extracted.json"
    sango_template = "sango_translation_template.csv"
    
    export_to_csv(data, csv_file)
    export_to_json(data, json_file)
    create_sango_template(data, sango_template)
    
    print(f"\nFILES CREATED:")
    print(f"   - {csv_file} - All current translations")
    print(f"   - {json_file} - JSON format for backup")
    print(f"   - {sango_template} - Template for adding Sango translations")
    
    print(f"\nNEXT STEPS:")
    print(f"   1. Open {sango_template} in Excel/Google Sheets")
    print(f"   2. Fill in the SANGO_NEW column with your Sango translations")
    print(f"   3. Save your completed translations as a reference")
    print(f"   4. When cloning projects, use this file to quickly add Sango translations")

if __name__ == "__main__":
    main()
