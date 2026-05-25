import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class SubscriptionStatusContainer extends StatelessWidget {
  final bool isActive;
  final String? price;
  final DateTime? chargeDate;

  const SubscriptionStatusContainer({
    Key? key,
    required this.isActive,
    this.price,
    this.chargeDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : bgColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isActive ? subscriptionActive.tr : subscriptionNotActive.tr,
            style: customTextStyle(
              fontSize: 16,
              color: isDark ? Colors.white : blackTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: Text(
                  '$price ${willBeDebitedOn.tr} ${DateFormat('MMMM d', Get.locale?.languageCode).format(chargeDate!)}',
                  style: customTextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: true,
                )),
                SizedBox(
                  width: 12,
                ),
                Icon(Icons.credit_card,
                    color: isDark ? Colors.white : greyTextColor),
              ],
            )
          ],
        ],
      ),
    );
  }
}
