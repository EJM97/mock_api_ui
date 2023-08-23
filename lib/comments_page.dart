import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'comment.dart';

class CommentsPage extends StatefulWidget {
  final String index;
  const CommentsPage(Key? key, this.index) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentsPage> {
  List<Comment> comments = [];
  Future<void> fetchComment() async {
    String apiAddress =
        'https://jsonplaceholder.typicode.com/posts/${widget.index}/comments';
    final response = await http.get(Uri.parse(apiAddress));
    if (response.statusCode == 200) {
      // Successful response, parse the data
      List<dynamic> apiResponse = json.decode(response.body);
      comments = apiResponse.map((item) => Comment.fromJson(item)).toList();
    } else {
      // Error in response, print the error
      print("Error Status Code = ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchComment(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('none');
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            return const Text('active');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return commentView();
            }
        }
      },
    );
  }

  commentView() {
    return SizedBox(
        height: 499,
        child: ListView.builder(
          itemCount: comments.length,
          itemBuilder: (context, index) => Card(
            child: Column(
              children: [
                const SizedBox(width: 10),
                ListTile(
                  // title: Text(comments[index].name ?? 'Comment title'),
                  subtitle: FilterChip(
                    labelPadding: const EdgeInsets.all(-2),
                    label: Text(
                      comments[index].email ?? 'Anonymous',
                      style: TextStyle(fontSize: 8),
                    ),
                    onSelected: (bool value) {},
                  ),
                ),
                Text(
                  comments[index].body ?? '',
                  style: TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ));
  }
}
