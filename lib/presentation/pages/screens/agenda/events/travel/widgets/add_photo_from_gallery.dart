import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/add_photo_button.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/chosen_photo.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:photo_gallery/photo_gallery.dart';

class AddPhotoFromGallery extends StatefulWidget {
  final Color color;
  final Function(List<Medium>) setPhotos;

  const AddPhotoFromGallery({
    Key? key,
    required this.color,
    required this.setPhotos,
  }) : super(key: key);

  @override
  State<AddPhotoFromGallery> createState() => _AddPhotoFromGalleryState();
}

class _AddPhotoFromGalleryState extends State<AddPhotoFromGallery> {
  List<Medium> _chosenMedia = [];

  void _setSelectedPhotos(List<Medium> newMedia) {
    setState(() {
      _chosenMedia = newMedia;
    });
    widget.setPhotos(newMedia);
  }

  void _removePhoto(Medium medium) {
    setState(() {
      _chosenMedia.remove(medium);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = (((MediaQuery.of(context).size.width - 60) / 3) * 2) + 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          addPhotoFromGallery.tr,
          style: customTextStyle(
            fontSize: 15.sp,
            color:
                Theme.of(context).textTheme.bodyLarge?.color ?? blackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        _chosenMedia.isEmpty
            ? AddPhotoButton(
                color: widget.color,
                onSelectedPhotos: _setSelectedPhotos,
                selectedPhotos: _chosenMedia,
              )
            : SizedBox(
                height: size,
                child: GridView.builder(
                  itemCount: _chosenMedia.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, index) {
                    final actualIndex = index - 1;
                    if (index == 0) {
                      return AddPhotoButton(
                        color: widget.color,
                        onSelectedPhotos: _setSelectedPhotos,
                        selectedPhotos: _chosenMedia,
                      );
                    }
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: ChosenPhoto(
                            mediumId: _chosenMedia[actualIndex].id,
                            mediumType: _chosenMedia[actualIndex].mediumType,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              _removePhoto(_chosenMedia[actualIndex]);
                            },
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: const Center(
                                child: Icon(
                                  CupertinoIcons.xmark,
                                  color: whiteColor,
                                  size: 10,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
      ],
    );
  }
}
