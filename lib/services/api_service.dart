import '../models/workout.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String? token;
  // Use 10.0.2.2 for Android emulator, c192.168.x.x for physical device
  static const String baseUrl = 'http://192.168.100.8:5000/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        token = data['token'];
        return data;
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {'message': 'Error connecting to server: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      
      if (res.statusCode == 201 || res.statusCode == 200) {
        final data = jsonDecode(res.body);
        token = data['token'];
        return data;
      } else {
        return jsonDecode(res.body);
      }
    } catch (e) {
      return {'message': 'Error connecting to server: $e'};
    }
  }
}

class WorkoutService {
  static const String baseUrl = 'http://192.168.100.8:5000/api/workout';
  static String? token;

  static Map<String, String> headers() => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiService.token}',
  };

  static Future<List<Workout>> getWorkouts() async {
    try {
      if (ApiService.token == null) {
        throw Exception('No authentication token. Please login first.');
      }
      
      final res = await http.get(
        Uri.parse(baseUrl),
        headers: headers(),
      );
      
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        return data.map((e) => Workout.fromJson(e)).toList();
      } else if (res.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to load workouts: ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      throw Exception('Error fetching workouts: $e');
    }
  }

  static Future<Workout> createWorkout(Workout workout) async {
    try {
      if (ApiService.token == null) {
        throw Exception('No authentication token. Please login first.');
      }
      
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: headers(),
        body: jsonEncode(workout.toJson()),
      );
      
      if (res.statusCode == 201) {
        return Workout.fromJson(jsonDecode(res.body));
      } else if (res.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        throw Exception('Failed to create workout: ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      throw Exception('Error creating workout: $e');
    }
  }

  static Future<Workout> updateWorkout(String id, Workout workout) async {
    try {
      if (ApiService.token == null) {
        throw Exception('No authentication token. Please login first.');
      }
      
      final res = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: headers(),
        body: jsonEncode(workout.toJson()),
      );
      
      if (res.statusCode == 200) {
        return Workout.fromJson(jsonDecode(res.body));
      } else if (res.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (res.statusCode == 404) {
        throw Exception('Workout not found.');
      } else {
        throw Exception('Failed to update workout: ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      throw Exception('Error updating workout: $e');
    }
  }

  static Future<void> deleteWorkout(String id) async {
    try {
      if (ApiService.token == null) {
        throw Exception('No authentication token. Please login first.');
      }
      
      final res = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: headers(),
      );
      
      if (res.statusCode == 200) {
        return;
      } else if (res.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (res.statusCode == 404) {
        throw Exception('Workout not found.');
      } else {
        throw Exception('Failed to delete workout: ${res.statusCode} - ${res.body}');
      }
    } catch (e) {
      throw Exception('Error deleting workout: $e');
    }
  }
}
