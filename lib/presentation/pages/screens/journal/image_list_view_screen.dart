import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/logic/controllers/journal/journey_controller.dart';
import 'package:morphzing/presentation/pages/screens/journal/single_image.dart';

import '../../../../utils/style/colors.dart';

class ImageListViewScreen extends StatefulWidget {
  const ImageListViewScreen({Key? key}) : super(key: key);

  @override
  State<ImageListViewScreen> createState() => _ImageListViewScreenState();
}

class _ImageListViewScreenState extends State<ImageListViewScreen> {
  JourneyController journeyController = Get.put(JourneyController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? whiteColor : blackTextColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Center(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset('assets/icons/premium.svg')),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // GestureDetector(
          //   onTap: () {},
          //   child: Center(
          //       child: IconButton(
          //     onPressed: () {
          //       showModalBottomSheet(
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10.0),
          //         ),
          //         context: context,
          //         builder: (context) {
          //           return _showMore(context);
          //         },
          //       );
          //     },
          //     icon: const Icon(
          //       Icons.more_vert,
          //       size: 26,
          //       color: blackTextColor,
          //     ),
          //   )),
          // ),
        ],
        backgroundColor: isDark ? darkBgColor : bgColor,
        centerTitle: true,
        title: Text(
          'Photos',
          style: TextStyle(
            color: isDark ? whiteColor : blackTextColor,
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
        itemCount: journeyController.photos.length,
        itemBuilder: (context, index) {
          return CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => Get.to(SingleImage(
              image: Image.file(journeyController.photos[index].file!),
              onDelete: () async {
                journeyController.photos.removeAt(index);
                Navigator.pop(context);
                Navigator.pop(context);
                if (journeyController.photos.isEmpty) {
                  Navigator.pop(context);
                }

                setState(() {});
              },
            )),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(
                      journeyController.photos[index].file!,
                    ),
                    fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _showMore(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        height: 206,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Options",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? whiteColor : Color(0xFF050A41),
              ),
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.ios_share,
                    color: isDark ? whiteColor : Color(0xFF050A41),
                  ),
                  title: Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 17,
                      color: isDark ? whiteColor : Color(0xFF050A41),
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
                journeyController.photos.clear();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Color(0xFFFF3B30),
                  ),
                  title: Text(
                    "Delete photos",
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
