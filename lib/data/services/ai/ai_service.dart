import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../utils/constant/api.dart';

class AIService extends GetxController {
  static AIService get instance => Get.find();

  final _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  /// Send a prompt to the Cloudflare Worker → Gemini
  /// Returns the AI's text response.
  Future<String> ask(String prompt) async {
    try {
      final api = SApiUrls.aiProxyUrl;

      print('🔵 [AI] POST $api');
      print('🔵 [AI] prompt length: ${prompt.length}');

      final response = await _dio.post(
        api,
        data: {'prompt': prompt},
      );

      print('🔵 [AI] status: ${response.statusCode}');
      print('🔵 [AI] body: ${response.data}');

      if (response.statusCode != 200) {
        throw _aiError(response.data) ??
            'AI request failed (${response.statusCode})';
      }

      final data = response.data;
      if (data is Map && data['response'] != null) {
        return data['response'].toString();
      }

      throw 'AI returned an empty response';
    } on dio.DioException catch (e) {
      print('❌ [AI] Dio status: ${e.response?.statusCode}');
      print('❌ [AI] Dio body: ${e.response?.data}');
      print('❌ [AI] Dio message: ${e.message}');
      throw _aiError(e.response?.data) ?? 'AI request failed';
    } catch (e) {
      print('❌ [AI] $e');
      rethrow;
    }
  }

  /// Parse the Worker / Gemini error payload into a readable message
  String? _aiError(dynamic data) {
    if (data is Map && data['error'] != null) {
      return data['error'].toString();
    }
    return null;
  }
}