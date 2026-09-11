import re

EN_PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/en.dart"
ES_PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/es.dart"

def extract_pairs(path):
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
    # matches: translation.someKey: 'some value',  OR  'someKey': 'some value',
    pattern = r"(?:translation\.(\w+)|'(\w+)')\s*:\s*'((?:[^'\\]|\\.)*)'"
    pairs = {}
    for m in re.finditer(pattern, content):
        key = m.group(1) or m.group(2)
        value = m.group(3)
        pairs[key] = value
    return pairs

en_pairs = extract_pairs(EN_PATH)
es_pairs = extract_pairs(ES_PATH)

print(f"EN keys found: {len(en_pairs)}")
print(f"ES keys found: {len(es_pairs)}")
print()

missing_in_es = [k for k in en_pairs if k not in es_pairs]
if missing_in_es:
    print(f"--- {len(missing_in_es)} keys MISSING from es.dart ---")
    for k in missing_in_es:
        print(f"  {k}: '{en_pairs[k]}'")
    print()

identical = [k for k in en_pairs if k in es_pairs and en_pairs[k] == es_pairs[k] and en_pairs[k].strip() != '']
if identical:
    print(f"--- {len(identical)} keys with IDENTICAL EN/ES text (likely untranslated) ---")
    for k in identical:
        print(f"  {k}: '{en_pairs[k]}'")
else:
    print("No identical EN/ES text found — nothing obviously untranslated by this check.")
