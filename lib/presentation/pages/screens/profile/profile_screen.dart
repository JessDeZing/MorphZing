import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/core/constants/const_lists.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile/profile_controller.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_screen.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/presentation/pages/screens/profile/new_email_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile/new_phone_number_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile/old_password_screen.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_dialog.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

import '../../../widgets/primary_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.put(ProfileController());
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: isDark ? darkBgColor : whiteColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<HomeController>().fetchUserInfo();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? Colors.white : blackTextColor,
            ),
          ),
          centerTitle: true,
          title: Text(
            profile.tr,
            style: TextStyle(
              color: isDark ? Colors.white : blackTextColor,
              fontFamily: 'SF Pro Display',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (Get.find<AppController>()
                    .user
                    ?.userSubscription
                    .paymentStatus ==
                SubscriptionType.free) ...[
              GestureDetector(
                onTap: () {
                  SubscriptionDialog.show(context: context);
                },
                child: Center(
                    child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset('assets/icons/premium.svg'),
                )),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
            CupertinoButton(
              child: Text(
                save.tr,
                style: const TextStyle(
                  color: Color(0XFF4890FF),
                ),
              ),
              onPressed: () {
                // Execute the onSave method directly
                controller.onSave();
              },
            ),
            //changed this
            // CupertinoButton(
            //   child: Text(
            //     save.tr,
            //     style: const TextStyle(
            //       color: Color(0XFF4890FF),
            //     ),
            //   ),
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return Center(
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(24),
            //             ),
            //             padding: const EdgeInsets.all(12),
            //             child: const CupertinoActivityIndicator(),
            //           ),
            //         );
            //       },
            //       barrierDismissible: false,
            //     );
            //     controller.onSave();
            //   },
            // ),
          ],
        ),
        backgroundColor: isDark ? darkBgColor : whiteColor,
        body: controller.loading.value
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          height: 150,
                          color: isDark ? darkBgColor : whiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.pickImageFromCamera();
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: greyButton,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.camera,
                                          size: 30,
                                          color: blackTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      camera.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.pickImageFromGallery();
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? darkBorderColor
                                            : greyButton,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 30,
                                          color: blackTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      gallery.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
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
                                borderRadius: BorderRadius.circular(50),
                                color: blueColor,
                                image: (controller.currentImage != null)
                                    ? DecorationImage(
                                        image:
                                            FileImage(controller.currentImage!),
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
                                  borderRadius: BorderRadius.circular(16),
                                  color: isDark ? darkBorderColor : greyButton,
                                ),
                                child: Center(
                                  child: (controller.currentImage != null)
                                      ? Icon(
                                          CupertinoIcons.arrow_2_circlepath,
                                          color: isDark
                                              ? Colors.white
                                              : blackTextColor,
                                          size: 20,
                                        )
                                      : Icon(
                                          Icons.add_a_photo_outlined,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          fullName.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
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
                      hintText: enterYourName.tr,
                      textEditingController: controller.nameController,
                      labelText: enterYourName.tr,
                      maxLength: 40,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          aboutMe.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
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
                  CustomInputField(
                    hintText: bio.tr,
                    textEditingController: controller.bioController,
                    labelText: bio.tr,
                    maxLines: 4,
                    maxLength: 280,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          pleaseEnterYourBirthDate.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
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
                  Obx(() {
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () async {
                            final chosenTime = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1920, 1, 1),
                              lastDate: DateTime.now(),
                            );

                            if (chosenTime != null) {
                              controller.birthDateString.value =
                                  DateFormat('MM/dd/yyyy').format(chosenTime);
                              controller.birthDate.value = chosenTime;
                            }
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(8),
                            height: 50,
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color:
                                      isDark ? darkBorderColor : Colors.grey),
                            ),
                            child: (controller.birthDateString.value == '')
                                ? Text(
                                    birthDate.tr,
                                    style: staticTextStyle(
                                      16,
                                      isDark ? Colors.white : greyTextColor,
                                    ),
                                  )
                                : Text(
                                    controller.birthDateString.value,
                                    style: staticTextStyle(
                                      16,
                                      isDark ? Colors.white : blackTextColor,
                                    ),
                                  ),
                          ),
                        ));
                  }),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          howDoYouIdentity.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
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
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(Obx(() {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          height: 360,
                          decoration: BoxDecoration(
                            color: isDark ? darkBgColor : whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        howDoYouIdentity.tr,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : blackTextColor,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SF Pro Display',
                                          fontSize: 20,
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
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? darkBorderColor
                                                : greyButton,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              CupertinoIcons.clear,
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
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.currentSex.value = 1;
                                    controller.defaultSex.value = genderList[0];
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    height: 48,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color:
                                          isDark ? darkBorderColor : greyButton,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          genderList[0],
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : blackTextColor,
                                            fontFamily: 'SF Pro Display',
                                            fontSize: 17,
                                          ),
                                        ),
                                        (controller.currentSex.value == 1)
                                            ? const Icon(Icons.check_circle,
                                                size: 26, color: blueColor)
                                            : Container(
                                                height: 26,
                                                width: 26,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: isDark
                                                        ? darkBorderColor
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.currentSex.value = 2;
                                    controller.defaultSex.value = genderList[1];
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    height: 48,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color:
                                          isDark ? darkBorderColor : greyButton,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          genderList[1],
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : blackTextColor,
                                            fontFamily: 'SF Pro Display',
                                            fontSize: 17,
                                          ),
                                        ),
                                        (controller.currentSex.value == 2)
                                            ? const Icon(Icons.check_circle,
                                                size: 26, color: blueColor)
                                            : Container(
                                                height: 26,
                                                width: 26,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: isDark
                                                        ? darkBorderColor
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.currentSex.value = 3;
                                    controller.defaultSex.value = genderList[2];
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    height: 48,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color:
                                          isDark ? darkBorderColor : greyButton,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          genderList[2],
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : blackTextColor,
                                            fontFamily: 'SF Pro Display',
                                            fontSize: 17,
                                          ),
                                        ),
                                        (controller.currentSex.value == 3)
                                            ? const Icon(Icons.check_circle,
                                                size: 26, color: blueColor)
                                            : Container(
                                                height: 26,
                                                width: 26,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: isDark
                                                        ? darkBorderColor
                                                        : Colors.grey,
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
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color:
                                          isDark ? darkBorderColor : blueColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: (controller.loading.value)
                                          ? const CircularProgressIndicator(
                                              color: whiteColor,
                                            )
                                          : Text(
                                              save.tr,
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 16,
                                                fontFamily: "SF Pro Display",
                                              ),
                                            ),
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
                        borderRadius: BorderRadius.circular(10),
                        color:
                            isDark ? darkBorderColor : const Color(0xFFFAFAFB),
                      ),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            controller.defaultSex.value,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'SF Pro Display',
                              color: isDark ? Colors.white : hintTextColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: isDark ? Colors.white : blackTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          phone.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '*',
                          style: customTextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : greyTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(currentPhoneRoute),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isDark
                                ? darkBorderColor
                                : const Color(0xFFFAFAFB),
                          ),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                appController.user?.phone ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SF Pro Display',
                                  color: isDark ? Colors.white : hintTextColor,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: isDark ? Colors.white : blackTextColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          email.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '*',
                          style: customTextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : greyTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.userInfoModel.value!.authProvider ==
                            'phone') {
                          await Get.to(const NewEmailScreen());
                          setState(() {});
                        } else {
                          showAttentionSnackBar(message: cannotChangeEmail.tr);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDark
                              ? darkBorderColor
                              : const Color(0xFFFAFAFB),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              controller.emailController.text.isNotEmpty
                                  ? controller.emailController.text
                                  : setYourEmail.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SF Pro Display',
                                color: isDark ? Colors.white : hintTextColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: isDark ? Colors.white : blackTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          changePassword.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : blackTextColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '*',
                          style: customTextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white : greyTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: GestureDetector(
                      onTap: () => Get.toNamed(changePasswordRoute),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDark
                              ? darkBorderColor
                              : const Color(0xFFFAFAFB),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "********",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'SF Pro Display',
                                color: isDark ? Colors.white : hintTextColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: isDark ? Colors.white : blackTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    appLanguage.tr,
                    style: TextStyle(
                      color: isDark ? Colors.white : blackTextColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro Display',
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setLocale(LocaleEnum.en),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                color: Get.locale == LocaleEnum.en.getLocale()
                                    ? blueColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              english.tr,
                              style: TextStyle(
                                color: isDark ? Colors.white : blackTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 56),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.setLocale(LocaleEnum.es),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              border: Border.all(
                                color: Get.locale == LocaleEnum.es.getLocale()
                                    ? blueColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(spanish.tr),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: PrimaryButton(
                      buttonColor: Colors.blue,
                      buttonText: subscription.tr,
                      onPressed: () {
                        Navigator.pushNamed(context, subscriptionScreen);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10.0),
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                alignment: Alignment.center,
                                title: Text(deleteAccPermanently.tr),
                                content: Text(dataWillBeDeleted.tr),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); //close Dialog
                                    },
                                    child: Text(cancel.tr),
                                  ),
                                  TextButton(
                                    onPressed: controller.onDeleteAccount,
                                    child: Text(delete.tr),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isDark
                              ? darkBorderColor
                              : const Color(0xFFFAFAFB),
                        ),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 14),
                            Text(
                              deleteAccount.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'SF Pro Display',
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SafeArea(child: SizedBox.shrink()),
                ],
              ),
      );
    });
  }
}
