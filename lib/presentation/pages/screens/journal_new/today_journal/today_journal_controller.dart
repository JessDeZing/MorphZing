import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class TodayJournalController extends GetxController {
  final NewJournalRepository _newJournalRepository =
      getIt<NewJournalRepository>();
  final Rx<RxStatus> _rxStatus = Rx<RxStatus>(RxStatus.empty());
  final Rx<ApiPagination<JournalModel>> _response =
      Rx<ApiPagination<JournalModel>>(ApiPagination(total: 0, data: []));
  bool isUpdated = false;

  int currentPage = 1;

  RxStatus get rxStatus => _rxStatus.value;

  ApiPagination<JournalModel> get response => _response.value;

  @override
  void onReady() {
    _getJournalCountJournalList();
    super.onReady();
  }

  void _getJournalCountJournalList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _newJournalRepository
        .getTodayJournal(
      currentPage: currentPage,
    )
        .then((value) {
      _response.value = value;
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getPaginationJournalList() async {
    await Future.delayed(Duration(milliseconds: 100));
    _rxStatus.value = RxStatus.loadingMore();
    _newJournalRepository
        .getTodayJournal(
      currentPage: currentPage + 1,
    )
        .then((value) {
      currentPage = currentPage + 1;
      _response.value = ApiPagination(
          total: value.total, data: [..._response.value.data, ...value.data]);
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  // void openCalendarJournalScreen() {
  //   Get.toNamed(calendarJournal)?.then((value) {});
  // }
  //
  // void openCreateJournalScreen() {
  //   Get.toNamed(journeyRoute)?.then((value) {
  //     if (value != null) _getJournalCountJournalList();
  //   });
  // }

  void deleteJourney(int id) {
    _newJournalRepository.journeyDelete(id: id).then((value) {
      isUpdated = true;
      LoadingOverlay.hide();
      showGetSnackBar(message: journeyDeleteMessage.tr);
      _getJournalCountJournalList();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void setJourneyFreeTemplate(int id, Template template) {
    _newJournalRepository.journeyFreeTemplate(id, template.id).then((value) {
      LoadingOverlay.hide();
      _getJournalCountJournalList();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void setJourneyUserTemplate(int id, Template template) {
    _newJournalRepository.journeyUserTemplate(id, template.id).then((value) {
      LoadingOverlay.hide();
      _getJournalCountJournalList();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void openUpdateJournalScreen(JournalModel model) {
    Get.toNamed(journeyRoute, arguments: model)?.then((value) {
      if (value != null) {
        isUpdated = true;
        _getJournalCountJournalList();
      }
    });
  }

  launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        // await launchUrl(Uri.parse(url));
        var googleDocsUrl =
            'https://docs.google.com/gview?embedded=true&url=${Uri.parse(url)}';
        final Uri uri = Uri.parse(googleDocsUrl);
        launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      showErrorSnackBar(message: error.toString());
    }
  }

  Future<File> fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, url.split("/").last));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  void shareFile({
    required String imageUrl,
    required String title,
    required String? description,
  }) async {
    File file = await fileFromImageUrl(imageUrl);
    LoadingOverlay.hide();
    Share.shareXFiles(
      [XFile(file.path)],
      text: description ?? title,
      //subject: description,
    );
  }

  void onPressedBack() => Get.back(result: isUpdated);
}
