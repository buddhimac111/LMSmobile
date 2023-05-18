import 'dart:io';
import 'package:excel_dart/excel_dart.dart';
import 'package:http/http.dart' as http;

class GetTimetable {
  static List<String> subjects = [];

  static Future<void> readExcelFromSharePoint(String fileUrl) async {
    subjects = [];
    // Download the Excel file from SharePoint
    final response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      // Create an Excel workbook from the downloaded file
      final bytes = response.bodyBytes;
      final excel = Excel.decodeBytes(bytes);

      // Access the worksheet
      final sheet = excel.tables['PLY Batch 10'];

      if (sheet == null) {
        subjects = ["-1", "worksheet not found"];
        return;
      }
      var dataRow = -1;
      var dataCell = -1;
      for (var i = 0; i < (sheet?.rows.length ?? 0); i++) {
        for (var j = 0; j < (sheet?.rows[i].length ?? 0); j++) {
          if (sheet?.rows[i][j]?.value == null) continue;
          try {
            var date = DateTime.parse(sheet?.rows[i][j]?.value);
            if (date.toString().split(" ")[0] ==
                DateTime.now().toString().split(" ")[0]) {
              dataRow = i;
              dataCell = j;
            }
          } catch (ex) {
            continue;
          }
        }
      }
      for (int i = dataRow + 1; i < (sheet?.rows.length ?? 0); i++) {
        if (sheet?.rows[i][0]?.value == null) break;
        if(sheet?.rows[i][dataCell]?.value == null) continue;
        subjects.add(
            '${sheet?.rows[i][0]?.value} - ${sheet?.rows[i][dataCell]?.value}');
      }
      if(subjects.isEmpty) {
        subjects = ["0", "No Lectures Today"];
      }
    } else {
      subjects = [
        "-1",
        'Failed to download the file. Status code: ${response.statusCode}'
      ];
    }
  }
}