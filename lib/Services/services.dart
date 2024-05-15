//All todo API will be here
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nexoft_task/photopicker.dart';

class ContactsService {
  static Future<bool> deleteById(String id) async {
    final url = 'http://146.59.52.68:11235/api/User/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri, headers: {
      'accept': 'text/plain',
      'ApiKey': 'cb0a12cb-7c38-494c-91e7-1c1aea4adaec',
    });
    return response.statusCode == 200;
  }

  static Future<List?> fetchContacts() async {
    const url = 'http://146.59.52.68:11235/api/User';
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
    const url = 'http://146.59.52.68:11235/api/User';
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
    const url = 'http://146.59.52.68:11235/api/User/UploadImage';
    final uri = Uri.parse(url);

    var request = http.MultipartRequest('POST', uri);

    request.headers['ApiKey'] = 'cb0a12cb-7c38-494c-91e7-1c1aea4adaec';
    request.headers['accept'] = 'text/plain';
    request.headers['Content-Type'] = 'multipart/form-data';

    var multipartFile = await http.MultipartFile.fromPath('image=', filePath);
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.toString();
      Map<String, dynamic> responseJson =
          jsonDecode(responseBody) as Map<String, dynamic>;
      if (responseJson['success'] == true) {
        String imageUrl = responseJson['data']['imageUrl'] as String;
        print('Image uploaded successfully! URL: $imageUrl');
        currentPhoto = null;
        return imageUrl;
      } else {
        print('Error uploading image: ${response.statusCode}');
        currentPhoto = null;
        return null;
      }
    } else {
      print('Error uploading image: ${response.statusCode}');
      currentPhoto = null;

      return null;
    }
  }
}
