import 'dart:convert';

import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/presentation/controller/history/c_detail_history.dart';

class DetailhistoryPage extends StatefulWidget {
  const DetailhistoryPage(
      {super.key, required this.idUser, required this.date});
  final String idUser;
  final String date;

  @override
  State<DetailhistoryPage> createState() => _DetailhistoryPageState();
}

class _DetailhistoryPageState extends State<DetailhistoryPage> {
  final cDetailHistory = Get.put(CDetailHistory());
  @override
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
          if (cDetailHistory.data.date == null) return DView.nothing();
          return Row(
            children: [
              Expanded(child: Text(AppFormat.date(cDetailHistory.data.date!))),
              cDetailHistory.data.type == 'Pemasukkan'
                  ? Icon(
                      Icons.south_west,
                      color: Colors.green[300],
                    )
                  : Icon(
                      Icons.north_west,
                      color: Colors.red[300],
                    ),
              DView.spaceWidth()
            ],
          );
        }),
      ),
      body: GetBuilder<CDetailHistory>(
        builder: (_) {
          if (_.data.date == null) return DView.nothing();
          List details = jsonDecode(_.data.details!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Total",
                  style: TextStyle(
                      color: AppColor.kColorPrimary.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              DView.spaceHeight(8),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    AppFormat.currency(_.data.total!),
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: AppColor.kColorPrimary),
                  )),
              DView.spaceHeight(20),
              Center(
                child: Container(
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                      color: AppColor.kColorBackground,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              DView.spaceHeight(20),
              Expanded(
                child: ListView.separated(
                  itemCount: details.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      thickness: 0.5,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    Map item = details[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: const TextStyle(fontSize: 20),
                          ),
                          DView.spaceHeight(8),
                          Expanded(
                              child: Text(
                            item['name'],
                            style: const TextStyle(fontSize: 20),
                          )),
                          Text(
                            AppFormat.currency(
                              item['price'],
                            ),
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
