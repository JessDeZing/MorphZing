import os
import re

PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/calm_corner/grounding_game_screen.dart"

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

# 1. import
content = regex_replace(
    content,
    esc("import 'package:get/get.dart';"),
    "import 'package:get/get.dart';\nimport 'package:morphzing/localization/translation_keys.dart' as translation;",
    "add translation import"
)

# 2. helper method before _currentStep field
content = regex_replace(
    content,
    r"int\s+_currentStep\s*=\s*0;",
    "String _senseLabel(String key) {\n"
    "    switch (key) {\n"
    "      case 'SEE': return translation.senseSee.tr;\n"
    "      case 'TOUCH': return translation.senseTouch.tr;\n"
    "      case 'HEAR': return translation.senseHear.tr;\n"
    "      case 'SMELL': return translation.senseSmell.tr;\n"
    "      case 'TASTE': return translation.senseTaste.tr;\n"
    "      default: return key;\n"
    "    }\n"
    "  }\n\n"
    "  int _currentStep = 0;",
    "add _senseLabel helper method"
)

# 3. AppBar title
content = regex_replace(
    content,
    esc("'Grounding Exercise',"),
    "translation.groundingExercise.tr,",
    "AppBar title"
)

# 4. step counter
content = regex_replace(
    content,
    esc("'STEP ${_currentStep + 1} OF 5',"),
    "translation.groundingStepOf.tr\n"
    "                  .replaceAll('{step}', '${_currentStep + 1}')\n"
    "                  .replaceAll('{total}', '${_senses.length}'),",
    "step counter"
)

# 5. find prompt sentence
content = regex_replace(
    content,
    esc("'Find $remaining thing${remaining == 1 ? '' : 's'} you can ${sense['label']} ${sense['emoji']}',"),
    "'${translation.groundingFindPrompt.tr.replaceAll('{count}', '$remaining').replaceAll('{plural}', remaining == 1 ? '' : 's')} ${_senseLabel(sense['label'])} ${sense['emoji']}',",
    "find prompt sentence"
)

# 6. instructions
content = regex_replace(
    content,
    esc("'Look around. Tap each time you find one.',"),
    "translation.groundingInstructions.tr,",
    "instructions text"
)

# 7. tap the circle
content = regex_replace(
    content,
    esc("Text('tap the circle', style: TextStyle(fontSize: 12, color: color.withOpacity(0.5))),"),
    "Text(translation.groundingTapCircle.tr, style: TextStyle(fontSize: 12, color: color.withOpacity(0.5))),",
    "tap the circle"
)

# 8. I found one button
content = regex_replace(
    content,
    esc("'I found one  ✓',"),
    "translation.groundingFoundOne.tr,",
    "I found one button"
)

# 9. progress chips row
content = regex_replace(
    content,
    esc("done ? '${_senses[i]['label']} ✓' : '${_senses[i]['label']} ${_senses[i]['count']}',"),
    "done ? '${_senseLabel(_senses[i]['label'])} ✓' : '${_senseLabel(_senses[i]['label'])} ${_senses[i]['count']}',",
    "progress chips row"
)

# 10. You did it! headline (const Text -> Text, since .tr can't be const)
content = regex_replace(
    content,
    r"const\s+Text\('You did it!',\s*\n\s*style:\s*TextStyle\(fontSize:\s*26,\s*fontWeight:\s*FontWeight\.w500,\s*color:\s*Color\(0xFFeceaf8\)\)\),",
    "Text(translation.groundingYouDidIt.tr,\n                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Color(0xFFeceaf8))),",
    "You did it! headline"
)

# 11. completion message
content = regex_replace(
    content,
    r"const\s+Text\(\s*\n\s*'You are present\. You are grounded\. Take a slow breath\.',",
    "Text(\n              translation.groundingCompleteMessage.tr,",
    "completion message"
)

# 12. ALL 5 SENSES COMPLETE
content = regex_replace(
    content,
    r"const\s+Text\('ALL 5 SENSES COMPLETE',",
    "Text(translation.groundingAllSensesComplete.tr,",
    "all senses complete label"
)

# 13. finish screen sense chips
content = regex_replace(
    content,
    esc("child: Text('${s['label']} ✓', style: TextStyle(fontSize: 11, color: color)),"),
    "child: Text('${_senseLabel(s['label'])} ✓', style: TextStyle(fontSize: 11, color: color)),",
    "finish screen sense chips"
)

# 14. Back to Calm Corner button
content = regex_replace(
    content,
    esc("child: const Text('Back to Calm Corner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),"),
    "child: Text(translation.backToCalmCorner.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),",
    "Back to Calm Corner button"
)

# 15. Play again link
content = regex_replace(
    content,
    esc("child: const Text('Play again', style: TextStyle(fontSize: 13, color: Color(0xFF4a4a62))),"),
    "child: Text(translation.playAgain.tr, style: const TextStyle(fontSize: 13, color: Color(0xFF4a4a62))),",
    "Play again link"
)

after_size = len(content)

if after_size <= before_size:
    print(f"STOPPED: file did not grow ({before_size} -> {after_size}). No changes written.")
    raise SystemExit(1)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: grounding_game_screen.dart updated ({before_size} -> {after_size} chars). All 15 edits applied.")
