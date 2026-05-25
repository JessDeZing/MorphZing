import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class WebLinkBottomSheet extends StatefulWidget {
  final String title;
  final String icon;
  final String value;
  final bool isUrl;

  const WebLinkBottomSheet({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.isUrl,
  });

  @override
  State<WebLinkBottomSheet> createState() => _WebLinkBottomSheetState();
}

class _WebLinkBottomSheetState extends State<WebLinkBottomSheet> {
  late String value = widget.value;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                initialValue: widget.value,
                onChanged: (val) {
                  if (widget.isUrl) {
                    value = checkIfUrlContainPrefixHttp(val);
                  } else {
                    value = val;
                  }
                },
                cursorColor:
                    Theme.of(context).inputDecorationTheme.hintStyle?.color ??
                        const Color(0xFF676A8B),
                decoration: InputDecoration(
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Image.asset(
                      widget.icon,
                      color: Theme.of(context).iconTheme.color ??
                          const Color(0xFF676A8B),
                      height: 18,
                    ),
                  ),
                  hintText: widget.title,
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                            .inputDecorationTheme
                            .hintStyle
                            ?.color ??
                        const Color(0xFF676A8B),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.topLeft,
              width: Get.width,
              color: Theme.of(context).cardColor,
              child: SizedBox(
                height: 56,
                width: Get.width,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(result: ''),
                      child: const SizedBox(
                        width: 90,
                        height: 56,
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: todayColor,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (value.isNotEmpty) {
                            if (value.isURL) {
                              bool _validURL = Uri.parse(value).isAbsolute;
                              if (_validURL) {
                                Get.back(result: value);
                              } else {
                                showErrorSnackBar(message: 'Url not valid');
                              }
                            } else {
                              Get.back(result: value);
                            }
                          }
                        },
                        child: Container(
                          color: blueColor,
                          child: const Center(
                              child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 26,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String checkIfUrlContainPrefixHttp(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      return 'https://' + url;
    }
  }
}
