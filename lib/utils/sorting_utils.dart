import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/note.dart';

class SortingUtils {
  /// Sort notes alphabetically by name (case-insensitive)
  static List<Note> sortNotesAlphabetically(List<Note> notes) {
    final sortedNotes = List<Note>.from(notes);
    sortedNotes.sort((a, b) {
      final nameA = a.noteName?.toLowerCase() ?? '';
      final nameB = b.noteName?.toLowerCase() ?? '';
      return nameA.compareTo(nameB);
    });
    return sortedNotes;
  }

  /// Sort folders alphabetically by name (case-insensitive)
  static List<Folder> sortFoldersAlphabetically(List<Folder> folders) {
    final sortedFolders = List<Folder>.from(folders);
    sortedFolders.sort((a, b) {
      final nameA = a.name?.toLowerCase() ?? '';
      final nameB = b.name?.toLowerCase() ?? '';
      return nameA.compareTo(nameB);
    });
    return sortedFolders;
  }

  /// Sort notes by custom order first, then alphabetically
  static List<Note> sortNotesWithCustomOrder(
    List<Note> notes,
    List<int> customOrder,
    Set<int> pinnedIds,
  ) {
    // Separate pinned and unpinned notes
    List<Note> pinnedNotes =
        notes.where((note) => pinnedIds.contains(note.id)).toList();
    List<Note> unpinnedNotes =
        notes.where((note) => !pinnedIds.contains(note.id)).toList();

    // Sort pinned notes
    pinnedNotes.sort((a, b) {
      int aIndex = customOrder.indexOf(a.id ?? -1);
      int bIndex = customOrder.indexOf(b.id ?? -1);
      if (aIndex == -1 && bIndex == -1) {
        // If no custom order, sort alphabetically
        final nameA = a.noteName?.toLowerCase() ?? '';
        final nameB = b.noteName?.toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      }
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });

    // Sort unpinned notes
    unpinnedNotes.sort((a, b) {
      int aIndex = customOrder.indexOf(a.id ?? -1);
      int bIndex = customOrder.indexOf(b.id ?? -1);
      if (aIndex == -1 && bIndex == -1) {
        // If no custom order, sort alphabetically
        final nameA = a.noteName?.toLowerCase() ?? '';
        final nameB = b.noteName?.toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      }
      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;
      return aIndex.compareTo(bIndex);
    });

    // Return pinned first, then unpinned
    return [...pinnedNotes, ...unpinnedNotes];
  }
}
