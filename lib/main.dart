import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp( MyApp());
}
 Future<Album> fetchAlbum() async{

  final response =await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  if(response.statusCode==200){
    return(Album.fromJson(jsonDecode(response.body)));

  }else{
    throw Exception('Failed To Load Album');
  }
 }


 Future<Album>updateAlbum(String title) async{
  final response =await http.put(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  headers:<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  body: jsonEncode(<String ,String>{'title':title});
if(response.statusCode == 200){
  return(Album.fromJson(jsonDecode(response.body)));
}else{
  throw Exception('Failed To Update Album');
}
  }

  class Album{
  final int userId;
  final String name;
  final String email;

  Album({
    required this.userId,
    required this.name,
    required this.email});
  factory Album.fromJson(Map<String, dynamic> json){
    return Album(
        userId: json ['userId'],
        name: json ['name'],
        email: json ['email']);
  }
  }

class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState() => _MyAppState() ;

  }

class _MyAppState extends State<MyApp> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController  _controller2 = TextEditingController();

late  Future<Album>  futureAlbum;

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    futureAlbum = fetchAlbum();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title: Text('Update The Data'),
        ),
        body: Container(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context,snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.userId.toString()),
                      Text(snapshot.data!.email.toString()),
                      Text(snapshot.data!.name.toString()),

                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Enter UserId'),

                      ),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Enter Name'),
                      ),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Enter Email'),
                      ),
                     ElevatedButton(
                         onPressed: (){
                           setState(() {
                             futureAlbum = updateAlbum(_controller.text);
                             futureAlbum = updateAlbum(_controller1.text);
                             futureAlbum = updateAlbum(_controller2.text);
                           });
                         },
                         child: Text('Update Data'))


                    ],

                  );

                }else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }

              }
              return CircularProgressIndicator();
            }

          ),

        ),
      ),
    );

  }

}

