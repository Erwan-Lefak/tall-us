import 'dart:html' as html;
import 'dart:convert';

/// Web implementation: triggers a browser download of the CSV string.
void triggerCsvDownload(String filename, String csvString) {
  // UTF-8 with BOM for Excel compatibility.
  final bytes = utf8.encode('﻿$csvString');
  final blob = html.Blob([bytes]);

  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', '$filename.csv')
    ..click();

  html.Url.revokeObjectUrl(url);
}
