import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _overlay;

  LoadingOverlay();

  static void show(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_overlay == null) {
      _overlay = OverlayEntry(
        // replace with your own layout
        builder: (context) => ColoredBox(
          color: Theme.of(context).shadowColor.withOpacity(0.2),
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),
      );
      Overlay.of(context).insert(_overlay!);
    }
  }

  static void hide() {
    if (_overlay != null) {
      _overlay!.remove();
      _overlay = null;
    }
  }
}
