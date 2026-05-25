import 'package:equatable/equatable.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/participant.dart';

class EventWithParticipants with EquatableMixin {
  final Event event;
  final List<Participant> participants;

  const EventWithParticipants({
    required this.event,
    required this.participants,
  });

  @override
  List<Object?> get props => [event, participants];
}
