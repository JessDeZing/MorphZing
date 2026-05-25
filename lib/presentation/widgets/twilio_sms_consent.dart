import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/style/colors.dart';

/**
 * Created by Bekhruz Makhmudov on 03/10/23.
 * Project morphzing
 */
class TwilioSmsConsent extends StatelessWidget {
  const TwilioSmsConsent({Key? key, required this.smsSendingAccepted})
      : super(key: key);
  final RxBool smsSendingAccepted;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => smsSendingAccepted(!smsSendingAccepted.value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              value: smsSendingAccepted.value,
              onChanged: (value) {
                if (value != null) {
                  smsSendingAccepted(value);
                }
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'twilioSmsConsent'.tr,
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 15,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
