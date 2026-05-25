import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/data/models/home_page/banner.dart';
import 'package:morphzing/data/models/home_page/home_page_images.dart';
import 'package:retrofit/retrofit.dart';

part 'home_page_api.g.dart';

@singleton
@RestApi()
abstract class HomePageApi {
  @factoryMethod
  factory HomePageApi(Dio dio) = _HomePageApi;

  @GET("/homepage/banner_images")
  Future<HomePageImages> getHomePageImage();

  @POST("/homepage/banner_phone/")
  @MultiPart()
  Future<Banner> uploadBannerPhoto(@Part() File image);

  @PUT("/homepage/banner_phone/{id}/")
  @MultiPart()
  Future<Banner> updateBannerPhoto(
    @Part() File image,
    @Path('id') int id,
  );
}
