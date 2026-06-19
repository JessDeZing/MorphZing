import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/presentation/pages/screens/note/all_note/all_note_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/presentation/widgets/note_item.dart';
import 'package:morphzing/utils/style/colors.dart';

class AllNoteScreen extends StatefulWidget {
  const AllNoteScreen({Key? key}) : super(key: key);

  @override
  State<AllNoteScreen> createState() => _AllNoteScreenState();
}

class _AllNoteScreenState extends State<AllNoteScreen> {
  bool _searchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Note> _filtered(List<Note> source) {
    if (_searchQuery.isEmpty) return source;
    final q = _searchQuery.toLowerCase();
    return source
        .where((n) =>
            (n.noteName ?? '').toLowerCase().contains(q) ||
            (n.noteDescription ?? '').toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<AllNoteController>(
      init: AllNoteController(),
      builder: (controller) {
        return Obx(() {
          return Scaffold(
            backgroundColor: isDark ? darkBgColor : whiteColor,
            appBar: controller.isChecking
                ? AppBar(
                    elevation: 5,
                    shadowColor: Colors.black26,
                    leading: TextButton(
                      onPressed: () => controller.onCancel(),
                      child: const Text('Cancel'),
                    ),
                    leadingWidth: 100,
                    backgroundColor: isDark ? darkBgColor : bgColor,
                    centerTitle: true,
                    title: Text(
                      'All note',
                      style: TextStyle(
                        color: isDark ? whiteColor : blackTextColor,
                        fontFamily: 'SF Pro Display',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => controller.onSelectAll(),
                        child: const Text('Select all'),
                      )
                    ],
                  )
                : AppBar(
                    backgroundColor: isDark ? darkBgColor : whiteColor,
                    elevation: 0,
                    title: _searchExpanded
                        ? TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: TextStyle(
                                color: isDark ? whiteColor : blackTextColor),
                            decoration: InputDecoration(
                              hintText: 'Search notes...',
                              hintStyle: TextStyle(color: greyTextColor),
                              border: InputBorder.none,
                            ),
                            onChanged: (v) => setState(() => _searchQuery = v),
                          )
                        : Text(
                            'Notes',
                            style: TextStyle(
                              color: isDark ? whiteColor : blackTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          _searchExpanded ? Icons.close : Icons.search,
                          color: isDark ? whiteColor : blackTextColor,
                        ),
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
                  ),
            body: SafeArea(
              child: Obx(() {
                if (controller.rxStatus.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.rxStatus.isError) {
                  return Center(
                    child: Text(controller.rxStatus.errorMessage.toString()),
                  );
                }

                if (controller.rxStatus.isSuccess) {
                  final filtered = _filtered(controller.orderedNotes);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_searchQuery.isEmpty ? controller.response.total : filtered.length} note',
                                  style: TextStyle(
                                    color: isDark ? whiteColor : greyTextColor,
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'All note',
                                  style: TextStyle(
                                    color: isDark ? whiteColor : blackTextColor,
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Filter dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? whiteColor.withOpacity(0.3)
                                      : greyTextColor.withOpacity(0.3),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: controller.currentFilter,
                                  isDense: true,
                                  style: TextStyle(
                                    color: isDark ? whiteColor : blackTextColor,
                                    fontSize: 12,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'all', child: Text('All')),
                                    DropdownMenuItem(
                                        value: 'alphabetical',
                                        child: Text('A-Z')),
                                    DropdownMenuItem(
                                        value: 'custom', child: Text('Custom')),
                                  ],
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.setFilter(newValue);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                controller.openAllFolder(context);
                              },
                              icon: const Icon(Icons.folder, color: blueColor),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No results found'
                                      : 'No notes yet',
                                  style: TextStyle(
                                    color: isDark ? whiteColor : blackTextColor,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : GridView.builder(
                                controller: controller.scrollController,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 0.8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                itemCount: _searchQuery.isEmpty &&
                                        !controller.response.isLastPage()
                                    ? filtered.length + 1
                                    : filtered.length,
                                itemBuilder: (context, index) {
                                  if (_searchQuery.isEmpty &&
                                      !controller.response.isLastPage() &&
                                      index == controller.orderedNotes.length) {
                                    return controller.rxStatus.isLoadingMore
                                        ? const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }

                                  final note = filtered[index];
                                  final isPinned =
                                      controller.isNotePinned(note.id);

                                  return DragTarget<int>(
                                    key: ValueKey('target_${note.id ?? index}'),
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: candidateData.isNotEmpty
                                              ? Border.all(
                                                  color: Colors.blue, width: 2.0)
                                              : null,
                                        ),
                                        child: LongPressDraggable<int>(
                                          key: ValueKey(
                                              'draggable_${note.id ?? index}'),
                                          data: index,
                                          delay:
                                              const Duration(milliseconds: 500),
                                          feedback: Material(
                                            elevation: 8.0,
                                            child: Container(
                                              width: 150,
                                              height: 180,
                                              child: NoteItem(
                                                note: note,
                                                isPinned: isPinned,
                                                onPinPressed: () => controller
                                                    .togglePinNote(note),
                                                onPressed: () {},
                                                onLongPressed: () {},
                                                onDoublePressed: () {},
                                              ),
                                            ),
                                          ),
                                          childWhenDragging: Opacity(
                                            opacity: 0.5,
                                            child: NoteItem(
                                              note: note,
                                              isPinned: isPinned,
                                              onPinPressed: () => controller
                                                  .togglePinNote(note),
                                              onPressed: () {},
                                              onLongPressed: () {},
                                              onDoublePressed: () {},
                                            ),
                                          ),
                                          child: NoteItem(
                                            note: note,
                                            isPinned: isPinned,
                                            onPinPressed: () =>
                                                controller.togglePinNote(note),
                                            onPressed: () {
                                              if (controller.isChecking) {
                                                int originalIndex = controller
                                                    .response.data
                                                    .indexWhere(
                                                        (n) => n.id == note.id);
                                                if (originalIndex != -1) {
                                                  controller
                                                      .onChangeNoteChecked(
                                                          originalIndex);
                                                }
                                              } else {
                                                controller.openNoteScreen(
                                                    note: note);
                                              }
                                            },
                                            onLongPressed: () {},
                                            onDoublePressed: () {},
                                          ),
                                        ),
                                      );
                                    },
                                    onAccept: (draggedIndex) {
                                      if (draggedIndex != index) {
                                        controller.reorderNotes(
                                            draggedIndex, index);
                                      }
                                    },
                                    onWillAccept: (data) => data != null,
                                  );
                                },
                              ),
                      ),
                      if (controller.isChecking)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: controller.isValidate()
                                ? () =>
                                    controller.openMoveFolderBottom(context)
                                : null,
                            child: const Text('Move to Folder'),
                          ),
                        )
                    ],
                  );
                }

                return const SizedBox();
              }),
            ),
            bottomNavigationBar: controller.isChecking
                ? null
                : CustomBottomBar.customBottomBar(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: controller.isChecking
                ? null
                : CustomBottomBar.journalFloatingActionButton(
                    () => controller.openNoteScreen(),
                    color: blueColor,
                  ),
          );
        });
      },
    );
  }
}
