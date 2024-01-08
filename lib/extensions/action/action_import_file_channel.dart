import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class ImportFileChannel {
  static const String _eventChannelName =
      'com.lucas-goldner.golden-ios-extensions/import';
  static const EventChannel _eventChannel = EventChannel(_eventChannelName);

  Stream<List<ImportedFile>> getMediaStream() {
    final stream =
        _eventChannel.receiveBroadcastStream("media").cast<String?>();
    Stream<List<ImportedFile>> sharedMediaStream =
        stream.transform<List<ImportedFile>>(
      StreamTransformer<String?, List<ImportedFile>>.fromHandlers(
        handleData: (String? data, EventSink<List<ImportedFile>> sink) {
          if (data == null) {
            sink.add([]);
            return;
          }

          final List<ImportedFile> args = (json.decode(data) as List<dynamic>)
              .map((e) => ImportedFile.fromJson(e))
              .toList();

          sink.add(args);
        },
      ),
    );

    return sharedMediaStream;
  }
}

class ImportedFile {
  final String path;
  final String name;

  ImportedFile({required this.name, required this.path});

  factory ImportedFile.fromJson(Map<String, dynamic> json) => ImportedFile(
        name: json['name'],
        path: json['path'],
      );
}
