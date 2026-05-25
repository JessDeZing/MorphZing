import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphzing/utils/style/colors.dart';

class PhotoBottomPicker extends StatelessWidget {
  final VoidCallback onAddPhotoPressed;
  final VoidCallback onDeletePhotoPressed;

  const PhotoBottomPicker({
    super.key,
    required this.onAddPhotoPressed,
    required this.onDeletePhotoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      child: SafeArea(
        child: Container(
          height: 150,
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
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => onDeletePhotoPressed(),
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
      ),
    );
  }
}
