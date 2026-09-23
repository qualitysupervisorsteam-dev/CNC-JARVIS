import 'dart:convert';
import 'package:http/http.dart' as http;

class CncJarvisApi {
  CncJarvisApi({String? baseUrl}) : baseUrl = baseUrl ?? const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
  final String baseUrl;

  Future<bool> health() async {
    final response = await http.get(Uri.parse('$baseUrl/health')).timeout(const Duration(seconds: 8));
    return response.statusCode == 200 && jsonDecode(response.body)['status'] == 'ok';
  }

  Future<Map<String, dynamic>> capabilities() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/capabilities')).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) throw StateError('Backend capabilities failed: ${response.statusCode}');
    return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
  }
}
