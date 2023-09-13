import 'package:flutter/services.dart';

void copyToClipboard(String url)async{
  final data = ClipboardData(text: url);
  await Clipboard.setData(data);
}