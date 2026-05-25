import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class JournalInfoWidget extends StatefulWidget {
  final String title;
  final String desc;
  final Function(String value) onChangeTitle;
  final Function(String value) onChangeDescription;

  const JournalInfoWidget({
    Key? key,
    required this.onChangeTitle,
    required this.onChangeDescription,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  State<JournalInfoWidget> createState() => _JournalInfoWidgetState();
}

class _JournalInfoWidgetState extends State<JournalInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: isDark
                ? null
                : Border.all(
                    width: 1,
                    color: greyTextColor.withOpacity(0.3),
                  ),
            color: isDark
                ? Colors.black.withOpacity(0.7)
                : whiteColor.withOpacity(0.7),
          ),
          child: TextFormField(
            initialValue: widget.title,
            onChanged: (e) {
              widget.onChangeTitle(e);
            },
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: titleName.tr,
              filled: false,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            style: staticTextStyle(
              24,
              isDark ? whiteColor : blackTextColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: isDark
                ? null
                : Border.all(
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),
            color: isDark
                ? Colors.black.withOpacity(0.7)
                : (Theme.of(context).cardTheme.color?.withOpacity(0.7) ??
                    whiteColor.withOpacity(0.7)),
          ),
          width: Get.width,
          height: screenHeight * 0.6, // Adjust the height percentage as needed
          child: TextFormField(
            initialValue: widget.desc,
            maxLines: 50,
            onChanged: (e) {
              widget.onChangeDescription(e);
            },
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: descriptions.tr,
              filled: false,
            ),
            style: staticTextStyle(
              16,
              isDark ? Colors.white : blackTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
