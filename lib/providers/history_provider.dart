import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/utils/constants.dart';

import '../utils/http_exception.dart';

class HistoryProvider with ChangeNotifier {
  List<dynamic> _items = [];
  final Dio http;

  HistoryProvider(this.http);

  List<dynamic> get items {
    return _items;
  }

  Future<void> fetchAndSave() async {
    try {
      final resp = await http.get("${Constants.BASE_URL}/history");
      final data = resp.data;
      print(data);
      _items = data;
      notifyListeners();
    } on DioError catch (e) {
      print(e);
      throw HttpException(e.message);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
