import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:edutrack/features/course/models/ct_data_model.dart';

class TextToSpeechService extends GetxService {
  static TextToSpeechService get instance => Get.find();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _isInitialized = true;
  }

  static String buildSpeechText(List<double?> marks) {
    final spokenValues = <String>[];

    for (final mark in marks) {
      final spokenValue = _normalizeMark(mark);
      if (spokenValue != null) {
        spokenValues.add(spokenValue);
      }
    }

    return spokenValues.join(', ');
  }

  static String? _normalizeMark(double? mark) {
    if (mark == null) return null;
    if (CtMark.isAbsent(mark)) return 'absent';

    final wholeNumber = mark.toInt();
    if ((mark - wholeNumber).abs() < 0.0001) {
      return wholeNumber.toString();
    }

    return mark.toStringAsFixed(0);
  }

  Future<void> speakMarks(List<double?> marks) async {
    final speechText = buildSpeechText(marks);
    if (speechText.isEmpty) return;

    await init();
    await _flutterTts.stop();
    await _flutterTts.speak(speechText);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
