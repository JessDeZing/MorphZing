import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/style/colors.dart';

const _asset = 'assets/icons';

class BottomSheetForFloatingButton extends StatefulWidget {
  const BottomSheetForFloatingButton({Key? key}) : super(key: key);

  @override
  State<BottomSheetForFloatingButton> createState() =>
      _BottomSheetForFloatingButtonState();
}

class _BottomSheetForFloatingButtonState
    extends State<BottomSheetForFloatingButton> {
  double _work = -30.w;
  double _finances = -40.w;
  double _travel = -90.w;

  double _selfCare = -30.w;
  double _specialOccasions = -40.w;
  double _meetUp = -90.w;

  final agendaNames = Get.find<AgendaController>().listOfAgendaNames;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _work = 30.w;
        _finances = 70.w;
        _travel = 110.w;

        _selfCare = 30.w;
        _specialOccasions = 70.w;
        _meetUp = 110.w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      //height: 350.h,
      child: agendaNames.isEmpty
          ? Center(
              child: Text('Agenda names are not fetched'),
            )
          : Stack(
              children: [
                AnimatedPositioned(
                  bottom: 100.h,
                  left: _work,
                  duration: 100.milliseconds,
                  child: _stackIcons('$_asset/ic_suitcase.svg',
                      agendaNames[0].name, workRoute),
                ),
                AnimatedPositioned(
                  bottom: 180.h,
                  left: _finances,
                  duration: 200.milliseconds,
                  child: _stackIcons(
                    '$_asset/ic_finances.svg',
                    agendaNames[1].name,
                    financesRoute,
                  ),
                ),
                AnimatedPositioned(
                  bottom: 260.h,
                  left: _travel,
                  duration: 300.milliseconds,
                  child: _stackIcons(
                    '$_asset/ic_plane.svg',
                    agendaNames[2].name,
                    travelRoute,
                  ),
                ),
                Positioned(
                  bottom: 320.h,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(
                      todayRoute,
                      arguments: DateTime.now(),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.w)),
                          ),
                          child: SvgPicture.asset('$_asset/ic_tick.svg'),
                        ),
                        SizedBox(height: 4.h),
                        SizedBox(
                          height: 24,
                          width: 44,
                          child: Center(
                            child: Text(
                              misc.tr,
                              textAlign: TextAlign.center,
                              style: customTextStyle(
                                fontSize: 10,
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AnimatedPositioned(
                  bottom: 100.h,
                  right: _selfCare,
                  duration: 100.milliseconds,
                  child: _stackIcons(
                    '$_asset/ic_meet_up.svg',
                    agendaNames[5].name,
                    meetUpRoute,
                  ),
                ),
                AnimatedPositioned(
                  bottom: 180.h,
                  right: _specialOccasions,
                  duration: 200.milliseconds,
                  child: _stackIcons(
                    '$_asset/ic_special_occasion.svg',
                    agendaNames[4].name,
                    specialOccasionRoute,
                  ),
                ),
                AnimatedPositioned(
                  bottom: 260.h,
                  right: _meetUp,
                  duration: 300.milliseconds,
                  child: _stackIcons(
                    '$_asset/ic_self_care.svg',
                    agendaNames[3].name,
                    selfCareRoute,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _stackIcons(String asset, String text, String route) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(24.w)),
            ),
            child: SvgPicture.asset(asset),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: 28,
            width: 44,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: customTextStyle(
                  fontSize: 10,
                  color: whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
