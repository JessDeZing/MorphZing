PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/main.dart"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

edits = [
    (
        "import 'package:flutter/material.dart';\n",
        "import 'package:flutter/material.dart';\nimport 'package:flutter_localizations/flutter_localizations.dart';\n",
        "add flutter_localizations import"
    ),
    (
        "locale: localeEnum.getLocale(),",
        "locale: localeEnum.getLocale(),\n            localizationsDelegates: const [\n              GlobalMaterialLocalizations.delegate,\n              GlobalWidgetsLocalizations.delegate,\n              GlobalCupertinoLocalizations.delegate,\n            ],\n            supportedLocales: const [\n              Locale('en'),\n              Locale('es'),\n            ],",
        "add localizationsDelegates and supportedLocales"
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

print(f"SUCCESS: main.dart updated with calendar localization support ({before_size} -> {after_size} chars).")
