import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/presentation/bottom_picker/note/all_folder_bottom/all_folder_bottom_controller.dart';
import 'package:morphzing/presentation/bottom_picker/note/create_folder_bottom/create_folder_bottom_controller.dart';
import 'package:morphzing/presentation/bottom_picker/note/move_foder_bottom/move_folder_bottom_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/uploaded_pictures.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/bottom_sheet_bottom_buttons.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class MoveFolderBottomSheet extends StatefulWidget {
  final List<Note> list;
  final Folder? folder;

  static Future show({
    required BuildContext context,
    required List<Note> list,
    Folder? folder,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => MoveFolderBottomSheet(
          list: list,
          folder: folder,
        ),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      );

  const MoveFolderBottomSheet({Key? key, required this.list, this.folder})
      : super(key: key);

  @override
  State<MoveFolderBottomSheet> createState() => _MoveFolderBottomSheetState();
}

class _MoveFolderBottomSheetState extends State<MoveFolderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<MoveFolderBottomController>(
      init: MoveFolderBottomController(widget.folder),
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
              child: Obx(() {
                if (controller.loading.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.loading.isError) {
                  return Center(
                      child: Text(controller.loading.errorMessage.toString()));
                }

                if (controller.loading.isSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Move to folder',
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
                                color: isDark ? darkGreyButton : bgColor,
                              ),
                              child: const Icon(
                                CupertinoIcons.clear,
                                color: hintTextColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (!controller.response.isLastPage() &&
                                index == controller.response.data.length) {
                              if (controller.loading.isLoadingMore) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                controller.getPaginationFolderList();
                                return SizedBox.shrink();
                              }
                            }

                            Folder folder = controller.response.data[index];

                            return Material(
                              color: isDark ? darkGreyButton : bgColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                onTap: () {
                                  controller.onChecked(folder);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: folder.isChecked,
                                          onChanged: (value) {
                                            controller.onChecked(folder);
                                          },
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                      8.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          controller
                                                  .response.data[index].name ??
                                              '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(folder.getNoteCountLabel(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? whiteColor
                                                : greyTextColor,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 8);
                          },
                          itemCount: controller.response.isLastPage()
                              ? controller.response.data.length
                              : controller.response.data.length + 1,
                        ),
                      ),
                      Obx(() {
                        return ElevatedButton(
                          onPressed: controller.isValidate()
                              ? () {
                                  LoadingOverlay.show(context);
                                  controller.onSave(widget.list);
                                }
                              : null,
                          child: Text('Save'),
                        );
                      }),
                    ],
                  );
                }

                return const SizedBox();
              }),
            ),
          ),
        );
      },
    );
  }
}
