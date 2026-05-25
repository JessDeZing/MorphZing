import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/logic/controllers/journal/journal_controller.dart';
import 'package:morphzing/presentation/pages/screens/journal/all_image_list_view_screen.dart';
import 'package:morphzing/utils/style/colors.dart';

class MultipleAllImagesWidget extends StatefulWidget {
  final Function()? onMore;
  final int index;
  const MultipleAllImagesWidget({
    Key? key,
    required this.onMore,
    required this.index,
  }) : super(key: key);

  @override
  State<MultipleAllImagesWidget> createState() =>
      _MultipleImageViewWidgetState();
}

class _MultipleImageViewWidgetState extends State<MultipleAllImagesWidget> {
  final journalController = Get.find<JournalController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(AllImageListViewScreen(
            images: journalController.model.value[widget.index].images ?? []));
      },
      child: Obx(() {
        if (journalController.model.value[widget.index].images?.length == 1) {
          return SizedBox(
            height: 250,
            width: Get.width,
            child: Stack(
              children: [
                Container(
                  height: 250,
                  width: Get.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        journalController.model.value[widget.index].images?[0]
                                .imageUrl ??
                            "",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (journalController.model.value[widget.index].images?.length ==
            2) {
          return SizedBox(
            height: 420,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  width: Get.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        journalController.model.value[widget.index].images?[0]
                                .imageUrl ??
                            "",
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          journalController.model.value[widget.index].images?[1]
                                  .imageUrl ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Container()),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (journalController.model.value[widget.index].images?.length ==
            3) {
          return SizedBox(
            height: 420,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  width: Get.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 250,
                        width: Get.width,
                        child: Image.network(
                            journalController.model.value[widget.index]
                                    .images?[0].imageUrl ??
                                "",
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      Expanded(
                          child: Image.network(
                        journalController.model.value[widget.index].images?[1]
                                .imageUrl ??
                            "",
                        fit: BoxFit.cover,
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Image.network(
                          journalController.model.value[widget.index].images?[2]
                                  .imageUrl ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (journalController.model.value[widget.index].images?.length ==
            4) {
          return SizedBox(
            height: 420,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  width: Get.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 250,
                        width: Get.width,
                        child: Image.network(
                          journalController.model.value[widget.index].images?[0]
                                  .imageUrl ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      Expanded(
                        child: Image.network(
                          journalController.model.value[widget.index].images?[1]
                                  .imageUrl ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Image.network(
                          journalController.model.value[widget.index].images?[2]
                                  .imageUrl ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Image.network(
                          journalController.model.value[widget.index].images?[3]
                                  .imageUrl ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if ((journalController
                    .model.value[widget.index].images?.length ??
                0) >
            4) {
          return SizedBox(
            height: 420,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  width: Get.width,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 250,
                        width: Get.width,
                        child: Image.network(
                          journalController.model.value[widget.index].images?[0]
                                  .imageUrl ??
                              "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: Image.network(
                            journalController.model.value[widget.index]
                                    .images?[1].imageUrl ??
                                "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 120,
                          child: Image.network(
                            journalController.model.value[widget.index]
                                    .images?[2].imageUrl ??
                                "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Stack(
                        children: [
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Image.network(
                              journalController.model.value[widget.index]
                                      .images?[3].imageUrl ??
                                  "",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            height: 120,
                            color: Colors.black.withOpacity(0.3),
                            child: Center(
                              child: Text(
                                '+${(journalController.model.value[widget.index].images?.length ?? 0) - 4}',
                                style: staticTextStyle(
                                  22,
                                  whiteColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      }),
    );
  }
}
