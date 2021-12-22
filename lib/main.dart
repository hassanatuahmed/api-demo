import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future getUserData() async {
    final response =
        await http.get(Uri.https('jsonplaceholder.typicode.com', '/users'));
    var jsonData = jsonDecode(response.body);
    List<User> users = [];
    for (var u in jsonData) {
      // ignore: unused_local_variable
      User user = User(
        u['email'],
        u['name'],
        u['username'],
      );
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text("${snapshot.data[i].name}"),
                        subtitle: Text("${snapshot.data[i].username}"),
                        trailing: Text("${snapshot.data[i].email}"),
                      );
                    });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class User {
  final String email;
  final String name;
  final String username;

  User(this.email, this.name, this.username);
}
