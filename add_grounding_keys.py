import os

BASE = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization"

FILES = {
    "translation_keys.dart": {
        "anchor": "const breathingExerciseSubtitle = 'breathingExerciseSubtitle';\nconst colorAndDiscover = 'colorAndDiscover';",
        "insert": """const breathingExerciseSubtitle = 'breathingExerciseSubtitle';
const groundingInstructions = 'groundingInstructions';
const groundingTapCircle = 'groundingTapCircle';
const groundingFoundOne = 'groundingFoundOne';
const groundingYouDidIt = 'groundingYouDidIt';
const groundingCompleteMessage = 'groundingCompleteMessage';
const groundingAllSensesComplete = 'groundingAllSensesComplete';
const backToCalmCorner = 'backToCalmCorner';
const playAgain = 'playAgain';
const senseSee = 'senseSee';
const senseTouch = 'senseTouch';
const senseHear = 'senseHear';
const senseSmell = 'senseSmell';
const senseTaste = 'senseTaste';
const groundingStepOf = 'groundingStepOf';
const groundingFindPrompt = 'groundingFindPrompt';
const colorAndDiscover = 'colorAndDiscover';"""
    },
    "en.dart": {
        "anchor": "translation.breathingExerciseSubtitle: 'Box breathing • 4-4-4-4',\n        translation.colorAndDiscover: 'Color & Discover',",
        "insert": """translation.breathingExerciseSubtitle: 'Box breathing • 4-4-4-4',
        translation.groundingInstructions: 'Look around. Tap each time you find one.',
        translation.groundingTapCircle: 'tap the circle',
        translation.groundingFoundOne: 'I found one  ✓',
        translation.groundingYouDidIt: 'You did it!',
        translation.groundingCompleteMessage: 'You are present. You are grounded. Take a slow breath.',
        translation.groundingAllSensesComplete: 'ALL 5 SENSES COMPLETE',
        translation.backToCalmCorner: 'Back to Calm Corner',
        translation.playAgain: 'Play again',
        translation.senseSee: 'SEE',
        translation.senseTouch: 'TOUCH',
        translation.senseHear: 'HEAR',
        translation.senseSmell: 'SMELL',
        translation.senseTaste: 'TASTE',
        translation.groundingStepOf: 'STEP {step} OF {total}',
        translation.groundingFindPrompt: 'Find {count} thing{plural} you can',
        translation.colorAndDiscover: 'Color & Discover',"""
    },
    "es.dart": {
        "anchor": "translation.breathingExerciseSubtitle: 'Respiración cuadrada • 4-4-4-4',\n        translation.colorAndDiscover: 'Colorear y Descubrir',",
        "insert": """translation.breathingExerciseSubtitle: 'Respiración cuadrada • 4-4-4-4',
        translation.groundingInstructions: 'Mira a tu alrededor. Toca cada vez que encuentres uno.',
        translation.groundingTapCircle: 'toca el círculo',
        translation.groundingFoundOne: 'Encontré uno  ✓',
        translation.groundingYouDidIt: '¡Lo lograste!',
        translation.groundingCompleteMessage: 'Estás presente. Estás enraizado/a. Respira lento.',
        translation.groundingAllSensesComplete: 'LOS 5 SENTIDOS COMPLETADOS',
        translation.backToCalmCorner: 'Volver al Rincón de Calma',
        translation.playAgain: 'Jugar de nuevo',
        translation.senseSee: 'VER',
        translation.senseTouch: 'TOCAR',
        translation.senseHear: 'OÍR',
        translation.senseSmell: 'OLER',
        translation.senseTaste: 'PROBAR',
        translation.groundingStepOf: 'PASO {step} DE {total}',
        translation.groundingFindPrompt: 'Encuentra {count} cosa{plural} que puedas',
        translation.colorAndDiscover: 'Colorear y Descubrir',"""
    },
}

for fname, cfg in FILES.items():
    path = os.path.join(BASE, fname)
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    before_size = len(content)

    if cfg["anchor"] not in content:
        print(f"STOPPED: anchor text not found in {fname}. No changes made.")
        continue

    if content.count(cfg["anchor"]) > 1:
        print(f"STOPPED: anchor text found more than once in {fname}. Ambiguous — no changes made.")
        continue

    new_content = content.replace(cfg["anchor"], cfg["insert"])
    after_size = len(new_content)

    if after_size <= before_size:
        print(f"STOPPED: {fname} did not grow ({before_size} -> {after_size}). No changes made.")
        continue

    with open(path, "w", encoding="utf-8") as f:
        f.write(new_content)

    print(f"SUCCESS: {fname} updated ({before_size} -> {after_size} chars).")
