import 'package:intl/intl.dart';

class AppFormat {
  static String date(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate); //2022-02-25
    return DateFormat('d MMM yyy', 'id_ID').format(dateTime); // 5 Feb 2022
  }

  static String currency(String number) {
    return NumberFormat.currency(
            decimalDigits: 2, locale: 'id_ID', symbol: 'Rp ')
        .format(double.parse(number));
  }
}
