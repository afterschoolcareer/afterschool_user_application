import 'package:http/http.dart' as http;
class StudentAuth {

  static var client = http.Client();
  static String baseUrl = 'https://afterschoolcareer.com:8080/studentLogin/';

  static Future<dynamic> get(String phoneNumber, String password) async {
    var uri = Uri.parse('$baseUrl?phone_number=$phoneNumber&password=$password');
    var response = await client.get(uri);
    return response.statusCode;
  }

  static Future<dynamic> post(String name, String phoneNumber, String password,
      String email, String studentType) async{
     Map<String,String> studentData = {
      "name" : name,
       "phone_number" : phoneNumber,
       "password" : password,
       "email" : email,
       "std" : studentType
    } ;
     var uri = Uri.parse(baseUrl);
     var response = await client.post(uri, body: studentData);
     return response.statusCode;
  }
}