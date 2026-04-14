import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../consts/cloudinary.dart';

class CloudinaryService {
  static Future<String> uploadProfileImage({
    required File imageFile,
    required String userId,
  }) async {
    try {
      final uniquePublicId =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}';
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/upload',
      );

      developer.log(
        '[Cloudinary] Upload start. userId=$userId publicId=$uniquePublicId folder=${CloudinaryConfig.folder} preset=${CloudinaryConfig.uploadPreset} filePath=${imageFile.path}',
        name: 'CloudinaryService',
      );

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = CloudinaryConfig.uploadPreset
        ..fields['folder'] = CloudinaryConfig.folder
        ..fields['public_id'] = uniquePublicId
        ..fields['tags'] = 'profile,$userId'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      developer.log(
        '[Cloudinary] Response status=${response.statusCode} body=$responseBody',
        name: 'CloudinaryService',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody) as Map<String, dynamic>;

        final secureUrl = decoded['secure_url'] as String?;

        if (secureUrl == null || secureUrl.isEmpty) {
          throw Exception(
              'Cloudinary upload succeeded but returned no image URL.');
        }

        return secureUrl;
      }

      String errorMessage =
          'Cloudinary upload failed with status ${response.statusCode}';
      try {
        final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
        errorMessage = decoded['error']?['message']?.toString() ?? errorMessage;
      } catch (_) {
        if (responseBody.isNotEmpty) {
          errorMessage = responseBody;
        }
      }

      throw Exception(errorMessage);
    } catch (e, st) {
      developer.log(
        '[Cloudinary] Upload exception: $e',
        name: 'CloudinaryService',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
