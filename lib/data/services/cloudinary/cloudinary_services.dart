import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import '../../../utils/constant/keys.dart';

class CloudinaryServices extends GetxController {
  static CloudinaryServices get instance => Get.find();

  final _dio = dio.Dio(
    dio.BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  Future<dio.Response> uploadImage(File image, String foldername) async {
    try {
      final api = SApiUrls.uploadApi(SKeys.cloudname);
      final fileName = image.path.split('/').last;

      final formData = dio.FormData.fromMap({
        'upload_preset': SKeys.uploadPreset,
        'folder': foldername,
        'file': await dio.MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      print('🔵 [Cloudinary] POST $api');
      print('🔵 [Cloudinary] preset=${SKeys.uploadPreset} folder=$foldername');
      print('🔵 [Cloudinary] file=$fileName');

      final response = await _dio.post(
        api,
        data: formData,
        options: dio.Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('🔵 [Cloudinary] status: ${response.statusCode}');
      print('🔵 [Cloudinary] body: ${response.data}');

      if (response.statusCode != 200) {
        throw _cloudinaryError(response.data) ??
            'failed to upload image (${response.statusCode})';
      }

      return response;
    } on dio.DioException catch (e) {
      print('❌ [Cloudinary] Dio status: ${e.response?.statusCode}');
      print('❌ [Cloudinary] Dio body: ${e.response?.data}');
      print('❌ [Cloudinary] Dio message: ${e.message}');
      throw _cloudinaryError(e.response?.data) ?? 'failed to upload image';
    } catch (e) {
      print('❌ [Cloudinary] $e');
      rethrow;
    }
  }

  Future<dio.Response> deleteImage(String publicId) async {
    try {
      final api = SApiUrls.deleteApi(SKeys.cloudname);
      final timeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      final signatureBase =
          'public_id=$publicId&timestamp=$timeStamp${SKeys.apiSecret}';
      final signature = sha1.convert(utf8.encode(signatureBase)).toString();

      final formData = dio.FormData.fromMap({
        'public_id': publicId,
        'api_key': SKeys.apiKey,
        'timestamp': timeStamp,
        'signature': signature,
      });

      final response = await _dio.post(api, data: formData);
      return response;
    } on dio.DioException catch (e) {
      print('❌ [Cloudinary delete] ${e.response?.data}');
      throw _cloudinaryError(e.response?.data) ?? 'Something went wrong';
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  String? _cloudinaryError(dynamic data) {
    if (data is Map && data['error'] is Map) {
      return data['error']['message']?.toString();
    }
    if (data is Map && data['error'] != null) {
      return data['error'].toString();
    }
    return null;
  }
}