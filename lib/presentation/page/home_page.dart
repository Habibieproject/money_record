import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/controller/c_home.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawerMenu(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              child: Row(
                children: [
                  Image.asset(AppAsset.profile, height: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hi,',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Obx(() {
                          return Text(
                            cUser.data.name ?? '',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          );
                        })
                      ],
                    ),
                  ),
                  Builder(builder: (context) {
                    return Material(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColor.kColorSecondary,
                      child: InkWell(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.menu,
                              color: AppColor.kColorPrimary,
                            ),
                          )),
                    );
                  })
                ],
              ),
            ),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              children: [
                Text(
                  "Pengeluaran Hari Ini",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                DView.spaceHeight(),
                cardToday(context),
                DView.spaceHeight(20),
                Center(
                  child: Container(
                    height: 5,
                    width: 80,
                    decoration: BoxDecoration(
                        color: AppColor.kColorBackground,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                DView.spaceHeight(30),
                Text(
                  "Pengeluaran Minggu Ini",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                DView.spaceHeight(),
                weekly(),
                DView.spaceHeight(30),
                Text(
                  "Pengeluaran Bulan Ini",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                DView.spaceHeight(),
                monthly(context),
              ],
            ))
          ],
        ));
  }

  Drawer drawerMenu() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              margin: const EdgeInsets.only(bottom: 0),
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Image.asset(AppAsset.profile, height: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              cUser.data.name ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          }),
                          Obx(() {
                            return Text(
                              cUser.data.email ?? '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300),
                            );
                          })
                        ],
                      ),
                    ),
                  ]),
                  Material(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColor.kColorPrimary,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Session.clearUser();
                          Get.off(() => const LoginPage());
                        },
                        child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ))),
                  )
                ],
              )),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            title: const Text("Tambah Baru"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.south_west),
            horizontalTitleGap: 0,
            title: const Text("Pemasukkan"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.north_east),
            horizontalTitleGap: 0,
            title: const Text("Pengeluaran"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.history),
            horizontalTitleGap: 0,
            title: const Text("Riwayat"),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }

  Row monthly(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          child: Stack(
            children: [
              Obx(() => DChartPie(
                    data: [
                      {'domain': 'income', 'measure': cHome.monthIncome},
                      {'domain': 'outcome', 'measure': cHome.monthOutcome},
                      if (cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                        {'domain': 'nol', 'measure': 1},
                    ],
                    fillColor: (pieData, index) {
                      switch (pieData['domain']) {
                        case 'income':
                          return AppColor.kColorPrimary;
                        case 'outcome':
                          return AppColor.kColorChart;

                        default:
                          return AppColor.kColorBackground.withOpacity(0.5);
                      }
                    },
                    donutWidth: 20,
                    labelColor: Colors.transparent,
                    showLabelLine: false,
                  )),
              Center(
                  child: Obx(() => Text(
                        "${cHome.percentIncome}%",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: AppColor.kColorPrimary),
                      )))
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.kColorPrimary,
                ),
                DView.spaceWidth(8),
                const Text("Pemasukan")
              ],
            ),
            DView.spaceHeight(8),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.kColorChart,
                ),
                DView.spaceWidth(8),
                const Text("Pengeluaran")
              ],
            ),
            DView.spaceHeight(20),
            Obx(() => Text(cHome.monthPercent)),
            DView.spaceHeight(10),
            const Text("Atau setara:"),
            Obx(() => Text(
                  AppFormat.currency(cHome.differentMonth.toString()),
                  style: const TextStyle(
                      color: AppColor.kColorPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ))
          ],
        )
      ],
    );
  }

  AspectRatio weekly() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() => DChartBar(
            data: [
              {
                'id': 'Bar',
                'data': List.generate(7, (index) {
                  return {
                    'domain': cHome.weekText()[index],
                    'measure': cHome.week[index]
                  };
                })
              }
            ],
            domainLabelPaddingToAxisLine: 8,
            axisLineTick: 2,
            axisLineColor: AppColor.kColorPrimary,
            measureLabelPaddingToAxisLine: 16,
            barColor: (barData, index, id) => AppColor.kColorPrimary,
            showBarValue: true,
          )),
    );
  }

  Material cardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      color: AppColor.kColorPrimary,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Obx(() => Text(
                AppFormat.currency(cHome.today.toString()),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.kColorSecondary),
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
          child: Obx(() => Text(
                cHome.todayPercent,
                style: const TextStyle(
                    fontSize: 16, color: AppColor.kColorBackground),
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'Selengkapnya',
                style: TextStyle(color: AppColor.kColorPrimary, fontSize: 16),
              ),
              Icon(
                Icons.navigate_next,
                color: AppColor.kColorPrimary,
              )
            ],
          ),
        )
      ]),
    );
  }
}
