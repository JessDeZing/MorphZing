FILES = {
    "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/translation_keys.dart": {
        "anchor": "const journalReminder5 = 'journalReminder5';",
        "insert": """const journalReminder5 = 'journalReminder5';
const exportFailed = 'exportFailed';
const importFailed = 'importFailed';
const todoRestoredSuccess = 'todoRestoredSuccess';
const myToDo = 'myToDo';
const nothingHere = 'nothingHere';
const setTime = 'setTime';
const amLabel = 'amLabel';
const pmLabel = 'pmLabel';
const tapNumbersHint = 'tapNumbersHint';
const ok = 'ok';
const newTask = 'newTask';
const colorOptional = 'colorOptional';
const saveTask = 'saveTask';
const deleteTaskConfirm = 'deleteTaskConfirm';
const cannotBeUndone = 'cannotBeUndone';
const colorLabel = 'colorLabel';
const addDateTimeOptional = 'addDateTimeOptional';
const addDateTime = 'addDateTime';
const completed = 'completed';
const markAsComplete = 'markAsComplete';
const searchTasks = 'searchTasks';
const activeTab = 'activeTab';
const whatDoYouNeedToDo = 'whatDoYouNeedToDo';
const taskName = 'taskName';"""
    },
    "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/en.dart": {
        "anchor": "translation.journalReminder5: 'Haven\\'t checked in today. Your journal missed you.',",
        "insert": """translation.journalReminder5: 'Haven\\'t checked in today. Your journal missed you.',
        translation.exportFailed: 'Export failed',
        translation.importFailed: 'Import failed',
        translation.todoRestoredSuccess: 'To-Do list restored successfully',
        translation.myToDo: 'My To-Do',
        translation.nothingHere: 'Nothing here',
        translation.setTime: 'Set time',
        translation.amLabel: 'AM',
        translation.pmLabel: 'PM',
        translation.tapNumbersHint: 'Tap numbers to type  •  arrows to scroll',
        translation.ok: 'OK',
        translation.newTask: 'New Task',
        translation.colorOptional: 'Color (optional)',
        translation.saveTask: 'Save Task',
        translation.deleteTaskConfirm: 'Delete task?',
        translation.cannotBeUndone: 'This cannot be undone.',
        translation.colorLabel: 'Color',
        translation.addDateTimeOptional: 'Add date & time (optional)',
        translation.addDateTime: 'Add date & time',
        translation.completed: 'Completed',
        translation.markAsComplete: 'Mark as complete',
        translation.searchTasks: 'Search tasks...',
        translation.activeTab: 'Active',
        translation.whatDoYouNeedToDo: 'What do you need to do?',
        translation.taskName: 'Task name',"""
    },
    "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/localization/es.dart": {
        "anchor": "translation.journalReminder5: 'No has escrito hoy. Tu diario te extrañó.',",
        "insert": """translation.journalReminder5: 'No has escrito hoy. Tu diario te extrañó.',
        translation.exportFailed: 'Error al exportar',
        translation.importFailed: 'Error al importar',
        translation.todoRestoredSuccess: 'Lista de tareas restaurada con éxito',
        translation.myToDo: 'Mis Tareas',
        translation.nothingHere: 'No hay nada aquí',
        translation.setTime: 'Configurar hora',
        translation.amLabel: 'AM',
        translation.pmLabel: 'PM',
        translation.tapNumbersHint: 'Toca los números para escribir  •  flechas para desplazar',
        translation.ok: 'OK',
        translation.newTask: 'Nueva Tarea',
        translation.colorOptional: 'Color (opcional)',
        translation.saveTask: 'Guardar Tarea',
        translation.deleteTaskConfirm: '¿Eliminar tarea?',
        translation.cannotBeUndone: 'Esto no se puede deshacer.',
        translation.colorLabel: 'Color',
        translation.addDateTimeOptional: 'Agregar fecha y hora (opcional)',
        translation.addDateTime: 'Agregar fecha y hora',
        translation.completed: 'Completada',
        translation.markAsComplete: 'Marcar como completada',
        translation.searchTasks: 'Buscar tareas...',
        translation.activeTab: 'Activas',
        translation.whatDoYouNeedToDo: '¿Qué necesitas hacer?',
        translation.taskName: 'Nombre de la tarea',"""
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
