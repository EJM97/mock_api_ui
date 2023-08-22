// import 'dart:async';

import 'package:flutter/material.dart';

import 'users_page.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI for API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          // secondary: Colors.red,
          // primary: Colors.blue
        ),
        useMaterial3: true,
      ),
      // home: const MapSample(),
      home: const UsersPage(),
    );
  }
}
