import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/utils/constants.dart';


import '../utils/http_exception.dart';

class ReportItem {
  final int validationsToday;
  final int thisWeekValidations;
  final int thisMonthValidations;
  final int activeStudents;
  final int inactiveStudents;


  ReportItem({
    required this.validationsToday,
    required this.thisWeekValidations,
    required this.thisMonthValidations,
    required this.activeStudents,
    required this.inactiveStudents,
  });
}

class ReportsProvider with ChangeNotifier {
  ReportItem _item = ReportItem(
    validationsToday: 0,
    thisWeekValidations: 0,
    thisMonthValidations: 0,
    activeStudents: 0,
    inactiveStudents: 0,
  );

  final Dio http;

  ReportsProvider(this.http);

  ReportItem get item {
    return _item;
  }

  Future<void> fetchAndSave() async {
    try {
      final resp = await http.get("${Constants.BASE_URL}/validations-report");
      final data = resp.data;
      ReportItem fetchedItem = ReportItem(
        thisWeekValidations: data["thisWeekValidations"],
        validationsToday: data["validationsToday"],
        activeStudents: data["activeStudents"],
        inactiveStudents: data["inactiveStudents"],
        thisMonthValidations: data["thisMonthValidations"],
      );
      _item = fetchedItem;
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
