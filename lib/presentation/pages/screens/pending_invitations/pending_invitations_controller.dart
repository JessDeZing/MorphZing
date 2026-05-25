import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/invitation_change_status.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/utils/show_error.dart';

class PendingInvitationsController extends GetxController {
  final agendaRepository = getIt<AgendaRepository>();
  final agendaController = Get.find<AgendaController>();
  RxBool pageLoading = true.obs;
  RxList<Event> work = RxList([]);
  RxList<Event> finances = RxList([]);
  RxList<Event> travel = RxList([]);
  RxList<Event> selfCare = RxList([]);
  RxList<Event> specialOccasions = RxList([]);
  RxList<Event> meetUp = RxList([]);
  List<String>? travelPictures;

  @override
  void onInit() async {
    super.onInit();
    await fetchAllPendingEvents();
    pageLoading.value = false;
  }

  Future<void> fetchAllPendingEvents() async {
    try {
      travelPictures = [];
      work.clear();
      finances.clear();
      travel.clear();
      selfCare.clear();
      specialOccasions.clear();
      meetUp.clear();
      final response = await agendaRepository.getPendingInvitations();
      final list = agendaController.listOfAgendaNames;
      print('response: $response');
      print('list: $list');
      for (final element in response) {
        if (element.categoryId == list.first.id) {
          work.add(element);
        } else if (element.categoryId == list[1].id) {
          finances.add(element);
        } else if (element.categoryId == list[2].id) {
          travel.add(element);
          final photos = await agendaRepository.getTravelPhotos(element.id!);
          for (final agendaPhotos in photos) {
            for (final agendaPhoto in agendaPhotos.images) {
              travelPictures!.add(agendaPhoto.image);
            }
          }
        } else if (element.categoryId == list[3].id) {
          selfCare.add(element);
        } else if (element.categoryId == list[4].id) {
          specialOccasions.add(element);
        } else if (element.categoryId == list.last.id) {
          meetUp.add(element);
        }
      }
    } on Object catch (e) {
      print('error: $e');
      //showErrorSnackBar(message: 'Could not fetch pending invitations');
    }
  }

  Future<bool> acceptOrDeclineEvent({
    required int eventId,
    required bool status,
  }) async {
    try {
      await agendaRepository.acceptOrDeclineInvitation(
          invitationChangeStatus: InvitationChangeStatus(
        event: eventId,
        status: status ? 'accepted' : 'decline',
      ));
      await fetchAllPendingEvents();
      showGetSnackBar(
          message: 'Event ${status ? 'accepted' : 'declined'} successfully');
      return true;
    } on Object catch (_) {
      showErrorSnackBar(
          message: 'Failed to ${status ? 'accept' : 'decline'} event');
      return false;
    }
  }
}
