import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/single_photo/single_photo_controller.dart';
import 'package:morphzing/utils/style/colors.dart';

class SinglePhotoScreen extends StatelessWidget {
  const SinglePhotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SinglePhotoController>(
      init: SinglePhotoController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
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
              GestureDetector(
                onTap: () {},
                child: Center(
                    child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      context: context,
                      builder: (context) {
                        return _showBottomSheet(context, controller);
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    size: 26,
                    color: blackTextColor,
                  ),
                )),
              ),
            ],
            backgroundColor: bgColor,
            centerTitle: true,
            title: const Text(
              'Photo',
              style: TextStyle(
                color: blackTextColor,
                fontFamily: 'SF Pro Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(child: _getImage(controller.photo)),
          ),
        );
      },
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

  Widget _showBottomSheet(BuildContext context, SinglePhotoController controller) {
    return SafeArea(
      child: Container(
        height: 206,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              options.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF050A41),
              ),
            ),
            const SizedBox(height: 20),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                controller.shareFile();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.ios_share,
                    color: Color(0xFF050A41),
                  ),
                  title: Text(
                    share.tr,
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF050A41),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Get.back();
                Get.back(result: true);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Color(0xFFFF3B30),
                  ),
                  title: Text(
                    deletePhoto.tr,
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFF3B30),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
