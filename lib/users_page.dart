import 'dart:convert';

import 'package:flutter/material.dart';
import 'user.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  Future<void> fetchUsers() async {
    String apiAddress = 'https://jsonplaceholder.typicode.com/users';
    final response = await http.get(Uri.parse(apiAddress));
    if (response.statusCode == 200) {
      // Successful response, parse the data
      List<dynamic> apiResponse = json.decode(response.body);
      users = apiResponse.map((item) => User.fromJson(item)).toList();
    } else {
      // Error in response, print the error
      print("Error Status Code = ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Users Page',
          ),
        ),
        body: FutureBuilder(
          future: fetchUsers(),
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
                  return usersView();
                }
            }
          },
        ));
  }

  ListView usersView() {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => Card(
              child: ExpansionTile(
                  title: Text(users[index].name ?? 'Anonymous'),
                  subtitle: Text(users[index].username ?? ''),
                  leading: CircleAvatar(
                    child: Text(
                        "${users[index].name![0]} ${users[index].name![users[index].name!.indexOf(' ') + 1]}"),
                  ),
                  children: [
                    ListTile(
                      title: const Text("Contact info:"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.email),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () =>
                                    _launchUrl(users[index].email, "email"),
                                child: Text(users[index].email ?? ''),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.phone),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: () =>
                                    _launchUrl(users[index].phone, "phone"),
                                child: Text(users[index].phone ?? ''),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.language),
                              const SizedBox(width: 10),
                              Text(users[index].website ?? ''),
                              TextButton(
                                onPressed: () =>
                                    _launchUrl(users[index].website, "web"),
                                child: Text(users[index].website ?? ''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          const Text("Address :"),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () => _launchUrl(
                                  'http://maps.google.com/maps?daddr=${users[index].address!.geo!.lat},${users[index].address!.geo!.lng}&amp;ll=',
                                  "map"),
                              child: const Text("open in Maps")),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(users[index].address!.suite ?? ''),
                          Text(users[index].address!.street ?? ''),
                          Text(users[index].address!.city ?? ''),
                          Text(users[index].address!.zipcode ?? ''),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(users[index].company!.name ?? ''),
                      subtitle: Column(
                        children: [
                          Text(users[index].company!.catchPhrase ?? ''),
                          Text(users[index].company!.bs ?? ''),
                        ],
                      ),
                    ),
                  ]),
            ));
  }

  Future<void> _launchUrl(url, type) async {
    Uri uri;
    if (type.toLowerCase() == "web") {
      uri = Uri.parse(
          "https://www.gzaas.com/preview/preview?gs_form=%22$url%22");
    } else if (type.toLowerCase() == "phone") {
      uri = Uri.parse("tel:$url");
    } else if (type.toLowerCase() == "email") {
      uri = Uri.parse("mailto:$url");
    } else if (type == "map") {
      uri = Uri.parse(url);
    } else {
      return;
    }
    try {
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      print(e);
    }
  }
}
