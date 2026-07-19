import 'package:tall_us/core/utils/logger.dart';

/// Mobile/desktop stub for triggering a CSV download.
///
/// On native platforms there's no browser download. A future improvement can
/// use `share_plus` / `path_provider` to save or share the file. For now we
/// log and no-op so the app compiles and runs on iOS/Android without crashing.
void triggerCsvDownload(String filename, String csvString) {
  AppLogger.i(
      'CSV export skipped on native (no browser download): $filename.csv');
}
