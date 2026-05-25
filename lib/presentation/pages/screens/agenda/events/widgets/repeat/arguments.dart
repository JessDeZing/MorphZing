import 'package:equatable/equatable.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_widget.dart';

class RepeatArguments with EquatableMixin {
  final RepeatRadioButtonOptions repeat;
  final List<int> chosenWeekDays;
  final int numberOfWeeks;
  final DateTime? until;
  final DurationRadioButtonOptions durationOption;

  const RepeatArguments({
    required this.repeat,
    required this.chosenWeekDays,
    required this.numberOfWeeks,
    required this.until,
    required this.durationOption,
  });

  @override
  List<Object?> get props => [
        repeat,
        chosenWeekDays,
        numberOfWeeks,
        until,
        durationOption,
      ];

  @override
  String toString() {
    return 'RepeatArguments{repeat: $repeat, chosenWeekDays: $chosenWeekDays, numberOfWeeks: $numberOfWeeks, until: $until, durationOption: $durationOption}';
  }
}
