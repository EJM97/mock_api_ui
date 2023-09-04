import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  int? userId;
  int? id;
  String? title;
  String? body;
  String? userName;

  Post({this.userId, this.id, this.title, this.body, this.userName});

  Post.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
    // getUserName();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }

//public method
  Future<void> fetchUserName() async {
    String apiAddress = 'https://jsonplaceholder.typicode.com/users/${userId}/';
    final response = await http.get(Uri.parse(apiAddress));
    if (response.statusCode == 200) {
      // Successful response, parse the data
      Map<String, dynamic> user = json.decode(response.body);
      userName = user["username"];
      // this.userName = userName;
    } else {
      // Error in response, print the error
      print("Error Status Code = ${response.statusCode}");
      userName = "Anonymous";
    }
  }
}
