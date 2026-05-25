import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/utils/style/colors.dart';

class JournalPaintWidget extends StatefulWidget {
  final bool loading;
  final File? file;
  final String drawPath;
  final VoidCallback onPressedDelete;

  const JournalPaintWidget({
    Key? key,
    required this.loading,
    this.file,
    required this.onPressedDelete,
    required this.drawPath,
  }) : super(key: key);

  @override
  State<JournalPaintWidget> createState() => _JournalPaintWidgetState();
}

class _JournalPaintWidgetState extends State<JournalPaintWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            color: whiteColor,
            height: 300,
            width: Get.width,
            child: (widget.loading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : widget.file != null
                    ? Image.file(
                        widget.file!,
                        fit: BoxFit.fill,
                      )
                    : Image.network(
                        widget.drawPath,
                        fit: BoxFit.fill,
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            height: 300,
            width: Get.width,
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => widget.onPressedDelete(),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    color: isDark ? Colors.white : whiteColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
