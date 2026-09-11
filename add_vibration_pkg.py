PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /pubspec.yaml"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

old_str = "  win32: ^5.7.0\n"
new_str = "  win32: ^5.7.0\n  vibration: ^1.9.0\n"

if old_str not in content:
    print("STOPPED: could not find target line. No changes written.")
    raise SystemExit(1)

if content.count(old_str) > 1:
    print("STOPPED: target line found more than once — ambiguous. No changes written.")
    raise SystemExit(1)

content = content.replace(old_str, new_str)
after_size = len(content)

if after_size <= before_size:
    print(f"STOPPED: file did not grow ({before_size} -> {after_size}). No changes written.")
    raise SystemExit(1)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: added vibration package to pubspec.yaml ({before_size} -> {after_size} chars).")
