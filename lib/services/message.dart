import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ngl_app/model/message_model.dart';
import 'package:ngl_app/services/url.dart' as url;

class MessageServices {
  static Future<List<MessageModel>> getMessage() async {
    var uri = await Uri.parse(url.BaseUrl + "/message/get");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> data = body["data"];

      List<MessageModel> messages =
          data.map((item) => MessageModel.fromJson(item)).toList();
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<bool> postMessage(String author, String messageContent) async {
    var uri = await Uri.parse(url.BaseUrl + "/message/post");
    var response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'author': author,
          'message': messageContent,
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
