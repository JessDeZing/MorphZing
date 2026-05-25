import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/presentation/bottom_picker/note/create_folder_bottom/create_folder_bottom_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/uploaded_pictures.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/bottom_sheet_bottom_buttons.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class CreateFolderBottomSheet extends StatefulWidget {
  static Future show({required BuildContext context}) => showModalBottomSheet(
        context: context,
        builder: (_) => CreateFolderBottomSheet(),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      );

  const CreateFolderBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateFolderBottomSheet> createState() =>
      _CreateFolderBottomSheetState();
}

class _CreateFolderBottomSheetState extends State<CreateFolderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<CreateFolderBottomController>(
      init: CreateFolderBottomController(),
      builder: (controller) {
        return Container(
          color: isDark ? darkBgColor : whiteColor,
          padding: EdgeInsets.all(10.w),
          constraints: BoxConstraints(
            maxHeight:
                (MediaQuery.of(context).size.height * 0.9).h - kToolbarHeight,
          ),
          child: Scaffold(
            backgroundColor: isDark ? darkBgColor : whiteColor,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Add new folder',
                        style: TextStyle(
                          fontSize: 20,
                          color: isDark ? whiteColor : blackTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.w),
                            color: isDark ? darkBgColor : bgColor,
                          ),
                          child: Icon(
                            CupertinoIcons.clear,
                            color: isDark ? whiteColor : hintTextColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: isDark
                              ? darkGreyButton
                              : greyTextColor.withOpacity(0.3),
                        )),
                    width: Get.width,
                    child: TextFormField(
                      onChanged: (e) {
                        controller.folderTitle = e;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Folder name',
                      ),
                      style: staticTextStyle(
                        14,
                        isDark ? whiteColor : blackTextColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isValidate()
                          ? () {
                              LoadingOverlay.show(context);
                              controller.createFolder();
                            }
                          : null,
                      child: Text('Save'),
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
