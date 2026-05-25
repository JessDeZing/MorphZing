import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/bottom_picker/note/all_folder_bottom/all_folder_bottom_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class AllFolderBottomSheet extends StatefulWidget {
  static Future show({required BuildContext context}) => showModalBottomSheet(
        context: context,
        builder: (_) => AllFolderBottomSheet(),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      );

  const AllFolderBottomSheet({Key? key}) : super(key: key);

  @override
  State<AllFolderBottomSheet> createState() => _AllFolderBottomSheetState();
}

class _AllFolderBottomSheetState extends State<AllFolderBottomSheet> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<AllFolderBottomController>(
      init: AllFolderBottomController(),
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
                            'Note Folders',
                            style: TextStyle(
                              fontSize: 20,
                              color: isDark ? whiteColor : blackTextColor,
                              fontWeight: FontWeight.w600,
                            ),
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
                                  // DropdownMenuItem(
                                  //     value: 'date', child: Text('Date')),
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
                          GestureDetector(
                            onTap: () => Get.back(result: controller.isUpdated),
                            child: Container(
                              height: 40.w,
                              width: 40.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: isDark ? darkGreyButton : bgColor,
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
                      Text(
                        swipeToLeftToDelete.tr,
                        style: TextStyle(
                          color: isDark ? whiteColor : greyTextColor,
                          fontFamily: 'SF Pro Display',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          itemBuilder: (context, index) {
                            if (!controller.response.isLastPage() &&
                                index == controller.filteredFolders.length) {
                              if (controller.loading.isLoadingMore) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                controller.getPaginationFolderList();
                                return SizedBox.shrink();
                              }
                            }

                            Folder folder = controller.filteredFolders[index];

                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      LoadingOverlay.show(context);
                                      controller.deleteFolder(
                                          controller.response.data[index]);
                                    },
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    backgroundColor: todayColor,
                                    foregroundColor:
                                        isDark ? darkBgColor : whiteColor,
                                    //icon: Icons.delete,
                                    label: delete.tr,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.openMyFolder(folder);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: isDark ? darkGreyButton : bgColor),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(folder.name ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: isDark
                                                  ? whiteColor
                                                  : blackTextColor,
                                              fontWeight: FontWeight.w600,
                                            )),
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
                              ? controller.filteredFolders.length
                              : controller.filteredFolders.length + 1,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.addFolder(context);
                        },
                        child: Text('Add Folder'),
                      ),
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
