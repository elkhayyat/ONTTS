import 'package:dio/dio.dart';
import 'package:ontts/shared/component/constants.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: baseUrl,
          receiveDataWhenStatusError: true,
          headers: {
            'content-type': 'application/json',
          }),
    );
  }


  static Future<Response> getData({
    required String url,
    required Map<String, dynamic>? query,
    String? token,
  }) async {
    token ?? '';
    dio!.options.headers = {
      'Authorization': token,
    };
    return await dio!.get(
      baseUrl + url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    token ?? '';
    dio!.options.headers = {'Authorization': token,};
    return await dio!.post(baseUrl + url, data: data);
  }
}
