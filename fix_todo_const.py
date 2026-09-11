PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/todo/todo_screen.dart"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

old_str = "decoration: const InputDecoration(\n                        border: InputBorder.none,\n                        hintText: translation.taskName.tr,"
new_str = "decoration: InputDecoration(\n                        border: InputBorder.none,\n                        hintText: translation.taskName.tr,"

if old_str not in content:
    print("STOPPED: could not find target text. No changes written.")
    raise SystemExit(1)

if content.count(old_str) > 1:
    print("STOPPED: target text found more than once — ambiguous. No changes written.")
    raise SystemExit(1)

content = content.replace(old_str, new_str)
after_size = len(content)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: fixed const bug on taskName InputDecoration ({before_size} -> {after_size} chars).")
