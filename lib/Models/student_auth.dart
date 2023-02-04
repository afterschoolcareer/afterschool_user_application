import 'package:http/http.dart' as http;
class StudentAuth {
  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/studentLogin/?phone_number=123456789&password=abc321';
  static Future<dynamic> get() async {
    var uri = Uri.parse(baseUrl);
    var response = await client.get(uri);
    if(response.statusCode == 200) {
      print('successful : ${response.body}');
    }
  }
}