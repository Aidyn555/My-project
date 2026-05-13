import 'package:dio/dio.dart';


class RandomArticleService {
  Future<Map<String,dynamic>> fetchRandomArticle() async {
    final Dio _dio = Dio();
    final uri = Uri.https(
      'ru.wikipedia.com',
      'api/rest_v1/page/random/summary',
    );
    try {
      final response = await _dio.get(uri.toString());
      return response.data;
    } on DioException catch (e) {
      print(e);
      throw e;
    }
  }
}
