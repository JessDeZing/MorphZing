PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/calm_corner/grounding_game_screen.dart"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

edits = [
    (
        "import 'package:get/get.dart';",
        "import 'package:get/get.dart';\nimport 'package:vibration/vibration.dart';",
        "add vibration import"
    ),
    (
        "HapticFeedback.lightImpact();",
        "Vibration.vibrate(duration: 30);",
        "light tap on find"
    ),
    (
        "HapticFeedback.mediumImpact();",
        "Vibration.vibrate(duration: 80);",
        "medium buzz on next sense"
    ),
    (
        "HapticFeedback.heavyImpact();",
        "Vibration.vibrate(duration: 200);",
        "long buzz on finish"
    ),
]

for old_str, new_str, desc in edits:
    if old_str not in content:
        print(f"STOPPED: could not find text for '{desc}'. No changes written.")
        raise SystemExit(1)
    if content.count(old_str) > 1:
        print(f"STOPPED: text for '{desc}' found more than once — ambiguous. No changes written.")
        raise SystemExit(1)
    content = content.replace(old_str, new_str)

after_size = len(content)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: wired up 3 real vibration calls ({before_size} -> {after_size} chars).")
