// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _JournalApi implements JournalApi {
  _JournalApi(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<JournalStreakModel> getJournalStreak() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<JournalStreakModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/journal/stats/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = JournalStreakModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiPagination<JournalModel>> getJournalByDate({
    required startDate,
    required endDate,
    required currentPage,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'start_date': startDate,
      r'end_date': endDate,
      r'page': currentPage,
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiPagination<JournalModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/journal/journey/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ApiPagination<JournalModel>.fromJson(
      _result.data!,
      (json) => JournalModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<List<JournalModel>> getAllJournalByDate({
    required startDate,
    required endDate,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'start_date': startDate,
      r'end_date': endDate,
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<JournalModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/journal/journey_list/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => JournalModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<ApiPagination<JournalModel>> getTodayJournal(
      {required currentPage}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'page': currentPage};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiPagination<JournalModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/journal/journey/',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ApiPagination<JournalModel>.fromJson(
      _result.data!,
      (json) => JournalModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<void> journeyDelete(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/journal/journey//${id}/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  @override
  Future<void> journeyUserTemplate(
    id,
    templateId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'user_template',
      templateId.toString(),
    ));
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/journal/journey//${id}/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  @override
  Future<void> journeyFreeTemplate(
    id,
    templateId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'free_template',
      templateId.toString(),
    ));
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/journal/journey//${id}/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  @override
  Future<void> createJournal({
    userId,
    journeyTime,
    noteName,
    description,
    weblink,
    location,
    documentName,
    documentDesc,
    documentSize,
    photos,
    audio,
    document,
    draw,
    userTemplateId,
    freeTemplateId,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry(
        'user',
        userId.toString(),
      ));
    }
    if (journeyTime != null) {
      _data.fields.add(MapEntry(
        'journey_time',
        journeyTime,
      ));
    }
    if (noteName != null) {
      _data.fields.add(MapEntry(
        'note_name',
        noteName,
      ));
    }
    if (description != null) {
      _data.fields.add(MapEntry(
        'description',
        description,
      ));
    }
    if (weblink != null) {
      _data.fields.add(MapEntry(
        'web_link',
        weblink,
      ));
    }
    if (location != null) {
      _data.fields.add(MapEntry(
        'location',
        location,
      ));
    }
    if (documentName != null) {
      _data.fields.add(MapEntry(
        'document_name',
        documentName,
      ));
    }
    if (documentDesc != null) {
      _data.fields.add(MapEntry(
        'document_desc',
        documentDesc,
      ));
    }
    if (documentSize != null) {
      _data.fields.add(MapEntry(
        'document_size',
        documentSize.toString(),
      ));
    }
    if (photos != null) {
      _data.files.addAll(photos.map((i) => MapEntry(
          'photos',
          MultipartFile.fromFileSync(
            i.path,
            filename: i.path.split(Platform.pathSeparator).last,
          ))));
    }
    if (audio != null) {
      _data.files.add(MapEntry(
        'audio',
        MultipartFile.fromFileSync(
          audio.path,
          filename: audio.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (document != null) {
      _data.files.add(MapEntry(
        'document',
        MultipartFile.fromFileSync(
          document.path,
          filename: document.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (draw != null) {
      _data.files.add(MapEntry(
        'draw',
        MultipartFile.fromFileSync(
          draw.path,
          filename: draw.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (userTemplateId != null) {
      _data.fields.add(MapEntry(
        'user_template',
        userTemplateId.toString(),
      ));
    }
    if (freeTemplateId != null) {
      _data.fields.add(MapEntry(
        'free_template',
        freeTemplateId.toString(),
      ));
    }
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/journal/journey/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  @override
  Future<void> updateJournal({
    required id,
    userId,
    journeyTime,
    noteName,
    description,
    weblink,
    location,
    documentName,
    documentDesc,
    documentSize,
    photos,
    audio,
    document,
    draw,
    drawUrl,
    userTemplateId,
    freeTemplateId,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (userId != null) {
      _data.fields.add(MapEntry(
        'user',
        userId.toString(),
      ));
    }
    if (journeyTime != null) {
      _data.fields.add(MapEntry(
        'journey_time',
        journeyTime,
      ));
    }
    if (noteName != null) {
      _data.fields.add(MapEntry(
        'note_name',
        noteName,
      ));
    }
    if (description != null) {
      _data.fields.add(MapEntry(
        'description',
        description,
      ));
    }
    if (weblink != null) {
      _data.fields.add(MapEntry(
        'web_link',
        weblink,
      ));
    }
    if (location != null) {
      _data.fields.add(MapEntry(
        'location',
        location,
      ));
    }
    if (documentName != null) {
      _data.fields.add(MapEntry(
        'document_name',
        documentName,
      ));
    }
    if (documentDesc != null) {
      _data.fields.add(MapEntry(
        'document_desc',
        documentDesc,
      ));
    }
    if (documentSize != null) {
      _data.fields.add(MapEntry(
        'document_size',
        documentSize.toString(),
      ));
    }
    if (photos != null) {
      _data.files.addAll(photos.map((i) => MapEntry(
          'photos',
          MultipartFile.fromFileSync(
            i.path,
            filename: i.path.split(Platform.pathSeparator).last,
          ))));
    }
    if (audio != null) {
      _data.files.add(MapEntry(
        'audio',
        MultipartFile.fromFileSync(
          audio.path,
          filename: audio.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (document != null) {
      _data.files.add(MapEntry(
        'document',
        MultipartFile.fromFileSync(
          document.path,
          filename: document.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (draw != null) {
      _data.files.add(MapEntry(
        'draw',
        MultipartFile.fromFileSync(
          draw.path,
          filename: draw.path.split(Platform.pathSeparator).last,
        ),
      ));
    }
    if (drawUrl != null) {
      _data.fields.add(MapEntry(
        'drawing_url',
        drawUrl,
      ));
    }
    if (userTemplateId != null) {
      _data.fields.add(MapEntry(
        'user_template',
        userTemplateId.toString(),
      ));
    }
    if (freeTemplateId != null) {
      _data.fields.add(MapEntry(
        'free_template',
        freeTemplateId.toString(),
      ));
    }
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          _dio.options,
          '/journal/journey//${id}/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  @override
  Future<void> journalDeletePhoto(photoIds) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(photoIds);
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/journal/delete_photos/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return null;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
