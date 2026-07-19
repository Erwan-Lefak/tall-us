import 'package:csv/csv.dart';
import 'package:tall_us/core/utils/logger.dart';

// Conditional import: web impl uses dart:html; the stub (mobile/desktop) is a
// no-op. This keeps dart:html out of the mobile build so it compiles natively.
import 'csv_download_stub.dart' if (dart.library.html) 'csv_download_web.dart';

/// Utility class for exporting data to CSV.
class CsvExport {
  /// Build CSV from headers/rows and trigger a download (web) / no-op (native).
  static void download({
    required String filename,
    required List<String> headers,
    required List<Map<String, dynamic>> rows,
  }) {
    try {
      final csvData = <List<dynamic>>[headers];
      for (final row in rows) {
        csvData.add(headers.map((h) => row[h] ?? '').toList());
      }
      final csvString = const CsvEncoder().convert(csvData);

      triggerCsvDownload(filename, csvString);

      AppLogger.i('CSV exported: $filename.csv (${rows.length} rows)');
    } catch (e) {
      AppLogger.e('Failed to export CSV', error: e);
      rethrow;
    }
  }

  /// Export users data
  static void exportUsers(List<Map<String, dynamic>> users) {
    download(
      filename: 'tallus_users_${_dateStamp()}',
      headers: [
        'id', 'email', 'displayName', 'gender', 'role',
        'countryCode', 'city', 'emailVerified', 'status', 'createdAt',
      ],
      rows: users,
    );
  }

  /// Export verifications data
  static void exportVerifications(List<Map<String, dynamic>> verifications) {
    download(
      filename: 'tallus_verifications_${_dateStamp()}',
      headers: [
        'id', 'userId', 'claimedHeightCm', 'status',
        'submittedAt', 'reviewedAt', 'rejectionReason',
      ],
      rows: verifications,
    );
  }

  /// Export analytics KPIs
  static void exportKpis(Map<String, dynamic> kpiData) {
    download(
      filename: 'tallus_analytics_${_dateStamp()}',
      headers: kpiData.keys.toList(),
      rows: [kpiData],
    );
  }

  static String _dateStamp() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }
}
