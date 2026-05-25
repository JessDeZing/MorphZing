import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';
import 'package:morphzing/utils/show_error.dart';

class TasksEventsController extends GetxController {
  TasksEventsController(this.time);

  final DateTime time;
  final _agendaRepository = getIt<AgendaRepository>();
  final _agendaController = Get.find<AgendaController>();
  RxBool pageLoading = true.obs;
  RxList<EventWithParticipants> events = RxList([]);
  RxList<Todo> dailyTodos = RxList([]);

  @override
  void onReady() async {
    super.onReady();
    await getTasksEventsByDay(time);
    pageLoading.value = false;
  }

  Future<void> getTasksEventsByDay(DateTime time) async {
    try {
      List<EventWithParticipants> eventWithParticipants = [];
      List<Todo> dailyTasks = [];
      final calendarData =
          await _agendaRepository.getAgendaCalendar(time, time);
      for (Event event in calendarData.events) {
        final participants =
            await _agendaController.getEventParticipants(eventId: event.id!);
        eventWithParticipants.add(
            EventWithParticipants(event: event, participants: participants));
      }
      for (Todo todo in calendarData.todos.daily) {
        dailyTasks.add(todo);
      }
      events.value = eventWithParticipants;
      dailyTodos.value = dailyTasks;
    } on Object catch (_) {
      showErrorSnackBar(
          message: 'Could not fetch tasks and events for chosen day');
    }
  }
}
