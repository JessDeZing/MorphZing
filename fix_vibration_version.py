PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /pubspec.yaml"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

old_str = "  vibration: ^1.9.0\n"
new_str = "  vibration: ^3.2.0\n"

if old_str not in content:
    print("STOPPED: could not find target line. No changes written.")
    raise SystemExit(1)

if content.count(old_str) > 1:
    print("STOPPED: target line found more than once — ambiguous. No changes written.")
    raise SystemExit(1)

content = content.replace(old_str, new_str)
after_size = len(content)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: bumped vibration package to ^3.2.0 ({before_size} -> {after_size} chars).")
