import 'dart:convert';

import 'package:flutter/material.dart';
import 'post.dart';
import 'package:http/http.dart' as http;

import 'comments_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // changes in posts have to be reflected in the UI

  List<Post> posts = [];

  Future<void> fetchPost() async {
    String apiAddress = 'https://jsonplaceholder.typicode.com/posts/';
    final response = await http.get(Uri.parse(apiAddress));
    if (response.statusCode == 200) {
      // Successful response, parse the data
      List<dynamic> apiResponse = json.decode(response.body);
      posts = apiResponse.map((item) => Post.fromJson(item)).toList();
      Map userNameMap = {}; // memoize to reduce api calls for same user
      for (var post in posts) {
        if (userNameMap.keys.contains(post.userId)) {
          post.userName = userNameMap[post.userId];
        } else {
          await post.fetchUserName();
          userNameMap[post.userId] = post.userName;
        }
      }
    } else {
      // Error in response, print the error
      print("Error Status Code = ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPost(),
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
              return postView();
            }
        }
      },
    );
  }

  ListView postView() {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => Card(
        child: PostCard(post: posts[index]),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            height: 40,
            color: const Color.fromARGB(255, 26, 2, 68),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Posted by: ${post.userName}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ]),
          ),
          Row(children: [
            Expanded(
              child: Text(
                post.title ?? "",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          SizedBox(
            height: 179,
            child: Row(children: [
              Flexible(
                child: Text('${post.body}'),
              ),
            ]),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              IconButton(
                onPressed: () => _showCommentSheet(context),
                icon: const Icon(FontAwesomeIcons.comment),
              ),
              const Text("Comments"),
            ]),
          ),
        ],
      ),
    );
  }

  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          widthFactor: 0.98, // Set the width factor to 1.0 to occupy full width
          heightFactor: 0.9,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Comments',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                CommentsPage(const Key('commentPage'), post.id.toString()),
              ],
            ),
          ),
        );
      },
    );
  }
}
