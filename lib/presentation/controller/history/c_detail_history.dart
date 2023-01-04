import 'package:get/get.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';

class CDetailHistory extends GetxController {
  final _data = History().obs;
  History get data => _data.value;

  getData(idUser, date) async {
    History? history = await SourceHistory.whereDate(idUser, date);
    _data.value = history ?? History();
    update();
  }
}
