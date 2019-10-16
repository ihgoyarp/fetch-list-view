import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';

class Post {
  String name;
  String address;
  String phone;

  Post({this.name, this.address, this.phone});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'].toString(),
      address: json['address'].toString(),
      phone: json['phone'].toString(),
    );
  }
}

class CustomListView extends StatelessWidget {

  List teachers = [];

  CustomListView(this.teachers);

  @override
  Widget build(BuildContext context) {
    return (
        ListView.builder(
          itemCount: teachers.length,
          itemBuilder: (BuildContext context, int index) {
            return createviewItem(teachers[index], context);
          },
        )
    );
  }

  Widget createviewItem(Post teachers, BuildContext context) {
    return ListTile(
        title: new Card(
            child: new Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue)),
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(20.0),
              child: Column(children: <Widget>[
                new Text(teachers.name),
                new Text(teachers.address),
                new Text(teachers.phone)
              ],),
            )
        )
    );
  }

}


Future<List<Post>> downloadJSON() async {
//  final jsonEndpoint = "http://www.alkadhum-col.edu.iq/Teachers%20Activities/get.php";
  final jsonEndpoint = "http://192.168.100.16/restci/person";
  final response = await get(jsonEndpoint);
  if (response.statusCode == 200) {
    List teachers = json.decode(response.body);
    return teachers.map(
            (teacher) => new Post.fromJson(teacher)
    ).toList();
  }

  else {
    throw Exception("Unable to get JSON data");
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new Scaffold(
        appBar: new AppBar(title: const Text('Flutter and PHP')),
        body: new Center(

          child: new FutureBuilder<List<Post>>(
            future: downloadJSON(),

            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Post> teachers = snapshot.data;
                return new CustomListView(teachers);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              //return  a circular progress indicator.
              return new CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
void main() {
  runApp(MyApp());
}