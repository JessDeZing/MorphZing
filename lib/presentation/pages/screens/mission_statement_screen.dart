import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionStatementScreen extends StatefulWidget {
  const MissionStatementScreen({Key? key}) : super(key: key);

  @override
  State<MissionStatementScreen> createState() => _MissionStatementScreenState();
}

class _MissionStatementScreenState extends State<MissionStatementScreen> {
  final box = GetStorage();
  Future<void> _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar:
            StaticAppBar.subHomeAppBar(context, missionStatement.tr, false, ''),
        body: SizedBox(
          // height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Text(
                    ourMission.tr,
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 20,
                      color: isDark ? Colors.white : blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Text(
                    ourMissionDescription.tr,
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 18,
                      color: isDark ? Colors.white : greyTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Text(
                    balanceEnergyHopeEarth.tr,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 20,
                      color: blueColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  // height: 100,
                  child: Center(
                    child: Image(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        "assets/icons/app_icon_in_blue.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    top: 30,
                    bottom: 20,
                  ),
                  child: Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/world_changers_landing.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 80, bottom: 8),
                  child: Text(
                    'You are changing the world!',
                    style: TextStyle(
                      color: isDark ? Colors.white : blackTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                      fontSize: 34,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                  child: Text(
                    'Your membership helps to support the following foundations:',
                    style: TextStyle(
                      color: isDark ? Colors.white : hintTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(
                    'Thank you! You make a difference!',
                    style: TextStyle(
                      color: isDark ? Colors.white : hintTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage('assets/icons/world_reload.png'),
                        height: 80,
                        width: 80,
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                  child: GestureDetector(
                    onTap: () {
                      _launchUrl('https://carbon180.org/');
                    },
                    child: Text(
                      'https://carbon180.org',
                      style: TextStyle(
                        color: isDark ? Colors.white : blackTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage('assets/icons/behind.png'),
                        height: 60,
                        width: 130,
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                  child: GestureDetector(
                    onTap: () {
                      _launchUrl('https://puppiesbehindbars.com/');
                    },
                    child: Text(
                      'https://puppiesbehindbars.com/',
                      style: TextStyle(
                        color: isDark ? Colors.white : blackTextColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
