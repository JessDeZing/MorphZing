import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/data/models/dashboard/advice.dart';
import 'package:morphzing/data/models/dashboard/advice_list.dart';
import 'package:morphzing/data/models/dashboard/agenda_names.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:retrofit/retrofit.dart';

part 'dashboard_api.g.dart';

@singleton
@RestApi()
abstract class DashboardApi {
  @factoryMethod
  factory DashboardApi(Dio dio) = _DashboardApi;

  @GET("/agenda/names/")
  Future<AgendaNames> getDashboardAgendaNames();

  @GET("/agenda/self_care/")
  Future<AdviceList> getSelfCareSuggestions(
    @Query('start_date') String start,
    @Query('end_date') String end,
  );

  @PATCH("/agenda/self_care/{id}/")
  Future<void> completeSuggestion(
    @Body() Advice advice,
    @Path('id') int id,
  );
}
