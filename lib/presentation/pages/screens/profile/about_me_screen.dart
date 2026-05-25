import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/style/colors.dart';
import '../../../routers/rout_names.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/default_button.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({Key? key}) : super(key: key);

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  TextEditingController nameController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: StaticAppBar.customAppBar(context, 'Sign up'),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(
            FocusNode(),
          );
        },
        child: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: isDark ? darkBgColor : whiteColor,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 14, bottom: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  child: ClipOval(
                                    child: (_image != null)
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: FileImage(_image!),
                                          )
                                        : Center(
                                            child: Text(
                                              'Na',
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SF Pro Display',
                                                fontSize: 34,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () async {
                                      await getImage();
                                    },
                                    child: Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color:
                                              isDark ? darkBgColor : bgColor),
                                      child: Center(
                                        child: (_image == null)
                                            ? SvgPicture.asset(
                                                'assets/icons/add_photo.svg',
                                                height: 20,
                                                width: 20,
                                              )
                                            : Icon(
                                                Icons.sync,
                                                color: isDark
                                                    ? Colors.white
                                                    : blackTextColor,
                                                size: 20,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'About me',
                            style: TextStyle(
                              color: isDark ? Colors.white : blackTextColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Display',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: customInput(
                            hintText: 'Bio',
                            textEditingController: nameController,
                            labelText: 'Bio'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: DefaultButton(
                    text: 'Continue',
                    route: loginRoute,
                    ctx: context,
                    arg: const {},
                  ),
                )
              ],
            )),
      ),
    );
  }

  customInput(
      {TextEditingController? textEditingController,
      String? labelText,
      String? hintText}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: TextField(
        maxLength: 300,
        controller: textEditingController,
        obscureText: false,
        maxLines: 6,
        decoration: InputDecoration(
          alignLabelWithHint: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'SF Pro Display',
              color: isDark ? Colors.white : hintTextColor),
        ),
      ),
    );
  }
}
