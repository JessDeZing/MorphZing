import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';

class ShortJournalWidget extends StatelessWidget {
  const ShortJournalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDark ? darkBgColor : bgColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Mon',
                    style: TextStyle(
                      color: journalDateColor,
                      fontSize: 12,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '25',
                    style: staticTextStyle(
                      14,
                      journalDateColor,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    '2:00 PM',
                    style: TextStyle(
                      color: journalDateColor,
                      fontSize: 12,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title note',
                    style: staticTextStyle(
                      14,
                      isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Nulla Lorem mollit cupidatat irure. Laborum magna nulla duis ullamco cillum dolor.',
                    style: TextStyle(
                      color: greyTextColor,
                      fontSize: 12,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://img.freepik.com/free-vector/abstract-digital-technology-background-with-network-connection-lines_1017-25552.jpg?w=1060&t=st=1666187769~exp=1666188369~hmac=2639b50eaff36a601c5d7140c2d77ea86c0c6a7af0c4f1f5c72ad90c51f4c47b'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
