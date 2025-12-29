import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company.dart';

class ApiService {
  static const String url =
      'https://fake-json-api.mock.beeceptor.com/companies';

  static Future<List<Company>> fetchCompanies() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Company.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }
}
