// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:get_storage/get_storage.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i4;

import '../data/api/about_the_app_api.dart' as _i22;
import '../data/api/agenda_api.dart' as _i24;
import '../data/api/auth_api.dart' as _i26;
import '../data/api/dashboard_api.dart' as _i28;
import '../data/api/home_page_api.dart' as _i8;
import '../data/api/journal_api.dart' as _i10;
import '../data/api/module/internet_module.dart' as _i31;
import '../data/api/module/register_module.dart' as _i30;
import '../data/api/note_api.dart' as _i12;
import '../data/api/notification_api.dart' as _i14;
import '../data/api/purchase_api.dart' as _i16;
import '../data/api/search_api.dart' as _i18;
import '../data/api/user_api.dart' as _i20;
import '../data/repositories/agenda/agenda_repository.dart' as _i25;
import '../data/repositories/auth/auth_repository.dart' as _i27;
import '../data/repositories/auth/token_repository.dart' as _i5;
import '../data/repositories/common/common_repository.dart' as _i6;
import '../data/repositories/dashboard/dashboard_repository.dart' as _i29;
import '../data/repositories/home/home_page_repository.dart' as _i9;
import '../data/repositories/journal/new_journal_repository.dart' as _i11;
import '../data/repositories/journal/note_repository.dart' as _i13;
import '../data/repositories/notification/notification_repository.dart' as _i15;
import '../data/repositories/profile_menu/about_the_app_repository.dart'
    as _i23;
import '../data/repositories/purchase/purchase_repository.dart' as _i17;
import '../data/repositories/search/search_repository.dart' as _i19;
import '../data/repositories/user/user_repository.dart'
    as _i21; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  final internetModule = _$InternetModule();
  gh.singleton<_i3.GetStorage>(() => registerModule.getStorage);
  gh.singleton<_i4.InternetConnectionChecker>(
      () => internetModule.internetConnectionChecker());
  gh.factory<String>(
    () => registerModule.url,
    instanceName: 'BaseUrl',
  );
  gh.singleton<_i5.TokenRepository>(
      () => _i5.TokenRepository(get<_i3.GetStorage>()));
  gh.singleton<_i6.CommonRepository>(
      () => _i6.CommonRepository(get<_i3.GetStorage>()));
  gh.singletonAsync<_i7.Dio>(() => registerModule.getAuthorizedDioClient(
        baseUrl: get<String>(instanceName: 'BaseUrl'),
        tokenRepository: get<_i5.TokenRepository>(),
      ));
  gh.singletonAsync<_i7.Dio>(
    () => registerModule.getUnauthorizedDioClient(
        baseUrl: get<String>(instanceName: 'BaseUrl')),
    instanceName: 'UnauthorizedClient',
  );
  gh.singletonAsync<_i8.HomePageApi>(
      () async => _i8.HomePageApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i9.HomePageRepository>(() async => _i9.HomePageRepository(
        await get.getAsync<_i8.HomePageApi>(),
        get<_i3.GetStorage>(),
      ));
  gh.singletonAsync<_i10.JournalApi>(
      () async => _i10.JournalApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i11.NewJournalRepository>(() async =>
      _i11.NewJournalRepository(await get.getAsync<_i10.JournalApi>()));
  gh.singletonAsync<_i12.NoteApi>(
      () async => _i12.NoteApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i13.NoteRepository>(
      () async => _i13.NoteRepository(await get.getAsync<_i12.NoteApi>()));
  gh.singletonAsync<_i14.NotificationApi>(
      () async => _i14.NotificationApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i15.NotificationRepository>(() async =>
      _i15.NotificationRepository(await get.getAsync<_i14.NotificationApi>()));
  gh.singletonAsync<_i16.PurchaseApi>(
      () async => _i16.PurchaseApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i17.PurchaseRepository>(() async =>
      _i17.PurchaseRepository(await get.getAsync<_i16.PurchaseApi>()));
  gh.singletonAsync<_i18.SearchApi>(
      () async => _i18.SearchApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i19.SearchRepository>(
      () async => _i19.SearchRepository(await get.getAsync<_i18.SearchApi>()));
  gh.singletonAsync<_i20.UserApi>(
      () async => _i20.UserApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i21.UserRepository>(
      () async => _i21.UserRepository(await get.getAsync<_i20.UserApi>()));
  gh.singletonAsync<_i22.AboutTheAppApi>(
      () async => _i22.AboutTheAppApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i23.AboutTheAppRepository>(() async =>
      _i23.AboutTheAppRepository(await get.getAsync<_i22.AboutTheAppApi>()));
  gh.singletonAsync<_i24.AgendaApi>(
      () async => _i24.AgendaApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i25.AgendaRepository>(
      () async => _i25.AgendaRepository(await get.getAsync<_i24.AgendaApi>()));
  gh.singletonAsync<_i26.AuthApi>(() async => _i26.AuthApi(
      await get.getAsync<_i7.Dio>(instanceName: 'UnauthorizedClient')));
  gh.singletonAsync<_i27.AuthRepository>(
      () async => _i27.AuthRepository(await get.getAsync<_i26.AuthApi>()));
  gh.singletonAsync<_i28.DashboardApi>(
      () async => _i28.DashboardApi(await get.getAsync<_i7.Dio>()));
  gh.singletonAsync<_i29.DashboardRepository>(() async =>
      _i29.DashboardRepository(await get.getAsync<_i28.DashboardApi>()));
  return get;
}

class _$RegisterModule extends _i30.RegisterModule {}

class _$InternetModule extends _i31.InternetModule {}
