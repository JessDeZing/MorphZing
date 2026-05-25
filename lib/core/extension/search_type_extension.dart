import 'package:morphzing/core/enum/search_type_enum.dart';

extension SearchTypeExtension on SearchTypeEnum {
  String getQueryValue() {
    if (this == SearchTypeEnum.task) {
      return 'tasks';
    } else if (this == SearchTypeEnum.event) {
      return 'events';
    } else if (this == SearchTypeEnum.journey) {
      return 'journey';
    } else if (this == SearchTypeEnum.note) {
      return 'note';
    }
    return '';
  }
}
