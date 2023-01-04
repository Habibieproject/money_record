import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/data/model/history.dart';
import 'package:money_record/data/source/source_history.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/controller/history/c_history.dart';
import 'package:money_record/presentation/page/history/detail_history_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final controllerSearch = TextEditingController();

  refresh() {
    cHistory.getList(
      cUser.data.idUser,
    );
  }

  delete(String idHistory) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Hapus', 'Yakin untuk menghapus history ini?',
        textNo: 'Batal', textYes: 'Yes');
    if (yes!) {
      bool success = await SourceHistory.deleteHistory(idHistory);
      if (success) refresh();
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(children: [
          const Text("Riwayat"),
          Expanded(
              child: Container(
            height: 40,
            margin: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controllerSearch,
              onTap: () async {
                DateTime? result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022, 01, 01),
                    lastDate: DateTime(DateTime.now().year + 1));
                if (result != null) {
                  controllerSearch.text =
                      DateFormat('yyyy-MM-dd').format(result);
                }
              },
              style: const TextStyle(color: Colors.white),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  fillColor: AppColor.kColorChart.withOpacity(0.5),
                  filled: true,
                  hintText: '2022-06-01',
                  suffixIcon: IconButton(
                      onPressed: () {
                        cHistory.search(
                            cUser.data.idUser, controllerSearch.text);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  )),
            ),
          ))
        ]),
      ),
      body: GetBuilder<CHistory>(
        builder: (_) {
          if (_.loading) return DView.loadingCircle();
          if (_.list.isEmpty) return DView.empty('Kosong');
          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: ListView.builder(
              itemCount: _.list.length,
              itemBuilder: (BuildContext context, int index) {
                History history = _.list[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                      index == _.list.length - 1 ? 16 : 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      Get.to(() => DetailhistoryPage(
                            idUser: cUser.data.idUser!,
                            date: history.date!,
                            type: history.type!,
                          ));
                    },
                    child: Row(children: [
                      DView.spaceWidth(),
                      history.type == 'Pemasukkan'
                          ? Icon(Icons.south_west, color: Colors.green[300])
                          : Icon(Icons.north_east, color: Colors.red[300]),
                      DView.spaceWidth(),
                      Text(
                        AppFormat.date(history.date!),
                        style: const TextStyle(
                            color: AppColor.kColorPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Expanded(
                          child: Text(
                        AppFormat.currency(history.total!),
                        style: const TextStyle(
                            color: AppColor.kColorPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        textAlign: TextAlign.end,
                      )),
                      IconButton(
                          onPressed: () {
                            delete(history.idHistory!);
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red[300],
                          ))
                    ]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
