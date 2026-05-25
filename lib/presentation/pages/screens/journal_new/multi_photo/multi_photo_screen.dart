import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/multi_photo/multi_photo_controller.dart';
import 'package:morphzing/utils/style/colors.dart';

class MultiPhotoScreen extends StatefulWidget {
  const MultiPhotoScreen({Key? key}) : super(key: key);

  @override
  State<MultiPhotoScreen> createState() => _ImageListViewScreenState();
}

class _ImageListViewScreenState extends State<MultiPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MultiPhotoController>(
      init: MultiPhotoController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.onPressedBack();
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  controller.onPressedBack();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: blackTextColor,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: SizedBox(height: 30, width: 30, child: SvgPicture.asset('assets/icons/premium.svg')),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
              backgroundColor: bgColor,
              centerTitle: true,
              title: Text(
                photos.tr,
                style: TextStyle(
                  color: blackTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: .8,
              ),
              itemCount: controller.photoList.length,
              itemBuilder: (context, index) {
                return CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => controller.openSinglePhotoScreen(controller.photoList[index]),
                  child: Container(
                    decoration: _getBoxDecoration(controller.photoList[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
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
}
