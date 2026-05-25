import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/invitations_controller.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/widgets/invitation_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/pending_invitations_controller.dart';

class DynamicDeepLinkService {
  DynamicDeepLinkService._();

  static final _instance = DynamicDeepLinkService._();

  static DynamicDeepLinkService get instance => _instance;

  static bool _acceptDeeplink = true;

  Future<void> initDynamicLinks(BuildContext context) async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();

    if (data != null) {
      await _instance._handleLink(data, context);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      if (_acceptDeeplink) {
        _acceptDeeplink = false;
        _instance
            ._handleLink(dynamicLink, context)
            .then((_) => _acceptDeeplink = true);
      }
    });

    // Also check if we're currently on a deep link route
    final currentRoute = Get.currentRoute;
    if (currentRoute.startsWith('/event_id/')) {
      await _instance._handleRouteDeepLink(currentRoute, context);
    }
  }

  Future<void> _handleLink(
    PendingDynamicLinkData? link,
    BuildContext context,
  ) async {
    try {
      final Uri? deeplink = link?.link;
      if (link == null || deeplink == null) {
        debugPrint('Deep link: link or deeplink is null');
        return;
      }

      debugPrint('Deep link received: ${deeplink.toString()}');

      final path = deeplink.path.split('/');
      if (path.first == "") {
        path.removeAt(0);
      }

      debugPrint('Deep link path segments: $path');

      final eventId = int.tryParse(path.last);
      if (path.first == 'event_id' && eventId != null) {
        debugPrint('Processing event_id deep link: $eventId');
        final repo = Get.find<AgendaController>();
        final event = await repo.getEventByUUID(eventId);
        if (event == null) {
          return;
        }

        List<String>? eventPhotos;
        if (event.categoryId == 3) {
          final photos = await repo.getPhotos(eventId);
          if (photos.isNotEmpty) {
            eventPhotos = [];
            for (var element in photos) {
              if (element.images.isNotEmpty) {
                for (var img in element.images) {
                  eventPhotos.add(img.image);
                }
              }
            }
          }
        }
        Get.put(PendingInvitationsController());
        Get.put(InvitationsController());
        await InvitationBottomSheet.show(
          context: context,
          event: event,
          travelPictures: eventPhotos,
          color: event.getBgColor(),
        );
        Get.delete<PendingInvitationsController>();
        Get.delete<InvitationsController>();
      } else {
        debugPrint('Deep link does not match expected pattern. Path: $path');
        debugPrint('Expected pattern: event_id/{number}');
      }
    } on Object catch (e) {
      //added this because we could not identify the bug of: user inside the app, then clicks on deeplink and nothing happening
      debugPrint('Deep link error: ${e.toString()}');
    }
  }

  Future<void> _handleRouteDeepLink(String route, BuildContext context) async {
    try {
      debugPrint('Handling route deep link: $route');

      final path = route.split('/');
      if (path.first == "") {
        path.removeAt(0);
      }

      debugPrint('Route deep link path segments: $path');

      final eventId = int.tryParse(path.last);
      if (path.first == 'event_id' && eventId != null) {
        debugPrint('Processing route event_id deep link: $eventId');

        // Ensure AgendaController is available
        if (!Get.isRegistered<AgendaController>()) {
          Get.put<AgendaController>(AgendaController());
        }

        final repo = Get.find<AgendaController>();
        final event = await repo.getEventByUUID(eventId);
        if (event == null) {
          debugPrint('Event not found for ID: $eventId');
          return;
        }

        List<String>? eventPhotos;
        if (event.categoryId == 3) {
          final photos = await repo.getPhotos(eventId);
          if (photos.isNotEmpty) {
            eventPhotos = [];
            for (var element in photos) {
              if (element.images.isNotEmpty) {
                for (var img in element.images) {
                  eventPhotos.add(img.image);
                }
              }
            }
          }
        }

        Get.put(PendingInvitationsController());
        Get.put(InvitationsController());
        await InvitationBottomSheet.show(
          context: context,
          event: event,
          travelPictures: eventPhotos,
          color: event.getBgColor(),
        );
        Get.delete<PendingInvitationsController>();
        Get.delete<InvitationsController>();
      } else {
        debugPrint(
            'Route deep link does not match expected pattern. Path: $path');
        debugPrint('Expected pattern: event_id/{number}');
      }
    } on Object catch (e) {
      debugPrint('Route deep link error: ${e.toString()}');
    }
  }

  static Future<String> createDynamicLink(int uuid) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.morphzing.com/event_id/$uuid"),
      uriPrefix: "https://morphzing.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.jafton.morphzing",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.jafton.morphzing",
        minimumVersion: '1.0.0',
        appStoreId: '1668666088',
      ),
    );
    try {
      final dynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      debugPrint('link is ${dynamicLink.shortUrl.toString()}');
      return dynamicLink.shortUrl.toString();
    } on Object catch (e) {
      debugPrint('error is ${e.toString()}');
    }

    return '';
  }
}
