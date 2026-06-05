import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Même port que le frontend, pas de problème de CORS
  static const String baseUrl = '/api';
  
  String? _token;

  Map<String, String> get headers {
    final h = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      h['Authorization'] = 'Bearer $_token';
    }
    return h;
  }

  void setToken(String? token) {
    _token = token;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        return data;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Échec de connexion');
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/stats'), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erreur chargement stats');
  }

  Future<List<dynamic>> getRecentPointages() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/recent-pointages'), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erreur chargement pointages');
  }

  Future<List<dynamic>> getEmployees() async {
    final response = await http.get(Uri.parse('$baseUrl/employees'), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erreur chargement employés');
  }
}
