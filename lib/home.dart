import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/todo_model.dart';
import 'dart:convert';
import '../../url.dart';

class TdHome extends StatefulWidget {
  const TdHome({Key? key}) : super(key: key);

  @override
  _TdHomeState createState() => _TdHomeState();
}

class _TdHomeState extends State<TdHome> {
  List<Model> model = [];
  //...........................................................
  //text collecter
  TextEditingController DataController = TextEditingController();
  String Data = "";
  var ID = "";

  //..............................................
// add data to server
  AddData({data}) async {
    var parameter = {
     'tododata':data,
    };
    var url = "${base_url}insert.php";
    print(url);
    http.Response result = await http.post(
        Uri.parse(url),
        body: parameter);
    print("result from web : ${result.statusCode}");
    if (result.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.body)));
      gettododata();
    }
  }

  //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

  gettododata() async {
    var url = "${base_url}select.php";
    http.Response result =
    await http.post(Uri.parse(url));
    if (result.statusCode == 200) {
      Iterable l = json.decode(result.body);

      List<Model> ModelList =
      List<Model>.from(l.map((model) => Model.fromJson(model)));
      setState(() {
        model = ModelList;
      });
    }
  }
  //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

  @override
  void initState() {
    gettododata();
  }
  //................................................................
  deletedata(id) async {
    var params = {
      "ID": id,
    };
    var url = "${base_url}delete.php";
    http.Response result = await http
        .post(Uri.parse(url), body: params);
    print("result from web : ${result.statusCode}");
    if (result.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result.body)));
      gettododata();

    }
  }
  //,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  void showalertdialogue() {
    showDialog(
        context: context,
        builder: (Context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Add task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: DataController,
                    decoration: InputDecoration(hintText: "Add a task"),
                  ),
                  Row(
                    children: [
                      RaisedButton(
                        onPressed: () {
                          Data = DataController.text;
                          DataController.clear();
                           AddData(data: Data);
                          Navigator.of(context).pop(showalertdialogue);
                        },
                        child: Text("Add"),
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  Widget mycard({required String Tododata, required id}) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
            title: Text(Tododata),
            subtitle: Text(id),
            onLongPress: () {
               deletedata(id);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showalertdialogue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.purpleAccent,
      ),
      appBar: AppBar(
        title: Center(child: Text("Todo App")),
        backgroundColor: Colors.black,
      ),
      //.....................................
      backgroundColor: Colors.grey,
      body: ListView.builder(
          itemCount: model.length,
          itemBuilder: (context, i) {
            Model models =model.elementAt(i);
            return mycard(
                id: models.id!,
                Tododata: models.Tododata!);
          }),
    );
  }
}

//second _https://www.youtube.com/watch?v=BDWZlUyQZF0
//first_https://www.youtube.com/watch?v=M3IwPbjOXmw
