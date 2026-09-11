import re

PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/calm_corner/breathing_screen.dart"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

def regex_replace(content, pattern, replacement, desc, flags=re.DOTALL):
    matches = list(re.finditer(pattern, content, flags))
    if len(matches) == 0:
        print(f"STOPPED: could not find text for '{desc}'. No changes written to file.")
        raise SystemExit(1)
    if len(matches) > 1:
        print(f"STOPPED: text for '{desc}' found more than once — ambiguous. No changes written.")
        raise SystemExit(1)
    return re.sub(pattern, replacement, content, count=1, flags=flags)

def esc(s):
    return re.escape(s)

# 1. imports: add translation + vibration
content = regex_replace(
    content,
    esc("import 'package:get/get.dart';"),
    "import 'package:get/get.dart';\n"
    "import 'package:vibration/vibration.dart';\n"
    "import 'package:morphzing/localization/translation_keys.dart' as translation;",
    "add imports"
)

# 2. add _phaseLabel helper right before _phaseIndex field
content = regex_replace(
    content,
    r"int\s+_phaseIndex\s*=\s*0;",
    "String _phaseLabel(String key) {\n"
    "    switch (key) {\n"
    "      case 'Inhale': return translation.phaseInhale.tr;\n"
    "      case 'Hold': return translation.phaseHold.tr;\n"
    "      case 'Exhale': return translation.phaseExhale.tr;\n"
    "      default: return key;\n"
    "    }\n"
    "  }\n\n"
    "  int _phaseIndex = 0;",
    "add _phaseLabel helper method"
)

# 3. vibration on every phase transition (every 4 seconds)
content = regex_replace(
    content,
    esc("setState(() => _phaseIndex = (_phaseIndex + 1) % _phases.length);"),
    "Vibration.vibrate(duration: 50);\n"
    "          setState(() => _phaseIndex = (_phaseIndex + 1) % _phases.length);",
    "phase transition vibration"
)

# 4. AppBar title
content = regex_replace(
    content,
    r"const\s+Text\(\s*\n\s*'Breathing Exercise',",
    "Text(\n            translation.breathingExercise.tr,",
    "AppBar title"
)

# 5. Box Breathing label
content = regex_replace(
    content,
    esc("'Box Breathing',"),
    "translation.boxBreathing.tr,",
    "Box Breathing label"
)

# 6. 4-4-4-4 count
content = regex_replace(
    content,
    r"const\s+Text\(\s*\n\s*'4 - 4 - 4 - 4',",
    "Text(\n                translation.breathingCount.tr,",
    "4-4-4-4 count"
)

# 7. Ready / phase label
content = regex_replace(
    content,
    esc("_running ? phase['label'] as String : 'Ready',"),
    "_running ? _phaseLabel(phase['label'] as String) : translation.breathingReady.tr,",
    "Ready / phase label"
)

# 8. Stop / Start button text
content = regex_replace(
    content,
    esc("_running ? 'Stop' : 'Start',"),
    "_running ? translation.stop.tr : translation.start.tr,",
    "Stop / Start button"
)

# 9. footer text
content = regex_replace(
    content,
    r"const\s+Text\(\s*\n\s*'Inhale • Hold • Exhale • Hold',",
    "Text(\n            translation.breathingFooter.tr,",
    "footer text"
)

after_size = len(content)

if after_size <= before_size:
    print(f"STOPPED: file did not grow ({before_size} -> {after_size}). No changes written.")
    raise SystemExit(1)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: breathing_screen.dart updated ({before_size} -> {after_size} chars). All 9 edits applied.")
