import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class UploadedPictures extends StatelessWidget {
  final List<String> travelPictures;

  const UploadedPictures({
    Key? key,
    required this.travelPictures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = travelPictures.length > 3
        ? (((MediaQuery.of(context).size.width - 60) / 3) * 2) + 10
        : ((MediaQuery.of(context).size.width - 60) / 3) + 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          pictures.tr,
          style: customTextStyle(
            fontSize: 15.sp,
            color: blackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        travelPictures.isEmpty
            ? Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                ),
                child: Text(
                  noPicturesAdded.tr,
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : SizedBox(
                height: size,
                child: GridView.builder(
                  itemCount: travelPictures.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  physics: travelPictures.length > 3
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fadeOutDuration: const Duration(milliseconds: 100),
                        placeholder: const AssetImage(
                            "assets/images/placeholder_photo.jpg"),
                        image: NetworkImage(travelPictures[index]),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
