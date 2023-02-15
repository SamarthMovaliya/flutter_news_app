import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:news_api_app/modal/global.dart';

class newsApiHelper {
  newsApiHelper._();

  static final newsApi = newsApiHelper._();

  fetchNewsData({dynamic ct,dynamic cou}) async {

    http.Response res = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=${cou}&category=${ct}&apiKey=5ed315daec9842929d2fc79ef2b04061'),
    );

    if (res.statusCode == 200) {
      dynamic decodedData = jsonDecode(res.body);
      List articlesData = decodedData['articles'];
      List<global> data =
          articlesData.map((e) => global.fromList(data: e)).toList();
      return data;
    }
  }
}
