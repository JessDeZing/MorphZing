import 'dart:math';

import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';

String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  if (bytes == 0) return '0 ${suffixes[0]}';
  var i = (log(bytes) / log(1024)).floor();
  return '${((bytes / pow(1024, i)).toStringAsFixed(decimals))} ${suffixes[i]}';
}

bool isValidUrl(String weblink) => Uri.parse(weblink).isAbsolute;

int subscribePhoto() {
  switch (Get.find<AppController>().user?.paymentStatus) {
    case SubscriptionType.free:
      return 5;
    case SubscriptionType.basic:
      return 25;
    case SubscriptionType.premium:
    case SubscriptionType.familyShare:
      return 50;
    default:
      return 5;
  }
}
