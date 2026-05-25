import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@module
abstract class InternetModule {
  @singleton
  InternetConnectionChecker internetConnectionChecker() {
    return InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 10),
      checkInterval: const Duration(seconds: 10),
      addresses: [
        AddressCheckOptions(
          address: InternetAddress(
            '1.1.1.1', // CloudFlare
            type: InternetAddressType.IPv4,
          ),
        ),
        AddressCheckOptions(
          address: InternetAddress(
            '2606:4700:4700::1111', // CloudFlare
            type: InternetAddressType.IPv6,
          ),
        ),
        AddressCheckOptions(
          address: InternetAddress(
            '8.8.4.4', // Google
            type: InternetAddressType.IPv4,
          ),
        ),
        AddressCheckOptions(
          address: InternetAddress(
            '2001:4860:4860::8888', // Google
            type: InternetAddressType.IPv6,
          ),
        ),
        AddressCheckOptions(
          address: InternetAddress(
            '208.67.222.222', // OpenDNS
            type: InternetAddressType.IPv4,
          ), // OpenDNS
        ),
        AddressCheckOptions(
          address: InternetAddress(
            '2620:0:ccc::2', // OpenDNS
            type: InternetAddressType.IPv6,
          ), // OpenDNS
        ),
      ],
    );
  }
}
