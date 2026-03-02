import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class NotesService {
  //Warining           ***************************************
  //place your own matchine ip adress
  static const String apiUrl = 'http://your machine ip adress:3000/notes';

  /// GET NOTES
  Future<List<dynamic>> getNotes() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['notes'] ?? [];
      } else if (response.statusCode == 400) {
        throw Exception(data['message'] ?? 'Bad request');
      } else if (response.statusCode == 404) {
        throw Exception(data['message'] ?? 'Notes not found');
      } else if (response.statusCode == 500) {
        throw Exception(data['message'] ?? 'Server error');
      } else {
        throw Exception('Unexpected error occurred');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } on FormatException {
      throw Exception('Invalid response format');
    } on TimeoutException {
      throw Exception('Request timed out');
    }
  }

  /// CREATE NOTE
  Future<String> createNote(String title, String description) async {
    try {
      EasyLoading.show(status: 'Creating...');

      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"title": title, "description": description}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return data['message'] ?? 'Note created successfully';
      } else if (response.statusCode == 400) {
        throw Exception(data['message'] ?? 'Validation error');
      } else if (response.statusCode == 500) {
        throw Exception(data['message'] ?? 'Server error');
      } else {
        throw Exception('Failed to create note');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// DELETE NOTE
  Future<String> deleteNote(String id) async {
    try {
      EasyLoading.show(status: 'Deleting...');

      final response = await http
          .delete(Uri.parse('$apiUrl/$id'))
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['message'] ?? 'Note deleted successfully';
      } else if (response.statusCode == 404) {
        throw Exception(data['message'] ?? 'Note not found');
      } else if (response.statusCode == 500) {
        throw Exception(data['message'] ?? 'Server error');
      } else {
        throw Exception('Failed to delete note');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// UPDATE NOTE
  Future<String> updateNote(String id, String title, String description) async {
    try {
      EasyLoading.show(status: 'Updating...');

      final response = await http
          .patch(
            Uri.parse('$apiUrl/$id'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"title": title, "description": description}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['message'] ?? 'Note updated successfully';
      } else if (response.statusCode == 400) {
        throw Exception(data['message'] ?? 'Validation error');
      } else if (response.statusCode == 404) {
        throw Exception(data['message'] ?? 'Note not found');
      } else if (response.statusCode == 500) {
        throw Exception(data['message'] ?? 'Server error');
      } else {
        throw Exception('Failed to update note');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
