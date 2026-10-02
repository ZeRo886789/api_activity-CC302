import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:sla_api_activity/models/post.dart';
import 'package:sla_api_activity/services/api_service.dart';

void main() {
  group('Post model', () {
    test('fromJson maps every field', () {
      final post = Post.fromJson({
        'userId': 1,
        'id': 7,
        'title': 'a title',
        'body': 'a body',
      });

      expect(post.userId, 1);
      expect(post.id, 7);
      expect(post.title, 'a title');
      expect(post.body, 'a body');
    });
  });

  group('ApiService', () {
    test('returns a list of Post on 200', () async {
      final service = ApiService(
        client: MockClient((request) async {
          expect(request.method, 'GET');
          expect(
            request.url.toString(),
            'https://jsonplaceholder.typicode.com/posts',
          );
          return http.Response(
            jsonEncode([
              {'userId': 1, 'id': 1, 'title': 'first', 'body': 'one'},
              {'userId': 2, 'id': 2, 'title': 'second', 'body': 'two'},
            ]),
            200,
          );
        }),
      );

      final posts = await service.fetchPosts();

      expect(posts.length, 2);
      expect(posts.first.title, 'first');
      expect(posts.last.id, 2);
    });

    test('throws on non-200 response', () {
      final service = ApiService(
        client: MockClient((_) async => http.Response('nope', 500)),
      );

      expect(
        service.fetchPosts(),
        throwsA(isA<Exception>()),
      );
    });

    test('parses the live JSONPlaceholder endpoint', () async {
      final realOverrides = HttpOverrides.current;
      HttpOverrides.global = null;
      addTearDown(() => HttpOverrides.global = realOverrides);

      final service = ApiService();
      final posts = await service.fetchPosts();

      expect(posts, isNotEmpty);
      expect(posts.length, 100);
      expect(posts.first, isA<Post>());
      expect(posts.first.id, 1);
      expect(posts.first.userId, 1);
      expect(posts.first.title, isNotEmpty);
      expect(posts.first.body, isNotEmpty);
      expect(posts.last.id, 100);
    }, timeout: const Timeout(Duration(seconds: 60)));
  });
}