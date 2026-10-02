import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiService {
  final String url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}