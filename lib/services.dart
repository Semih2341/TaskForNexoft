//All todo API will be here
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nexoft_task/home.dart';
import 'package:nexoft_task/image.dart';

class ContactsService {
  // ... (other class members remain the same)

  static Future<bool> deleteById(String id) async {
    // Add your code here
    final url = 'http://146.59.52.68:11235/api/User/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri, headers: {
      'accept': 'text/plain',
      'ApiKey': 'cb0a12cb-7c38-494c-91e7-1c1aea4adaec',
    });
    return response.statusCode == 200;
  }

  static Future<List?> fetchContacts() async {
    // Add your code here
    final url = 'http://146.59.52.68:11235/api/User';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'accept': 'text/plain',
        'ApiKey': 'cb0a12cb-7c38-494c-91e7-1c1aea4adaec',
      },
    );
    print('Data Yakalama' + response.body.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as Map;
      final users = data['users'] as List;
      return users;
    } else {
      return null;
    }
  }

  static Future<bool> updateToDo(String id, Map body) async {
    final url = 'http://146.59.52.68:11235/api/User/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'accept': 'application/json',
        'ApiKey': 'cb0a12cb-7c38-494c-91e7-1c1aea4adaec',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> addToDo(Map body) async {
    final url = 'http://146.59.52.68:11235/api/User';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'accept': 'application/json',
        'ApiKey': 'cb0a12cb-7c38-494c-91e7-1c1aea4adaec',
        'Content-Type': 'application/json',
      },
    );
    print(response.statusCode);
    return response.statusCode == 200;
  }

  static Future<String?> uploadImage(String filePath) async {
    // Replace with your actual API endpoint
    final url = 'http://146.59.52.68:11235/api/User/UploadImage';
    final uri = Uri.parse(url);

    var request = http.MultipartRequest('POST', uri);

    // Add the API key to the authorization header
    request.headers['ApiKey'] = 'cb0a12cb-7c38-494c-91e7-1c1aea4adaec';
    request.headers['accept'] = 'text/plain';
    // Set the content type header
    request.headers['Content-Type'] = 'multipart/form-data';

    var multipartFile = await http.MultipartFile.fromPath('image=', filePath);
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody =
          await response.stream.toString(); // Get response body
      Map<String, dynamic> responseJson =
          jsonDecode(responseBody) as Map<String, dynamic>;
      if (responseJson['success'] == true) {
        // Check for success in response
        String imageUrl = responseJson['data']['imageUrl'] as String;
        print('Image uploaded successfully! URL: $imageUrl');
        currentPhoto = null;
        return imageUrl;
      } else {
        print('Error uploading image: ${response.statusCode}');
        currentPhoto = null;
        return null; // Indicate error
      }
    } else {
      print('Error uploading image: ${response.statusCode}');
      currentPhoto = null;

      return null; // Indicate error
    }
  }
}
