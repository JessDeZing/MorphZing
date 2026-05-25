import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morphzing/utils/style/colors.dart';

class SingleImage extends StatelessWidget {
  final Widget image;
  final void Function()? onDelete;
  const SingleImage({Key? key, required this.image, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset('assets/icons/premium.svg')),
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
                    return _showBottomSheet(context);
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
        child: Center(child: image),
      ),
    );
  }

  Widget _showBottomSheet(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 206,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Options",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF050A41),
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
                child: const ListTile(
                  leading: Icon(
                    Icons.ios_share,
                    color: Color(0xFF050A41),
                  ),
                  title: Text(
                    "Share",
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
              onPressed: onDelete,
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
                    "Delete photo",
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
