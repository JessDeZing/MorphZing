import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/style/colors.dart';

class AllEntriesScreen extends StatefulWidget {
  const AllEntriesScreen({Key? key}) : super(key: key);

  @override
  State<AllEntriesScreen> createState() => _AllEntriesScreenState();
}

class _AllEntriesScreenState extends State<AllEntriesScreen> {
  final _repo = getIt<NewJournalRepository>();
  List<JournalModel> _entries = [];
  bool _loading = true;
  String _searchQuery = '';
  bool _searchOpen = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() { _loading = true; _entries = []; });
    try {
      final endDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year + 1));
      int page = 1;
      int total = 0;
      while (true) {
        final result = await _repo.getJournalByDate(
          startDate: '2000-01-01',
          endDate: endDate,
          currentPage: page,
        );
        total = result.total;
        final merged = [..._entries, ...result.data];
        merged.sort((a, b) => (b.journeyTime ?? DateTime(0)).compareTo(a.journeyTime ?? DateTime(0)));
        setState(() {
          _entries = merged;
          _loading = false;
        });
        if (result.data.isEmpty || _entries.length >= total) break;
        page++;
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  List<JournalModel> get _filtered {
    if (_searchQuery.isEmpty) return _entries;
    return _entries.where((e) =>
      e.noteName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (e.description ?? '').toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
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
        title: _searchOpen
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search entries...',
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              )
            : const Text('My Life Journey',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(
                _searchOpen ? Icons.close : Icons.search,
                color: Colors.white70),
            onPressed: () => setState(() {
              _searchOpen = !_searchOpen;
              if (!_searchOpen) {
                _searchController.clear();
                _searchQuery = '';
              }
            }),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6c63ff)))
          : _filtered.isEmpty
              ? const Center(
                  child: Text('No entries found',
                      style: TextStyle(color: Colors.white38, fontSize: 16)))
              : _buildGroupedList(),
    );
  }
  Widget _buildGroupedList() {
    // Group entries by date
    final Map<String, List<dynamic>> grouped = {};
    for (var entry in _filtered) {
      final dt = entry.journeyTime;
      final key = dt != null ? DateFormat('MMMM d, yyyy').format(dt) : 'Unknown';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(entry);
    }

    final keys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      itemCount: keys.length,
      itemBuilder: (ctx, i) {
        final dateKey = keys[i];
        final entries = grouped[dateKey]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                children: [
                  Text(
                    dateKey,
                    style: const TextStyle(
                      color: Color(0xFF6c63ff),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(child: Divider(color: Color(0xFF6c63ff), thickness: 0.4)),
                ],
              ),
            ),
            // Entries for this date
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1e1e35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: entries.asMap().entries.map((e) {
                  final idx = e.key;
                  final entry = e.value;
                  final dt = entry.journeyTime;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(journeyRoute, arguments: entry)?.then((_) => _loadEntries()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Time on left
                              SizedBox(
                                width: 55,
                                child: Text(
                                  dt != null ? DateFormat('h:mm a').format(dt) : '',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              // Entry content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.noteName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if ((entry.description ?? '').isNotEmpty) ...[
                                      const SizedBox(height: 3),
                                      Text(
                                        entry.description!,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Thin divider between entries (not after last)
                      if (idx < entries.length - 1)
                        const Divider(height: 1, thickness: 0.3, color: Colors.white12, indent: 16, endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

}
