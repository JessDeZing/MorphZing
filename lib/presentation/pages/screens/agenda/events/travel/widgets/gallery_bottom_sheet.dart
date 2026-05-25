import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/grid_view_child_photo.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';

class GalleryBottomSheet extends StatefulWidget {
  final Color color;
  final List<Medium> selectedPhotos;

  const GalleryBottomSheet({
    Key? key,
    required this.color,
    required this.selectedPhotos,
  }) : super(key: key);

  @override
  State<GalleryBottomSheet> createState() => _GalleryBottomSheetState();

  static Future show({
    required BuildContext context,
    required Color color,
    required List<Medium> selectedPhotos,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
        builder: (_) => GalleryBottomSheet(
          color: color,
          selectedPhotos: selectedPhotos,
        ),
      );
}

class _GalleryBottomSheetState extends State<GalleryBottomSheet> {
  bool _showOpenSettings = false;
  bool _loading = true;
  late int limit;

  Album? _album;

  List<Medium> _media = [];
  List<Medium> _chosenMedia = [];

  final ScrollController scrollController = ScrollController();

  int skip = 50;
  bool loadMore = false;
  bool stopLoading = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      switch (Get.find<AppController>().user?.paymentStatus) {
        case SubscriptionType.free:
          limit = 5;
          break;
        case SubscriptionType.basic:
          limit = 25;
          break;
        case SubscriptionType.premium:
        case SubscriptionType.familyShare:
          limit = 50;
          break;
        default:
          limit = 5;
          break;
      }
      setState(() {
        _chosenMedia = widget.selectedPhotos;
      });
      await initAsync();
    });

    scrollController.addListener(() => _loadMore());
  }

  void _choosePhotoToUpload(Medium medium) {
    if (_chosenMedia.length >= limit && !_chosenMedia.contains(medium)) {
      showAttentionSnackBar(
          message: '${onlyUpTo.tr} $limit ${photosAreAllowed.tr}');
      return;
    }
    if (_chosenMedia.contains(medium)) {
      _chosenMedia.remove(medium);
    } else {
      _chosenMedia.add(medium);
    }
    setState(() {});
  }

  void _loadMore() async {
    if (scrollController.position.extentAfter < 300 &&
        loadMore == false &&
        !stopLoading) {
      late MediaPage mediaPage;

      setState(() {
        loadMore = true;
      });
      if (skip + 50 <= _album!.count) {
        mediaPage = await _album!.listMedia(take: 50, skip: skip);
      } else {
        mediaPage = await _album!.listMedia(
            take: _album!.count - skip,
            skip: _album!.count - (_album!.count - skip));
        setState(() {
          stopLoading = true;
        });
      }
      log("Here is mediaPage ${mediaPage.items.length}");
      setState(() {
        skip = skip + 50;

        _media.addAll(mediaPage.items);
        log("Here is media length ${_media.length}");
        loadMore = false;
      });
    }
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);

      try {
        _album = albums[0];
        MediaPage mediaPage = await _album!
            .listMedia(take: _album!.count > 50 ? 50 : _album!.count);

        _media = mediaPage.items;
      } catch (e) {
        debugPrint(
            'error occurred inside gallery_bottom_sheet.dart ${e.toString()}');
      }
    }

    _loading = false;

    setState(() {});
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            (await Permission.storage.request().isGranted &&
                await Permission.photos.request().isGranted) ||
        (await Permission.photos.request().isLimited) ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    setState(() {
      _showOpenSettings = true;
    });
    return false;
  }

  @override
  void dispose() {
    scrollController.removeListener(_loadMore);
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: _showOpenSettings
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    permissionToGallery.tr,
                    textAlign: TextAlign.center,
                    style: customTextStyle(
                      fontSize: 16.sp,
                      color: greyTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  PrimaryButton(
                    buttonColor: travelColor,
                    buttonText: openSettings.tr,
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Positioned(
                  top: 30.h,
                  left: 20.w,
                  child: Text(
                    gallery.tr,
                    style: customTextStyle(
                      fontSize: 17.sp,
                      color: blackTextColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  top: 84.h,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : Column(
                          children: [
                            Expanded(
                              child: GridView.builder(
                                controller: scrollController,
                                itemCount: _media.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (_, index) => GestureDetector(
                                  onTap: () =>
                                      _choosePhotoToUpload(_media[index]),
                                  child: GridViewChildPhoto(
                                    isChosen:
                                        _chosenMedia.contains(_media[index]),
                                    mediumId: _media[index].id,
                                    mediumType: _media[index].mediumType,
                                  ),
                                ),
                              ),
                            ),
                            loadMore
                                ? const CircularProgressIndicator.adaptive()
                                : const SizedBox(),
                          ],
                        ),
                ),
                Positioned(
                  right: 10.w,
                  top: 10.h,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.w),
                        color: bgColor,
                      ),
                      child: const Icon(
                        CupertinoIcons.clear,
                        color: hintTextColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).viewPadding.bottom + 16.h,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: PrimaryButton(
                      buttonColor: widget.color,
                      onPressed: () {
                        Navigator.of(context).pop(_chosenMedia);
                      },
                      buttonText: upload.tr,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
