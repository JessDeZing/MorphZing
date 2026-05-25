import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/logic/controllers/journal/journey_controller.dart';
import 'package:morphzing/presentation/pages/screens/journal/image_list_view_screen.dart';
import 'package:morphzing/utils/style/colors.dart';

class MultipleImageViewWidget extends StatelessWidget {
  final List<Photo> photos;
  final Function()? onMore;
  final VoidCallback onPressed;
  final bool isPost;

  const MultipleImageViewWidget({
    Key? key,
    required this.photos,
    required this.onMore,
    required this.onPressed,
    this.isPost = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Column(
        children: [
          if (photos.length == 1)
            SizedBox(
              height: 250,
              width: Get.width,
              child: Stack(
                children: [
                  Container(
                    height: 250,
                    width: Get.width,
                    decoration: _getBoxDecoration(photos[0]),
                  ),
                  if (!isPost) ...{
                    Container(
                      height: 200,
                      width: Get.width,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: onMore,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.more_vert,
                              color: isDark ? Colors.white : whiteColor,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  }
                ],
              ),
            ),
          if (photos.length == 2)
            SizedBox(
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
                        _getImage(photos[0]),
                        if (!isPost) ...{
                          Container(
                            height: 200,
                            width: Get.width,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: onMore,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: isDark ? Colors.white : whiteColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        }
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: _getImage(photos[1]),
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
            ),
          if (photos.length == 3)
            SizedBox(
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
                          child: _getImage(photos[0]),
                        ),
                        if (!isPost) ...{
                          Container(
                            height: 200,
                            width: Get.width,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: onMore,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: isDark ? Colors.white : whiteColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        }
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
                          child: _getImage(photos[1]),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: _getImage(photos[2]),
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
            ),
          if (photos.length == 4)
            SizedBox(
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
                          child: _getImage(photos[0]),
                        ),
                        if (!isPost) ...{
                          Container(
                            height: 200,
                            width: Get.width,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: onMore,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: isDark ? Colors.white : whiteColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        }
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
                          child: _getImage(photos[1]),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: _getImage(photos[2]),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: _getImage(photos[3]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (photos.length > 4)
            SizedBox(
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
                          child: _getImage(photos[0]),
                        ),
                        if (!isPost) ...{
                          Container(
                            height: 200,
                            width: Get.width,
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: onMore,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: isDark ? Colors.white : whiteColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        }
                      ],
                    ),
                  ),
                  8.verticalSpace,
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: _getImage(photos[1]),
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: _getImage(photos[2]),
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                            child: Stack(
                          children: [
                            SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: _getImage(photos[3]),
                            ),
                            Container(
                              height: 120,
                              color: Colors.black.withOpacity(0.3),
                              child: Center(
                                child: Text(
                                  '+${photos.length - 4}',
                                  style: staticTextStyle(
                                    22,
                                    isDark ? Colors.white : whiteColor,
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
            ),
        ],
      ),
    );
  }

  BoxDecoration _getBoxDecoration(Photo photo) {
    return BoxDecoration(
      image: photo.file != null
          ? DecorationImage(
              image: FileImage(photo.file!),
              fit: BoxFit.cover,
            )
          : DecorationImage(
              image: NetworkImage(photo.imageUrl!),
              fit: BoxFit.cover,
            ),
    );
  }

  Image _getImage(Photo photo) {
    if (photo.file != null) {
      return Image.file(
        photo.file!,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      photo.imageUrl!,
      fit: BoxFit.cover,
    );
  }
}
