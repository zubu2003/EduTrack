import 'package:edutrack/data/services/tts/tts_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextToSpeechService', () {
    test('builds speech text from numeric results and absent values', () {
      expect(
        TextToSpeechService.buildSpeechText([19, 20, -1, 17, null]),
        '19, 20, absent, 17',
      );
    });

    test('ignores empty results', () {
      expect(TextToSpeechService.buildSpeechText([]), '');
      expect(TextToSpeechService.buildSpeechText([null]), '');
    });
  });
}
