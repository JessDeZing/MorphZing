import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/const_lists.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/registration/registration_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class RegistrationScreenParam {
  final String secretKey;
  final bool isSocial;
  final String? password;
  final String? phone;
  final String? email;

  RegistrationScreenParam({
    required this.secretKey,
    required this.isSocial,
    this.password,
    this.phone,
    this.email,
  });
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController controller = RegistrationController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController bioTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();

  @override
  void dispose() {
    nameTextController.dispose();
    bioTextController.dispose();
    emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<RegistrationController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: StaticAppBar.customAppBar(context, signUp.tr),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Obx(() {
                return Container(
                    padding: const EdgeInsets.all(16),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: isDark ? darkBgColor : whiteColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 30,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(Container(
                                        height: 150,
                                        color:
                                            isDark ? darkBgColor : whiteColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .pickImageFromCamera();
                                                  },
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: isDark
                                                          ? darkBgColor
                                                          : greyButton,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.camera,
                                                        size: 30,
                                                        color: isDark
                                                            ? Colors.white
                                                            : blackTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    camera.tr,
                                                    style: TextStyle(
                                                      color: isDark
                                                          ? Colors.white
                                                          : blackTextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'SF Pro Display',
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .pickImageFromGallery();
                                                  },
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: isDark
                                                          ? darkBgColor
                                                          : greyButton,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        size: 30,
                                                        color: isDark
                                                            ? Colors.white
                                                            : blackTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    gallery.tr,
                                                    style: TextStyle(
                                                      color: isDark
                                                          ? Colors.white
                                                          : blackTextColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'SF Pro Display',
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )));
                                  },
                                  child: SizedBox(
                                    height: 100,
                                    width: Get.width,
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: blueColor,
                                              image: (controller.currentImage !=
                                                      null)
                                                  ? DecorationImage(
                                                      image: FileImage(
                                                          controller
                                                              .currentImage!),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : const DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/user_avatar.png'),
                                                    ),
                                            ),
                                          ),
                                          Container(
                                            height: 100,
                                            width: 100,
                                            alignment: Alignment.bottomRight,
                                            child: Container(
                                              height: 32,
                                              width: 32,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: isDark
                                                    ? darkBgColor
                                                    : greyButton,
                                              ),
                                              child: Center(
                                                child:
                                                    (controller.currentImage !=
                                                            null)
                                                        ? Icon(
                                                            CupertinoIcons
                                                                .arrow_2_circlepath,
                                                            color: isDark
                                                                ? Colors.white
                                                                : blackTextColor,
                                                            size: 20,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .add_a_photo_outlined,
                                                            color: isDark
                                                                ? Colors.white
                                                                : blackTextColor,
                                                            size: 20,
                                                          ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      whatIsYourFio.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: customTextStyle(
                                        fontSize: 16,
                                        color: greyTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: CustomInputField(
                                  hintText: 'Enter your name',
                                  labelText: 'Enter your name',
                                  textEditingController: nameTextController,
                                  maxLength: 40,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) => controller.fio = value,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      aboutMe.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: customTextStyle(
                                        fontSize: 16,
                                        color: greyTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: CustomInputField(
                                  hintText: bio.tr,
                                  labelText: bio.tr,
                                  textEditingController: bioTextController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 4,
                                  maxLength: 200,
                                  onChanged: (value) => controller.bio = value,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      pleaseEnterYourBirthDate.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: customTextStyle(
                                        fontSize: 16,
                                        color: isDark
                                            ? Colors.white
                                            : greyTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Obx(() {
                                return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final chosenTime = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1920, 1, 1),
                                          lastDate: DateTime.now(),
                                        );

                                        if (chosenTime != null) {
                                          controller.birthDate = chosenTime;
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(8),
                                        height: 50,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1, color: Colors.grey),
                                        ),
                                        child: Text(
                                          controller.getFormatBirthDate(),
                                          style: staticTextStyle(
                                              16, blackTextColor),
                                        ),
                                      ),
                                    ));
                              }),
                              if (!controller.param.isSocial)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 14, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        pleaseEnterYourEmail.tr,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : blackTextColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SF Pro Display',
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '*',
                                        style: customTextStyle(
                                          fontSize: 16,
                                          color: isDark
                                              ? Colors.white
                                              : greyTextColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (!controller.param.isSocial)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: CustomInputField(
                                    hintText: email.tr,
                                    labelText: email.tr,
                                    textEditingController: emailTextController,
                                    onChanged: (value) =>
                                        controller.email = value,
                                  ),
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      '${howDoYouIdentity.tr}?',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '*',
                                      style: customTextStyle(
                                        fontSize: 16,
                                        color: isDark
                                            ? Colors.white
                                            : greyTextColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.bottomSheet(Obx(() {
                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        height: 360,
                                        decoration: BoxDecoration(
                                          color:
                                              isDark ? darkBgColor : whiteColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: SizedBox(
                                                height: 40,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      howDoYouIdentity.tr,
                                                      style: TextStyle(
                                                        color: isDark
                                                            ? Colors.white
                                                            : blackTextColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'SF Pro Display',
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        controller.currentSex =
                                                            0;
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: greyButton,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .clear,
                                                            size: 20,
                                                            color: isDark
                                                                ? Colors.white
                                                                : blackTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.currentSex = 1;
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  height: 48,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? darkBgColor
                                                        : greyButton,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        genderList[0],
                                                        style: TextStyle(
                                                          color: isDark
                                                              ? Colors.white
                                                              : blackTextColor,
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      (controller.currentSex ==
                                                              1)
                                                          ? const Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 26,
                                                              color: blueColor)
                                                          : Container(
                                                              height: 26,
                                                              width: 26,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            13),
                                                                border:
                                                                    Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.currentSex = 2;
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  height: 48,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? darkBgColor
                                                        : greyButton,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        genderList[1],
                                                        style: TextStyle(
                                                          color: isDark
                                                              ? Colors.white
                                                              : blackTextColor,
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      (controller.currentSex ==
                                                              2)
                                                          ? const Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 26,
                                                              color: blueColor)
                                                          : Container(
                                                              height: 26,
                                                              width: 26,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            13),
                                                                border:
                                                                    Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.currentSex = 3;
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  height: 48,
                                                  width: Get.width,
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? darkBgColor
                                                        : greyButton,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        genderList[2],
                                                        style: TextStyle(
                                                          color: isDark
                                                              ? Colors.white
                                                              : blackTextColor,
                                                          fontFamily:
                                                              'SF Pro Display',
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      (controller.currentSex ==
                                                              3)
                                                          ? const Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 26,
                                                              color: blueColor)
                                                          : Container(
                                                              height: 26,
                                                              width: 26,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            13),
                                                                border:
                                                                    Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 20,
                                                top: 20,
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  save.tr,
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? darkBgColor
                                                        : whiteColor,
                                                    fontSize: 16,
                                                    fontFamily:
                                                        "SF Pro Display",
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }));
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey,
                                          )),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Obx(() {
                                            return Text(
                                              controller.getCurrentSexLabel(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SF Pro Display',
                                                color: isDark
                                                    ? Colors.white
                                                    : hintTextColor,
                                              ),
                                            );
                                          }),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20,
                                            color: isDark
                                                ? Colors.white
                                                : blackTextColor,
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return ElevatedButton(
                            onPressed: controller.isValidate()
                                ? () {
                                    LoadingOverlay.show(context);
                                    controller.onPressedSignUp();
                                  }
                                : null,
                            child: Text(signUp.tr),
                          );
                        })
                      ],
                    ));
              }),
            ),
          ),
        );
      },
    );
  }
}
