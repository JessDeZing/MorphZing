PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/calm_corner/grounding_game_screen.dart"

with open(PATH, "r", encoding="utf-8") as f:
    lines = f.readlines()

before_size = sum(len(l) for l in lines)

fixed_count = 0
for i, line in enumerate(lines):
    if "const Text(" in line and "groundingExercise" not in line and "groundingInstructions" not in line:
        # Only fix lines 73 and 116 (index 72 and 115), check next line has our target keys
        if i + 1 < len(lines):
            next_line = lines[i + 1]
            if "translation.groundingExercise.tr" in next_line or "translation.groundingInstructions.tr" in next_line:
                lines[i] = line.replace("const Text(", "Text(")
                fixed_count += 1

if fixed_count != 2:
    print(f"STOPPED: expected to fix 2 lines, but fixed {fixed_count}. No changes written.")
    raise SystemExit(1)

after_size = sum(len(l) for l in lines)

with open(PATH, "w", encoding="utf-8") as f:
    f.writelines(lines)

print(f"SUCCESS: fixed {fixed_count} const bugs ({before_size} -> {after_size} chars).")
