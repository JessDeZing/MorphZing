PATH = "/Users/jessica/Documents/1MORPHZING-CODE-FLUTTER-development latest /lib/presentation/pages/screens/todo/todo_screen.dart"

with open(PATH, "r", encoding="utf-8") as f:
    content = f.read()

before_size = len(content)

edits = [
    (
        "import 'package:flutter/services.dart';\n",
        "import 'package:flutter/services.dart';\nimport 'package:get/get.dart';\nimport 'package:morphzing/localization/translation_keys.dart' as translation;\n",
        "add imports"
    ),
    (
        "SnackBar(content: Text('Export failed: $e')),",
        "SnackBar(content: Text('${translation.exportFailed.tr}: $e')),",
        "export failed snackbar"
    ),
    (
        "const SnackBar(content: Text('To-Do list restored successfully')),",
        "SnackBar(content: Text(translation.todoRestoredSuccess.tr)),",
        "restored success snackbar"
    ),
    (
        "SnackBar(content: Text('Import failed: $e')),",
        "SnackBar(content: Text('${translation.importFailed.tr}: $e')),",
        "import failed snackbar"
    ),
    (
        ": const Text('My To-Do',",
        ": Text(translation.myToDo.tr,",
        "My To-Do title"
    ),
    (
        "Text('Nothing here',",
        "Text(translation.nothingHere.tr,",
        "Nothing here"
    ),
    (
        "title: const Text('Set time',",
        "title: Text(translation.setTime.tr,",
        "Set time dialog title"
    ),
    (
        "child: Text('AM',",
        "child: Text(translation.amLabel.tr,",
        "AM label"
    ),
    (
        "child: Text('PM',",
        "child: Text(translation.pmLabel.tr,",
        "PM label"
    ),
    (
        "const Text('Tap numbers to type  •  arrows to scroll',",
        "Text(translation.tapNumbersHint.tr,",
        "tap numbers hint"
    ),
    (
        "onPressed: () => Navigator.pop(ctx),\n            child: const Text('Cancel',\n                style: TextStyle(color: Colors.white54, fontSize: 15)),\n          ),\n          TextButton(\n            onPressed: () => Navigator.pop(ctx, TimeOfDay(hour: hour, minute: minute)),",
        "onPressed: () => Navigator.pop(ctx),\n            child: Text(translation.cancel.tr,\n                style: const TextStyle(color: Colors.white54, fontSize: 15)),\n          ),\n          TextButton(\n            onPressed: () => Navigator.pop(ctx, TimeOfDay(hour: hour, minute: minute)),",
        "Cancel button in time picker"
    ),
    (
        "child: const Text('OK',",
        "child: Text(translation.ok.tr,",
        "OK button"
    ),
    (
        "const Text('New Task',",
        "Text(translation.newTask.tr,",
        "New Task heading"
    ),
    (
        "hintText: 'What do you need to do?',",
        "hintText: translation.whatDoYouNeedToDo.tr,",
        "task title hint"
    ),
    (
        "const Text('Color (optional)',",
        "Text(translation.colorOptional.tr,",
        "Color optional label"
    ),
    (
        "child: const Text('Save Task',",
        "child: Text(translation.saveTask.tr,",
        "Save Task button"
    ),
    (
        "title: const Text('Delete task?', style: TextStyle(color: Colors.white)),\n        content: const Text('This cannot be undone.', style: TextStyle(color: Colors.white54)),",
        "title: Text(translation.deleteTaskConfirm.tr, style: const TextStyle(color: Colors.white)),\n        content: Text(translation.cannotBeUndone.tr, style: const TextStyle(color: Colors.white54)),",
        "delete confirm dialog title+content"
    ),
    (
        "child: const Text('Cancel', style: TextStyle(color: Colors.white54, fontSize: 15)),\n          ),\n          TextButton(\n            onPressed: () {\n              Navigator.pop(ctx);\n              widget.onDelete();\n            },\n            child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontSize: 15)),",
        "child: Text(translation.cancel.tr, style: const TextStyle(color: Colors.white54, fontSize: 15)),\n          ),\n          TextButton(\n            onPressed: () {\n              Navigator.pop(ctx);\n              widget.onDelete();\n            },\n            child: Text(translation.delete.tr, style: const TextStyle(color: Colors.redAccent, fontSize: 15)),",
        "delete dialog Cancel+Delete buttons"
    ),
    (
        "const Text('Color', style: TextStyle(color: Colors.white54, fontSize: 12)),",
        "Text(translation.colorLabel.tr, style: const TextStyle(color: Colors.white54, fontSize: 12)),",
        "Color label (edit dialog)"
    ),
    (
        "hintText: 'Search tasks...',",
        "hintText: translation.searchTasks.tr,",
        "search hint"
    ),
    (
        "tabs: const [\n            Tab(text: 'Active'),\n            Tab(text: 'Completed'),\n          ],",
        "tabs: [\n            Tab(text: translation.activeTab.tr),\n            Tab(text: translation.completed.tr),\n          ],",
        "Active/Completed tabs"
    ),
    (
        "hintText: 'Task name',",
        "hintText: translation.taskName.tr,",
        "task name hint (edit dialog)"
    ),
    (
        "_dueDate == null\n                              ? 'Add date & time (optional)'\n                              : _formatDateTime(_dueDate!, _use24Hour),",
        "_dueDate == null\n                              ? translation.addDateTimeOptional.tr\n                              : _formatDateTime(_dueDate!, _use24Hour),",
        "add date optional (new task)"
    ),
    (
        "item.dueDate == null\n                            ? 'Add date & time'\n                            : _formatDateTime(item.dueDate!, _use24Hour),",
        "item.dueDate == null\n                            ? translation.addDateTime.tr\n                            : _formatDateTime(item.dueDate!, _use24Hour),",
        "add date (task item)"
    ),
    (
        "item.completed ? 'Completed' : 'Mark as complete',",
        "item.completed ? translation.completed.tr : translation.markAsComplete.tr,",
        "completed / mark as complete"
    ),
]

for old_str, new_str, desc in edits:
    if old_str not in content:
        print(f"STOPPED: could not find text for '{desc}'. No changes written to file.")
        raise SystemExit(1)
    if content.count(old_str) > 1:
        print(f"STOPPED: text for '{desc}' found more than once — ambiguous. No changes written.")
        raise SystemExit(1)
    content = content.replace(old_str, new_str)

after_size = len(content)

if after_size <= before_size:
    print(f"STOPPED: file did not grow ({before_size} -> {after_size}). No changes written.")
    raise SystemExit(1)

with open(PATH, "w", encoding="utf-8") as f:
    f.write(content)

print(f"SUCCESS: todo_screen.dart updated ({before_size} -> {after_size} chars). All {len(edits)} edits applied.")
