class DateFormatter {

  static String strToDateFormat(String? date) {
    final toDate = DateTime.parse(date!);

    return "${toDate.day}/${toDate.month}/${toDate.year}";
  }
}