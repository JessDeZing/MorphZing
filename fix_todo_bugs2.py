# Fix 1 & 2: remove duplicate taskName entries
KEYS_PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/translation_keys.dart"
EN_PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/en.dart"
ES_PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/es.dart"
SCREEN_PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/todo/todo_screen.dart"

results = []

# 1. Remove duplicate key declaration
with open(KEYS_PATH, "r", encoding="utf-8") as f:
    content = f.read()
before = len(content)
old = "const whatDoYouNeedToDo = 'whatDoYouNeedToDo';\nconst taskName = 'taskName';\n"
new = "const whatDoYouNeedToDo = 'whatDoYouNeedToDo';\n"
if content.count(old) != 1:
    results.append(f"STOPPED: translation_keys.dart duplicate pattern not found exactly once.")
else:
    content = content.replace(old, new)
    with open(KEYS_PATH, "w", encoding="utf-8") as f:
        f.write(content)
    results.append(f"SUCCESS: translation_keys.dart duplicate removed ({before} -> {len(content)} chars).")

# 2. Remove duplicate en.dart entry
with open(EN_PATH, "r", encoding="utf-8") as f:
    content = f.read()
before = len(content)
old = "translation.whatDoYouNeedToDo: 'What do you need to do?',\n        translation.taskName: 'Task name',\n"
new = "translation.whatDoYouNeedToDo: 'What do you need to do?',\n"
if content.count(old) != 1:
    results.append(f"STOPPED: en.dart duplicate pattern not found exactly once.")
else:
    content = content.replace(old, new)
    with open(EN_PATH, "w", encoding="utf-8") as f:
        f.write(content)
    results.append(f"SUCCESS: en.dart duplicate removed ({before} -> {len(content)} chars).")

# 3. Remove duplicate es.dart entry
with open(ES_PATH, "r", encoding="utf-8") as f:
    content = f.read()
before = len(content)
old = "translation.whatDoYouNeedToDo: '¿Qué necesitas hacer?',\n        translation.taskName: 'Nombre de la tarea',\n"
new = "translation.whatDoYouNeedToDo: '¿Qué necesitas hacer?',\n"
if content.count(old) != 1:
    results.append(f"STOPPED: es.dart duplicate pattern not found exactly once.")
else:
    content = content.replace(old, new)
    with open(ES_PATH, "w", encoding="utf-8") as f:
        f.write(content)
    results.append(f"SUCCESS: es.dart duplicate removed ({before} -> {len(content)} chars).")

# 4. Fix const InputDecoration on search bar + const Center on empty state
with open(SCREEN_PATH, "r", encoding="utf-8") as f:
    content = f.read()
before = len(content)

edits = [
    (
        "decoration: const InputDecoration(\n                  hintText: translation.searchTasks.tr,",
        "decoration: InputDecoration(\n                  hintText: translation.searchTasks.tr,",
        "search bar const fix"
    ),
    (
        "return const Center(\n        child: Column(\n          mainAxisSize: MainAxisSize.min,\n          children: [\n            Icon(Icons.check_circle_outline, size: 56, color: Colors.white12),\n            SizedBox(height: 12),\n            Text(translation.nothingHere.tr,",
        "return Center(\n        child: Column(\n          mainAxisSize: MainAxisSize.min,\n          children: [\n            const Icon(Icons.check_circle_outline, size: 56, color: Colors.white12),\n            const SizedBox(height: 12),\n            Text(translation.nothingHere.tr,",
        "empty state const fix"
    ),
]

ok = True
for old_str, new_str, desc in edits:
    if old_str not in content:
        results.append(f"STOPPED: could not find text for '{desc}'.")
        ok = False
        continue
    if content.count(old_str) > 1:
        results.append(f"STOPPED: text for '{desc}' found more than once.")
        ok = False
        continue
    content = content.replace(old_str, new_str)

if ok:
    with open(SCREEN_PATH, "w", encoding="utf-8") as f:
        f.write(content)
    results.append(f"SUCCESS: todo_screen.dart const bugs fixed ({before} -> {len(content)} chars).")

for r in results:
    print(r)
