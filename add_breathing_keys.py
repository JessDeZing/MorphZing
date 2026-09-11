FILES = {
    "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/translation_keys.dart": {
        "anchor": "const breathingExerciseSubtitle = 'breathingExerciseSubtitle';\nconst groundingInstructions = 'groundingInstructions';",
        "insert": """const breathingExerciseSubtitle = 'breathingExerciseSubtitle';
const boxBreathing = 'boxBreathing';
const breathingCount = 'breathingCount';
const breathingReady = 'breathingReady';
const stop = 'stop';
const start = 'start';
const breathingFooter = 'breathingFooter';
const phaseInhale = 'phaseInhale';
const phaseHold = 'phaseHold';
const phaseExhale = 'phaseExhale';
const groundingInstructions = 'groundingInstructions';"""
    },
    "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/en.dart": {
        "anchor": "translation.breathingExerciseSubtitle: 'Box breathing • 4-4-4-4',\n        translation.groundingInstructions: 'Look around. Tap each time you find one.',",
        "insert": """translation.breathingExerciseSubtitle: 'Box breathing • 4-4-4-4',
        translation.boxBreathing: 'Box Breathing',
        translation.breathingCount: '4 - 4 - 4 - 4',
        translation.breathingReady: 'Ready',
        translation.stop: 'Stop',
        translation.start: 'Start',
        translation.breathingFooter: 'Inhale • Hold • Exhale • Hold',
        translation.phaseInhale: 'Inhale',
        translation.phaseHold: 'Hold',
        translation.phaseExhale: 'Exhale',
        translation.groundingInstructions: 'Look around. Tap each time you find one.',"""
    },
    "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/es.dart": {
        "anchor": "translation.breathingExerciseSubtitle: 'Respiración cuadrada • 4-4-4-4',\n        translation.groundingInstructions: 'Mira a tu alrededor. Toca cada vez que encuentres uno.',",
        "insert": """translation.breathingExerciseSubtitle: 'Respiración cuadrada • 4-4-4-4',
        translation.boxBreathing: 'Respiración Cuadrada',
        translation.breathingCount: '4 - 4 - 4 - 4',
        translation.breathingReady: 'Listo',
        translation.stop: 'Detener',
        translation.start: 'Comenzar',
        translation.breathingFooter: 'Inhala • Mantén • Exhala • Mantén',
        translation.phaseInhale: 'Inhala',
        translation.phaseHold: 'Mantén',
        translation.phaseExhale: 'Exhala',
        translation.groundingInstructions: 'Mira a tu alrededor. Toca cada vez que encuentres uno.',"""
    },
}

for path, cfg in FILES.items():
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    before_size = len(content)

    if cfg["anchor"] not in content:
        print(f"STOPPED: anchor text not found in {path}. No changes made.")
        continue

    if content.count(cfg["anchor"]) > 1:
        print(f"STOPPED: anchor text found more than once in {path}. Ambiguous — no changes made.")
        continue

    new_content = content.replace(cfg["anchor"], cfg["insert"])
    after_size = len(new_content)

    if after_size <= before_size:
        print(f"STOPPED: {path} did not grow ({before_size} -> {after_size}). No changes made.")
        continue

    with open(path, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"SUCCESS: {path.split('/')[-1]} updated ({before_size} -> {after_size} chars).")
