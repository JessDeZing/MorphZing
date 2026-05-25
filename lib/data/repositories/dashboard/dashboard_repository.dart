import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/dashboard_api.dart';
import 'package:morphzing/data/models/dashboard/advice.dart';
import 'package:morphzing/data/models/dashboard/advice_list.dart';
import 'package:morphzing/data/models/dashboard/agenda_names.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/faqs.dart';

@singleton
class DashboardRepository {
  final DashboardApi _dashboardApi;

  DashboardRepository(this._dashboardApi);

  Future<AgendaNames> getDashboardAgendaNames() async {
    return await _dashboardApi.getDashboardAgendaNames();
  }

  Future<AdviceList> getSelfCareSuggestions({
    required String startTime,
    required String endTime,
  }) async {
    return await _dashboardApi.getSelfCareSuggestions(
      startTime,
      endTime,
    );
  }

  Future<void> completeAdvice({required Advice advice}) async {
    return await _dashboardApi.completeSuggestion(advice, advice.id!);
  }
}
