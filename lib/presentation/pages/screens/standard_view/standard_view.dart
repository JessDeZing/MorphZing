import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class StandardView extends StatelessWidget {
  final String imageUrl;

  const StandardView({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? darkBgColor : whiteColor,
      appBar: AppBar(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        elevation: 5,
        shadowColor: Colors.black26,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : blackTextColor,
          ),
        ),
        title: Text(
          standardView.tr,
          style: customTextStyle(
            fontSize: 18,
            color: isDark ? Colors.white : blackTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        toolbarHeight: 64,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 5, 24, 5),
            decoration: BoxDecoration(
              color: isDark ? darkBgColor : whiteColor,
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hourMinute.tr,
                      style: customTextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : greyTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      monthDayYear.tr,
                      style: customTextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : blackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/icons/task_month.svg',
                  color: blueColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FadeInImage(
                    fadeInDuration: 100.milliseconds,
                    fadeOutDuration: 100.milliseconds,
                    fit: BoxFit.cover,
                    placeholderFit: BoxFit.cover,
                    placeholder:
                        const AssetImage("assets/images/placeholder_photo.jpg"),
                    image: NetworkImage(imageUrl),
                    //image: AssetImage('assets/images/25721.jpeg'),
                    imageErrorBuilder: (_, __, ___) => Image.asset(
                      "assets/images/placeholder_photo.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        color:
                            isDark ? darkBgColor : whiteColor.withOpacity(0.7),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            journeyTitle.tr,
                            style: customTextStyle(
                              fontSize: 22,
                              color: isDark ? Colors.white : blackTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            journeyDescription.tr,
                            style: customTextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white : blackTextColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset('assets/images/standard_view.png'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
