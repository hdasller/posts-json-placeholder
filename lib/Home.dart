import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restfull/Post.dart';
import 'package:http/http.dart' as http;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Post> _posts = List();
  String url = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Post>> _recuperarPosts() async {
    http.Response response = await http.get(url);
    Iterable l = json.decode(response.body);
    var tagObjsJson = jsonDecode(response.body) as List;
    _posts = tagObjsJson.map((tagJson) => Post.fromJson(tagJson)).toList();
    return _posts;
  }

  void save(Post post) async {
    Map<String, dynamic> map = post.toJson();
    http.Response response = await http.post(
      url,
      headers: {
      "Content-type": "application/json; charset=UTF-8"
    },
    body: json.encode(map),
    );
    print(response.statusCode);
    setState(() {
     _posts.insert(0, post);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Icon(
              Icons.import_contacts,
            ),
            Text("bla"),
          ],
        ),
      ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Salvar"),
                    onPressed: (){print("Print"); save(Post(101,101,"bla", "bla"));},
                  )
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _recuperarPosts(),
                  builder: (context,snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        print("Conexao done");
                        if(snapshot.hasError){
                          print("Teste");
                          return Text("Error");
                        }else{
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List<Post> lista = snapshot.data;
                                Post post = lista[index];
                                return ListTile(
                                  title: Text(
                                      post.title
                                  ),
                                  subtitle: Text(
                                      post.id.toString()
                                  ),
                                );
                              }
                          );
                        }
                        break;
                    }
                  },
                )
                ,
              )
            ],
          ),
        )
    );
  }
}
