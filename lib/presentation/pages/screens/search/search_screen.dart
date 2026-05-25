import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/enum/search_type_enum.dart';
import 'package:morphzing/core/enum/search_type_enum.dart';
import 'package:morphzing/core/enum/search_type_enum.dart';
import 'package:morphzing/core/extension/search_type_extension.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/presentation/bottom_picker/event_info_bottom_sheet.dart';
import 'package:morphzing/presentation/bottom_picker/task_info_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/search/search_controller.dart'
    as search;
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/event_item.dart';
import 'package:morphzing/presentation/widgets/journal/journal_item.dart';
import 'package:morphzing/presentation/widgets/note_item.dart';
import 'package:morphzing/presentation/widgets/task_item.dart';
import 'package:morphzing/utils/style/colors.dart';

class SearchScreenParam {
  late final SearchTypeEnum searchTypeEnum;

  SearchScreenParam({SearchTypeEnum? searchTypeEnum}) {
    this.searchTypeEnum = searchTypeEnum ?? SearchTypeEnum.initial;
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final search.SearchController _controller = search.SearchController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<search.SearchController>(
      init: _controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: isDark ? darkBgColor : whiteColor,
          appBar: AppBar(
            elevation: 5,
            shadowColor: Colors.black26,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? Colors.white : blackTextColor,
              ),
            ),
            backgroundColor: isDark ? darkBgColor : bgColor,
            centerTitle: true,
            title: Text(
              'Search',
              style: TextStyle(
                color: isDark ? Colors.white : blackTextColor,
                fontFamily: 'SF Pro Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset('assets/icons/premium.svg')),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Obx(() {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          Text(
                            'Search the content by keywords',
                            style: TextStyle(
                              color: isDark ? Colors.white : blackTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 56,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        controller.searchTextEditingController,
                                    enabled: controller.searchTypeEnum !=
                                        SearchTypeEnum.initial,
                                    onFieldSubmitted: (value) {
                                      controller.getSearchList();
                                    },
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      labelText: 'Search',
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'SF Pro Display',
                                        color: isDark
                                            ? Colors.white
                                            : hintTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Material(
                                  color: isDark ? darkBgColor : bgColor,
                                  child: InkWell(
                                    onTap: () async {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      //await Future.delayed(Duration(milliseconds: 200));
                                      controller.openFilterBottomSheet();
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: isDark
                                              ? darkBorderColor
                                              : dividerColor,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                            'assets/icons/filter.svg',
                                            color: isDark
                                                ? Colors.white
                                                : blackTextColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  if (controller.searchTextEditingController.text.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            '''Please enter to filter and select one of the categories and start to "Search"''',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : blackTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (controller.rxStatus.isLoading)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (controller.rxStatus.isError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(controller.rxStatus.errorMessage ?? ''),
                      ),
                    ),
                  if (controller.rxStatus.isSuccess &&
                      controller.response.data.isNotEmpty)
                    controller.searchTypeEnum == SearchTypeEnum.note
                        ? SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                                mainAxisExtent: 220,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (!controller.response.isLastPage() &&
                                      index ==
                                          controller.response.data.length) {
                                    if (controller.rxStatus.isLoadingMore) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      controller.getPaginationList();
                                      return SizedBox.shrink();
                                    }
                                  }

                                  return NoteItem(
                                    note: controller.response.data[index],
                                    onPressed: () => controller.openNoteScreen(
                                        controller.response.data[index]),
                                    onLongPressed: () =>
                                        controller.openNoteScreen(
                                            controller.response.data[index]),
                                    onDoublePressed: () {},
                                  );
                                },
                                childCount: controller.response.isLastPage()
                                    ? controller.response.data.length
                                    : controller.response.data.length + 1,
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (!controller.response.isLastPage() &&
                                    index == controller.response.data.length) {
                                  if (controller.rxStatus.isLoadingMore) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    controller.getPaginationList();
                                    return SizedBox.shrink();
                                  }
                                }

                                return Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: _initSearchItem(
                                    item: controller.response.data[index],
                                    onPressedItem: () {
                                      if (controller.response.data[index]
                                          is Todo) {
                                        TaskInfoBottomSheet.show(
                                            context: context,
                                            task: controller
                                                .response.data[index]);
                                      }
                                      if (controller.response.data[index]
                                          is Event) {
                                        EventInfoBottomSheet.show(
                                            context: context,
                                            event: controller
                                                .response.data[index]);
                                      }
                                      if (controller.response.data[index]
                                          is JournalModel) {
                                        Get.toNamed(journeyRoute,
                                                arguments: controller
                                                    .response.data[index])
                                            ?.then((value) {
                                          if (value != null && value) {
                                            _controller.getJournalList();
                                          }
                                        });
                                      }
                                    },
                                  ),
                                );
                              },
                              // 40 list items
                              childCount: controller.response.isLastPage()
                                  ? controller.response.data.length
                                  : controller.response.data.length + 1,
                            ),
                          ),
                  if (controller.rxStatus.isSuccess &&
                      controller.response.data.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            '''You don't have any information under this category.''',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : blackTextColor,
                              fontFamily: 'SF Pro Display',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _initSearchItem<T>(
      {required T item, required VoidCallback onPressedItem}) {
    if (item is Todo) {
      return TaskItem(todoItem: item, onPressedItem: onPressedItem);
    }

    if (item is Event) {
      return EventItem(eventItem: item, onPressedItem: onPressedItem);
    }

    if (item is JournalModel) {
      return JournalItem(journalItem: item, onPressedItem: onPressedItem);
    }

    return const SizedBox();
  }
}
