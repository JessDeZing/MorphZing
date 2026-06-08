import 'package:flutter/material.dart';
import 'package:morphzing/data/models/agenda/todo.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Todo> _tasks = [];
  bool _searchOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Todo> get _todayTasks => _tasks.where((t) =>
    t.status == TodoStatus.todo &&
    t.todayTime != null &&
    _isToday(t.todayTime!)
  ).toList();

  List<Todo> get _thisWeekTasks => _tasks.where((t) =>
    t.status == TodoStatus.todo &&
    t.todayTime != null &&
    _isThisWeek(t.todayTime!) &&
    !_isToday(t.todayTime!)
  ).toList();

  List<Todo> get _noDateTasks => _tasks.where((t) =>
    t.status == TodoStatus.todo &&
    t.todayTime == null
  ).toList();

  List<Todo> get _completedTasks => _tasks.where((t) =>
    t.status == TodoStatus.done
  ).toList();

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  bool _isThisWeek(DateTime dt) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return dt.isAfter(startOfWeek) && dt.isBefore(endOfWeek);
  }

  void _toggleComplete(Todo task) {
    setState(() {
      final idx = _tasks.indexOf(task);
      if (idx != -1) {
        final updated = Todo(
          taskName: task.taskName,
          status: task.status == TodoStatus.todo ? TodoStatus.done : TodoStatus.todo,
          isGoal: task.isGoal,
          todoType: task.todoType,
          notes: task.notes,
          todayTime: task.todayTime,
        );
        _tasks[idx] = updated;
      }
    });
  }

  void _deleteTask(Todo task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  void _addTask(Todo task) {
    setState(() {
      _tasks.add(task);
    });
  }

  Widget _buildTaskList(List<Todo> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks here', style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final color = task.getBgColor() ?? Colors.grey;
        return GestureDetector(
          onTap: () => _openTaskDetail(task),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border(left: BorderSide(color: color, width: 3)),
            ),
            child: ListTile(
              leading: GestureDetector(
                onTap: () => _toggleComplete(task),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                    color: task.status == TodoStatus.done ? color : Colors.transparent,
                  ),
                  child: task.status == TodoStatus.done
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
                ),
              ),
              title: Text(
                task.taskName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: task.status == TodoStatus.done
                    ? TextDecoration.lineThrough
                    : null,
                ),
              ),
              subtitle: task.todayTime != null
                ? Text(
                    _formatDate(task.todayTime!),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  )
                : (task.notes.isNotEmpty
                    ? Text(task.notes, style: const TextStyle(color: Colors.grey, fontSize: 11))
                    : null),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    return '${_monthName(dt.month)} ${dt.day}';
  }

  String _monthName(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[month - 1];
  }

  void _openTaskDetail(Todo task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _TaskDetailScreen(
          task: task,
          onDelete: () {
            _deleteTask(task);
            Navigator.pop(context);
          },
          onToggle: () {
            _toggleComplete(task);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _openAddTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1a1a2e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddTaskSheet(onSave: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121f),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12121f),
        elevation: 0,
        title: _searchOpen
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            )
          : const Text('My To-Do', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: Icon(_searchOpen ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () => setState(() {
              _searchOpen = !_searchOpen;
              if (!_searchOpen) {
                _searchQuery = '';
                _searchController.clear();
              }
            }),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6c63ff),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'No Date'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(_todayTasks),
          _buildTaskList(_thisWeekTasks),
          _buildTaskList(_noDateTasks),
          _buildTaskList(_completedTasks),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6c63ff),
        onPressed: _openAddTask,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ── Task Detail Screen ─────────────────────────────────────────────────────────
class _TaskDetailScreen extends StatelessWidget {
  final Todo task;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _TaskDetailScreen({
    required this.task,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final color = task.getBgColor() ?? Colors.grey;
    return Scaffold(
      backgroundColor: const Color(0xFF12121f),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12121f),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Task detail', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: color, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.taskName,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  if (task.todayTime != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${task.todayTime!.month}/${task.todayTime!.day}/${task.todayTime!.year}  '
                      '${TimeOfDay.fromDateTime(task.todayTime!).format(context)}',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                  if (task.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(task.notes, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.check_circle_outline, color: Color(0xFF6c63ff)),
                label: Text(
                  task.status == TodoStatus.todo ? 'Mark complete' : 'Mark incomplete',
                  style: const TextStyle(color: Color(0xFF6c63ff)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6c63ff)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onToggle,
              ),
            ),
            const SizedBox(height: 12),
            _DeleteButton(onDelete: onDelete),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatefulWidget {
  final VoidCallback onDelete;
  const _DeleteButton({required this.onDelete});

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    if (!_confirming) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.delete_outline, color: Color(0xFFe05c5c)),
          label: const Text('Delete task', style: TextStyle(color: Color(0xFFe05c5c))),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF5a2a2a)),
            backgroundColor: const Color(0xFF2a1a1a),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => setState(() => _confirming = true),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFe05c5c),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: widget.onDelete,
            child: const Text('Yes, delete this task', style: TextStyle(color: Colors.white)),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _confirming = false),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}

// ── Add Task Sheet ─────────────────────────────────────────────────────────────
class _AddTaskSheet extends StatefulWidget {
  final Function(Todo) onSave;
  const _AddTaskSheet({required this.onSave});

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _nameController = TextEditingController();
  DateTime? _pickedDate;
  Color? _pickedColor;

  final List<Color?> _colorOptions = [
    null,
    const Color(0xFFe05c5c),
    const Color(0xFFf5a623),
    const Color(0xFF6c63ff),
    const Color(0xFF4ecdc4),
    const Color(0xFF5cb85c),
    const Color(0xFFe91e8c),
  ];

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF6c63ff)),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF6c63ff)),
        ),
        child: child!,
      ),
    );
    if (time == null) return;
    setState(() {
      _pickedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final todo = Todo(
      taskName: name,
      status: TodoStatus.todo,
      isGoal: false,
      todoType: TodoType.daily,
      notes: '',
      todayTime: _pickedDate,
    );
    widget.onSave(todo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('New task', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'What needs to get done?',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF2a2a40),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _pickDateTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a40),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Color(0xFF6c63ff), size: 18),
                  const SizedBox(width: 10),
                  Text(
                    _pickedDate == null
                      ? 'Date & time (optional)'
                      : '${_pickedDate!.month}/${_pickedDate!.day}/${_pickedDate!.year}  '
                        '${TimeOfDay.fromDateTime(_pickedDate!).format(context)}',
                    style: TextStyle(
                      color: _pickedDate == null ? Colors.grey : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (_pickedDate != null)
                    GestureDetector(
                      onTap: () => setState(() => _pickedDate = null),
                      child: const Icon(Icons.close, color: Colors.grey, size: 16),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Color (optional)', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: _colorOptions.map((color) {
              final isSelected = _pickedColor == color;
              return GestureDetector(
                onTap: () => setState(() => _pickedColor = color),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color ?? Colors.transparent,
                    border: Border.all(
                      color: color == null
                        ? Colors.grey.withOpacity(0.4)
                        : (isSelected ? Colors.white : Colors.transparent),
                      width: isSelected ? 2 : 1,
                      style: color == null ? BorderStyle.solid : BorderStyle.solid,
                    ),
                  ),
                  child: color == null
                    ? const Icon(Icons.remove, color: Colors.grey, size: 14)
                    : (isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6c63ff),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _save,
              child: const Text('Save task', style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}