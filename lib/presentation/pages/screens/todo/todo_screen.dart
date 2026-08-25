import 'dart:convert';
import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart' as translation;
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class TodoItem {
  final String id;
  String title;
  Color? color;
  DateTime? dueDate;
  bool completed;
  double rowHeight;

  TodoItem({
    required this.id,
    required this.title,
    this.color,
    this.dueDate,
    this.completed = false,
    this.rowHeight = 56.0,
  });
}

const List<Color?> kColorOptions = [
  null,
  Color(0xFFFF0000),
  Color(0xFFFF7700),
  Color(0xFFFFFF00),
  Color(0xFF00CC00),
  Color(0xFF0000FF),
  Color(0xFF4B0082),
  Color(0xFF8B00FF),
];

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _searchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<TodoItem> _items = [];
  final _box = GetStorage();

  void _saveItems() {
    final data = _items.map((t) => {
      "id": t.id,
      "title": t.title,
      "color": t.color?.value,
      "dueDate": t.dueDate?.toIso8601String(),
      "completed": t.completed,
    }).toList();
    _box.write("tasks", data);
  }

  void _loadItems() {
    final data = _box.read<List>("tasks");
    if (data != null) {
      setState(() {
        _items.clear();
        _items.addAll(data.map((e) => TodoItem(
          id: e["id"],
          title: e["title"],
          color: e["color"] != null ? Color(e["color"]) : null,
          dueDate: e["dueDate"] != null ? DateTime.parse(e["dueDate"]) : null,
          completed: e["completed"] ?? false,
        )));
      });
    }
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"' + value.replaceAll('"', '""') + '"';
    }
    return value;
  }

  Future<void> _exportTasks() async {
    try {
      final buffer = StringBuffer();
      buffer.writeln('title,color,dueDate,completed');
      for (final t in _items) {
        final row = [
          _csvEscape(t.title),
          t.color?.value.toString() ?? '',
          t.dueDate?.toIso8601String() ?? '',
          t.completed.toString(),
        ].join(',');
        buffer.writeln(row);
      }
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/MorphZing_ToDo_Backup.csv');
      await file.writeAsString(buffer.toString());
      await Share.shareXFiles([XFile(file.path)], text: 'MorphZing To-Do backup');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${translation.exportFailed.tr}: $e')),
        );
      }
    }
  }

  List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;
    for (int i = 0; i < line.length; i++) {
      final c = line[i];
      if (inQuotes) {
        if (c == '"' && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else if (c == '"') {
          inQuotes = false;
        } else {
          buffer.write(c);
        }
      } else {
        if (c == '"') {
          inQuotes = true;
        } else if (c == ',') {
          fields.add(buffer.toString());
          buffer.clear();
        } else {
          buffer.write(c);
        }
      }
    }
    fields.add(buffer.toString());
    return fields;
  }

  Future<void> _importTasks() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result == null || result.files.single.path == null) return;
      final file = File(result.files.single.path!);
      final csvStr = await file.readAsString();
      final lines = csvStr.split('\n').where((l) => l.trim().isNotEmpty).toList();
      if (lines.isEmpty) return;
      final newItems = <TodoItem>[];
      for (int i = 1; i < lines.length; i++) {
        final fields = _parseCsvLine(lines[i]);
        if (fields.length < 4) continue;
        newItems.add(TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '_' + i.toString(),
          title: fields[0],
          color: fields[1].isNotEmpty ? Color(int.parse(fields[1])) : null,
          dueDate: fields[2].isNotEmpty ? DateTime.parse(fields[2]) : null,
          completed: fields[3].trim().toLowerCase() == 'true',
        ));
      }
      setState(() {
        _items.clear();
        _items.addAll(newItems);
      });
      _saveItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translation.todoRestoredSuccess.tr)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${translation.importFailed.tr}: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TodoItem> _filtered(List<TodoItem> source) {
    if (_searchQuery.isEmpty) return source;
    return source
        .where((t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<TodoItem> get _activeItems => _items.where((t) => !t.completed).toList();
  List<TodoItem> get _completedItems => _items.where((t) => t.completed).toList();

  void _toggleComplete(TodoItem item) {
    setState(() => item.completed = !item.completed);
    _saveItems();
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddTaskSheet(
        onAdd: (item) {
          setState(() => _items.insert(0, item));
          _saveItems();
        },
      ),
    );
  }

  void _showDetailSheet(TodoItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => TaskDetailSheet(
        item: item,
        onDelete: () {
          setState(() => _items.remove(item));
          _saveItems();
          Navigator.pop(ctx);
        },
        onUpdate: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: _searchExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: translation.searchTasks.tr,
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : Text(translation.myToDo.tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined, color: Colors.white70),
            tooltip: 'Export backup',
            onPressed: _exportTasks,
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Colors.white70),
            tooltip: 'Import backup',
            onPressed: _importTasks,
          ),
          IconButton(
            icon: Icon(_searchExpanded ? Icons.close : Icons.search,
                color: Colors.white70),
            onPressed: () {
              setState(() {
                _searchExpanded = !_searchExpanded;
                if (!_searchExpanded) {
                  _searchController.clear();
                  _searchQuery = '';
                }
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF7C4DFF),
          labelColor: const Color(0xFF7C4DFF),
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: translation.activeTab.tr),
            Tab(text: translation.completed.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_filtered(_activeItems)),
          _buildList(_filtered(_completedItems)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: const Color(0xFF7C4DFF),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildList(List<TodoItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, size: 56, color: Colors.white12),
            const SizedBox(height: 12),
            Text(translation.nothingHere.tr,
                style: TextStyle(color: Colors.white24, fontSize: 16)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _TodoRow(
        item: items[i],
        onTap: () => _showDetailSheet(items[i]),
        onToggle: () => _toggleComplete(items[i]),
      ),
    );
  }
}

class _TodoRow extends StatefulWidget {
  final TodoItem item;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const _TodoRow({required this.item, required this.onTap, required this.onToggle});

  @override
  State<_TodoRow> createState() => _TodoRowState();
}

class _TodoRowState extends State<_TodoRow> {
  double _startHeight = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final accent = item.color ?? Colors.white24;

    return GestureDetector(
      onScaleStart: (_) => _startHeight = item.rowHeight,
      onScaleUpdate: (d) => setState(
          () => item.rowHeight = (_startHeight * d.scale).clamp(44.0, 120.0)),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        height: item.rowHeight,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: accent, width: 3)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            GestureDetector(
              onTap: widget.onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: item.completed ? accent : Colors.white30, width: 2),
                  color: item.completed ? accent : Colors.transparent,
                ),
                child: item.completed
                    ? const Icon(Icons.check, size: 14, color: Colors.black)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: item.completed ? Colors.white30 : Colors.white,
                  fontSize: 15,
                  decoration: item.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: Colors.white30,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.dueDate != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  _shortDate(item.dueDate!),
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ColorPickerRow extends StatelessWidget {
  final Color? selected;
  final void Function(Color?) onSelect;

  const ColorPickerRow({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: kColorOptions.map((c) {
        final isSelected = selected == c;
        return GestureDetector(
          onTap: () => onSelect(c),
          child: Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c ?? const Color(0xFF333333),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2.5)
                  : Border.all(color: Colors.white12, width: 1),
            ),
            child: c == null
                ? const Icon(Icons.block, size: 13, color: Colors.white38)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

Future<TimeOfDay?> showDigitalTimePicker(
    BuildContext context, TimeOfDay initial, bool use24Hour) async {
  int hour = initial.hour;
  int minute = initial.minute;
  bool isAM = hour < 12;

  final hourCtrl = TextEditingController(
      text: _fmtNum(use24Hour ? hour : _to12(hour)));
  final minCtrl = TextEditingController(text: _fmtNum(minute));

  return await showDialog<TimeOfDay>(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
      void applyHour(String val) {
        final n = int.tryParse(val);
        if (n == null) return;
        if (use24Hour) {
          hour = n.clamp(0, 23);
        } else {
          final h12 = n.clamp(1, 12);
          hour = isAM ? (h12 == 12 ? 0 : h12) : (h12 == 12 ? 12 : h12 + 12);
        }
      }

      void applyMin(String val) {
        final n = int.tryParse(val);
        if (n == null) return;
        minute = n.clamp(0, 59);
      }

      return AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(translation.setTime.tr,
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _TimeBox(
                  controller: hourCtrl,
                  onChanged: applyHour,
                  onUp: () => setS(() {
                    hour = (hour + 1) % 24;
                    if (!use24Hour) isAM = hour < 12;
                    hourCtrl.text = _fmtNum(use24Hour ? hour : _to12(hour));
                  }),
                  onDown: () => setS(() {
                    hour = (hour - 1 + 24) % 24;
                    if (!use24Hour) isAM = hour < 12;
                    hourCtrl.text = _fmtNum(use24Hour ? hour : _to12(hour));
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(':',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w300)),
                ),
                _TimeBox(
                  controller: minCtrl,
                  onChanged: applyMin,
                  onUp: () => setS(() {
                    minute = (minute + 1) % 60;
                    minCtrl.text = _fmtNum(minute);
                  }),
                  onDown: () => setS(() {
                    minute = (minute - 1 + 60) % 60;
                    minCtrl.text = _fmtNum(minute);
                  }),
                ),
                if (!use24Hour) ...[
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => setS(() {
                          isAM = true;
                          if (hour >= 12) hour -= 12;
                          hourCtrl.text = _fmtNum(_to12(hour));
                        }),
                        child: Container(
                          width: 48,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isAM ? const Color(0xFF7C4DFF) : const Color(0xFF2A2A2A),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: Text(translation.amLabel.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: isAM ? Colors.white : Colors.white38,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setS(() {
                          isAM = false;
                          if (hour < 12) hour += 12;
                          hourCtrl.text = _fmtNum(_to12(hour));
                        }),
                        child: Container(
                          width: 48,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isAM ? const Color(0xFF7C4DFF) : const Color(0xFF2A2A2A),
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                          ),
                          child: Text(translation.pmLabel.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: !isAM ? Colors.white : Colors.white38,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(translation.tapNumbersHint.tr,
                style: TextStyle(color: Colors.white24, fontSize: 11)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(translation.cancel.tr,
                style: const TextStyle(color: Colors.white54, fontSize: 15)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, TimeOfDay(hour: hour, minute: minute)),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(translation.ok.tr,
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      );
    }),
  );
}

class _TimeBox extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final VoidCallback onUp;
  final VoidCallback onDown;

  const _TimeBox({
    required this.controller,
    required this.onChanged,
    required this.onUp,
    required this.onDown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onUp,
          icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white70, size: 28),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 72,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 2,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: const Color(0xFF252525),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 4),
        IconButton(
          onPressed: onDown,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70, size: 28),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

int _to12(int h) => h == 0 ? 12 : h > 12 ? h - 12 : h;
String _fmtNum(int n) => n.toString().padLeft(2, '0');

class AddTaskSheet extends StatefulWidget {
  final void Function(TodoItem) onAdd;
  const AddTaskSheet({super.key, required this.onAdd});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  Color? _selectedColor;
  DateTime? _dueDate;

  bool get _use24Hour => MediaQuery.of(context).alwaysUse24HourFormat;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF7C4DFF)),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    final time = await showDigitalTimePicker(
      context,
      _dueDate != null ? TimeOfDay.fromDateTime(_dueDate!) : TimeOfDay.now(),
      _use24Hour,
    );
    if (time == null) return;
    setState(() {
      _dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    widget.onAdd(TodoItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      color: _selectedColor,
      dueDate: _dueDate,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPad),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, bottomPad > 0 ? 16 : 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translation.newTask.tr,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: translation.whatDoYouNeedToDo.tr,
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: const Color(0xFF252525),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(translation.colorOptional.tr,
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 8),
              ColorPickerRow(
                  selected: _selectedColor,
                  onSelect: (c) => setState(() => _selectedColor = c)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.white54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _dueDate == null
                              ? translation.addDateTimeOptional.tr
                              : _formatDateTime(_dueDate!, _use24Hour),
                          style: TextStyle(
                            color: _dueDate == null ? Colors.white38 : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (_dueDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _dueDate = null),
                          child: const Icon(Icons.close, size: 16, color: Colors.white38),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _submit,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(translation.saveTask.tr,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskDetailSheet extends StatefulWidget {
  final TodoItem item;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const TaskDetailSheet({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<TaskDetailSheet> {
  late TextEditingController _titleController;

  bool get _use24Hour => MediaQuery.of(context).alwaysUse24HourFormat;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
  }

  Future<void> _pickDateTime() async {
    final item = widget.item;
    final date = await showDatePicker(
      context: context,
      initialDate: item.dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF7C4DFF)),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    final time = await showDigitalTimePicker(
      context,
      item.dueDate != null ? TimeOfDay.fromDateTime(item.dueDate!) : TimeOfDay.now(),
      _use24Hour,
    );
    if (time == null) return;
    setState(() {
      item.dueDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
    widget.onUpdate();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(translation.deleteTaskConfirm.tr, style: const TextStyle(color: Colors.white)),
        content: Text(translation.cannotBeUndone.tr, style: const TextStyle(color: Colors.white54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(translation.cancel.tr, style: const TextStyle(color: Colors.white54, fontSize: 15)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDelete();
            },
            child: Text(translation.delete.tr, style: const TextStyle(color: Colors.redAccent, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final accent = item.color ?? const Color(0xFF7C4DFF);

    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, bottomPad > 0 ? bottomPad + 16 : 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: translation.taskName.tr,
                        hintStyle: TextStyle(color: Colors.white38)),
                    onChanged: (v) {
                      item.title = v;
                      widget.onUpdate();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: _confirmDelete,
                ),
              ],
            ),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 20),
            Text(translation.colorLabel.tr, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            ColorPickerRow(
              selected: item.color,
              onSelect: (c) {
                setState(() => item.color = c);
                widget.onUpdate();
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickDateTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.white54),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.dueDate == null
                            ? translation.addDateTime.tr
                            : _formatDateTime(item.dueDate!, _use24Hour),
                        style: TextStyle(
                          color: item.dueDate == null ? Colors.white38 : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Icon(Icons.edit_outlined, size: 16, color: Colors.white38),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() => item.completed = !item.completed);
                widget.onUpdate();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: item.completed ? Colors.green.withOpacity(0.12) : const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: item.completed ? Colors.greenAccent : Colors.white38,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.completed ? translation.completed.tr : translation.markAsComplete.tr,
                      style: TextStyle(
                        color: item.completed ? Colors.greenAccent : Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dt, bool use24Hour) {
  final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  final dateStr = '${months[dt.month - 1]} ${dt.day}';
  if (use24Hour) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$dateStr  $h:$m';
  } else {
    final hour = dt.hour == 0 ? 12 : dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final period = dt.hour < 12 ? 'AM' : 'PM';
    final m = dt.minute.toString().padLeft(2, '0');
    return '$dateStr  $hour:$m $period';
  }
}

String _shortDate(DateTime dt) {
  final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${months[dt.month - 1]} ${dt.day}';
}
