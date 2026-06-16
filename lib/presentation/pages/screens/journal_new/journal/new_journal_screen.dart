import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/journal/new_journal_controller.dart';

class NewJournalScreen extends StatefulWidget {
  const NewJournalScreen({Key? key}) : super(key: key);

  @override
  State<NewJournalScreen> createState() => _NewJournalScreenState();
}

class _NewJournalScreenState extends State<NewJournalScreen> {
  late final NewJournalController _controller;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _journeyTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(NewJournalController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.isJournalEdit) {
        final j = _controller.journalToEdit!;
        _titleController.text = j.noteName;
        _descController.text = j.description ?? '';
        if (j.journeyTime != null) _journeyTime = j.journeyTime!;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _journeyTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF6c63ff)),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_journeyTime),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Color(0xFF6c63ff)),
        ),
        child: child!,
      ),
    );
    if (time == null) return;
    setState(() {
      _journeyTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  Future<void> _save() async {
    final success = await _controller.saveJournal(
      title: _titleController.text,
      description: _descController.text,
      journeyTime: _journeyTime,
    );
    if (success) {
      Get.back(result: true);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('Delete entry?',
            style: TextStyle(color: Colors.white)),
        content: const Text('This cannot be undone.',
            style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final success = await _controller.deleteJournal();
    if (success) Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121f),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12121f),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          _controller.isJournalEdit ? 'Edit Entry' : 'New Journal Entry',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        )),
        actions: [
          Obx(() {
            if (_controller.isJournalEdit) {
              return IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: _controller.isSaving.value ? null : _delete,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date picker row
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e1e30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF6c63ff), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: Color(0xFF6c63ff), size: 18),
                      const SizedBox(width: 10),
                      Text(
                        DateFormat('MMMM d, yyyy  h:mm a').format(_journeyTime),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                      const Spacer(),
                      const Icon(Icons.edit_outlined,
                          color: Colors.white38, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title field
              const Text('Title',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Give your entry a title...',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF1e1e30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 20),
              // Description field
              const Text('Journal Entry',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, height: 1.6),
                maxLines: 18,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts...',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: const Color(0xFF1e1e30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 8),
              // Error message
              Obx(() {
                if (_controller.errorMessage.value.isEmpty)
                  return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _controller.errorMessage.value,
                    style: const TextStyle(
                        color: Colors.redAccent, fontSize: 13),
                  ),
                );
              }),
              const SizedBox(height: 16),
              // Save button
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _controller.isSaving.value ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6c63ff),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _controller.isSaving.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _controller.isJournalEdit
                              ? 'Update Entry'
                              : 'Save Entry',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
