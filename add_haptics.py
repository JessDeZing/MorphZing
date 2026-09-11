PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/calm_corner/grounding_game_screen.dart"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

old_str = "    setState(() {\n      _tapped++;\n      if (_tapped >= needed) {"
new_str = "    setState(() {\n      _tapped++;\n      HapticFeedback.lightImpact();\n      if (_tapped >= needed) {"

if old_str not in content:
    print("STOPPED: could not find the target text for the haptic edit. No changes written.")
    raise SystemExit(1)

if content.count(old_str) > 1:
    print("STOPPED: target text found more than once — ambiguous. No changes written.")
    raise SystemExit(1)

content = content.replace(old_str, new_str)
after_size = len(content)

if after_size <= before_size:
    print(f"STOPPED: file did not grow ({before_size} -> {after_size}). No changes written.")
    raise SystemExit(1)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: added lightImpact haptic on every tap ({before_size} -> {after_size} chars).")
