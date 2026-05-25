import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/presentation/bottom_picker/note/all_folder_bottom/all_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/bottom_picker/note/create_folder_bottom/create_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/bottom_picker/note/move_foder_bottom/move_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/all_journal/all_journal_controller.dart';
import 'package:morphzing/presentation/pages/screens/note/all_note/all_note_controller.dart';
import 'package:morphzing/presentation/pages/screens/note/my_note/my_note_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_dialog.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/presentation/widgets/journal/journal_item.dart';
import 'package:morphzing/presentation/widgets/note_item.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class MyNoteScreen extends StatelessWidget {
  const MyNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<MyNoteController>(
        init: MyNoteController(),
        builder: (controller) {
          return Obx(() {
            return WillPopScope(
              onWillPop: () async {
                Get.back(result: controller.isUpdated);
                return false;
              },
              child: Scaffold(
                backgroundColor: isDark ? darkBgColor : whiteColor,
                appBar: controller.isChecking
                    ? AppBar(
                        elevation: 5,
                        shadowColor: Colors.black26,
                        leading: TextButton(
                          onPressed: () {
                            controller.onCancel();
                          },
                          child: Text('Cancel'),
                        ),
                        leadingWidth: 100,
                        backgroundColor: isDark ? darkBgColor : bgColor,
                        centerTitle: true,
                        title: Text(
                          (Get.arguments as Folder).name ?? '',
                          style: TextStyle(
                            color: isDark ? whiteColor : blackTextColor,
                            fontFamily: 'SF Pro Display',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              controller.onSelectAll();
                            },
                            child: Text('Select all'),
                          )
                        ],
                      )
                    : StaticAppBar.searchAppBar(
                        context,
                        (Get.arguments as Folder).name ?? '',
                        false,
                        "",
                        onPressedBack: () {
                          Get.back(result: controller.isUpdated);
                        },
                      ),
                body: SafeArea(
                  child: Obx(() {
                    if (controller.rxStatus.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (controller.rxStatus.isError) {
                      return Center(
                        child:
                            Text(controller.rxStatus.errorMessage.toString()),
                      );
                    }

                    if (controller.rxStatus.isSuccess) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.response.length} note',
                                  style: TextStyle(
                                    color: isDark ? whiteColor : greyTextColor,
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  (Get.arguments as Folder).name ?? '',
                                  style: TextStyle(
                                    color: isDark ? whiteColor : blackTextColor,
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                                childAspectRatio: 0.8,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              itemCount: controller.response.length,
                              itemBuilder: (context, index) {
                                final note = controller.response[index];

                                return LongPressDraggable<int>(
                                  key: ValueKey('note_${note.id ?? index}'),
                                  data: index,
                                  delay: const Duration(milliseconds: 500),
                                  feedback: Material(
                                    elevation: 8.0,
                                    child: Container(
                                      width: 150,
                                      height: 180,
                                      child: NoteItem(
                                        note: note,
                                        onPressed: () {},
                                        onLongPressed: () {},
                                        onDoublePressed: () {
                                          print('double pressed');
                                        },
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.5,
                                    child: NoteItem(
                                      note: note,
                                      onPressed: () {},
                                      onLongPressed: () {},
                                      onDoublePressed: () {
                                        print('double pressed');
                                      },
                                    ),
                                  ),
                                  child: DragTarget<int>(
                                    builder:
                                        (context, candidateData, rejectedData) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: candidateData.isNotEmpty
                                              ? Border.all(
                                                  color: Colors.blue,
                                                  width: 2.0)
                                              : null,
                                        ),
                                        child: NoteItem(
                                          note: note,
                                          onPressed: () {
                                            if (controller.isChecking) {
                                              controller
                                                  .onChangeNoteChecked(index);
                                            } else {
                                              controller
                                                  .openUpdateNoteScreen(note);
                                            }
                                          },
                                          onLongPressed: () {
                                            controller.isChecking = true;
                                            controller
                                                .onChangeNoteChecked(index);
                                          },
                                          onDoublePressed: () {
                                            print('double pressed');
                                          },
                                        ),
                                      );
                                    },
                                    onAccept: (draggedIndex) {
                                      print(
                                          'My Note - Drop accepted: $draggedIndex -> $index');
                                      if (draggedIndex != index) {
                                        controller.reorderNotes(
                                            draggedIndex, index);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          if (controller.isChecking)
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isDark ? darkBgColor : borderColor,
                                      foregroundColor:
                                          isDark ? whiteColor : blackTextColor,
                                    ),
                                    onPressed: controller.isValidate()
                                        ? () {
                                            LoadingOverlay.show(context);
                                            controller.removeFromFolder();
                                          }
                                        : null,
                                    child: Text('Remove from folder'),
                                  ),
                                ),
                                8.verticalSpace,
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: ElevatedButton(
                                    onPressed: controller.isValidate()
                                        ? () {
                                            controller
                                                .openMoveFolderBottom(context);
                                          }
                                        : null,
                                    child: Text('Move to Folder'),
                                  ),
                                )
                              ],
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
              ),
            );
          });
        });
  }
}
