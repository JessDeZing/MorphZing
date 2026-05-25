import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class UploadedImage extends StatefulWidget {
  final String? uploadedImage;
  final int? id;

  const UploadedImage({
    Key? key,
    this.uploadedImage,
    this.id,
  }) : super(key: key);

  @override
  State<UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<UploadedImage> {
  File? _image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );
      if (image == null) return;
      var imageTemporary = File(image.path);
      _image = imageTemporary;
      final croppedImage = await _cropImage(imageTemporary);
      LoadingOverlay.show(context);
      if (widget.uploadedImage != null) {
        await Get.find<HomeController>()
            .updateBannerPhoto(croppedImage ?? _image!, widget.id ?? 0);
      } else {
        await Get.find<HomeController>().uploadPhoto(croppedImage ?? _image!);
      }
      setState(() {
        _image = croppedImage;
      });
      await Get.find<HomeController>().getBannerImage();
      LoadingOverlay.hide();
    } on Object catch (e) {
      showErrorSnackBar(
          message: 'Failed to retrieve chosen photo with ${e.toString()}');
    }
  }

  Future<File?> _cropImage(File _chosenFile) async {
    final CroppedFile? crop = await ImageCropper().cropImage(
      sourcePath: _chosenFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
          resetButtonHidden: true,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
          resetAspectRatioEnabled: true,
          aspectRatioLockEnabled: true,
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );
    if (crop != null) {
      File croppedFile = File(crop.path);
      return croppedFile;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print('size ${((MediaQuery.of(context).size.width - 32) * 9) / 16} - ${(MediaQuery.of(context).size.width - 32)}');
    return GestureDetector(
      onTap: () async => await pickImage(),
      child: Container(
        height: ((MediaQuery.of(context).size.width - 32) * 9) / 16,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: widget.uploadedImage != null || _image != null
              ? const Border.fromBorderSide(BorderSide.none)
              : Border.all(color: dividerColor),
          borderRadius: BorderRadius.circular(10),
          color: bgColor,
        ),
        child: widget.uploadedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/no_gallery_photo.svg'),
                  const SizedBox(height: 8),
                  Text(
                    'Select a photo from the Gallery',
                    style: customTextStyle(
                      fontSize: 14,
                      color: greyTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )
            : _image == null
                ? FadeInImage(
                    fadeInDuration: 100.milliseconds,
                    fadeOutDuration: 100.milliseconds,
                    fit: BoxFit.fill,
                    placeholderFit: BoxFit.cover,
                    placeholder:
                        const AssetImage("assets/images/placeholder_photo.jpg"),
                    image: NetworkImage(widget.uploadedImage ?? ''),
                    //image: AssetImage('assets/images/25721.jpeg'),
                    imageErrorBuilder: (_, __, ___) => Image.asset(
                      "assets/images/placeholder_photo.jpg",
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.file(
                    _image!,
                    fit: BoxFit.fill,
                  ),
      ),
    );
  }
}
