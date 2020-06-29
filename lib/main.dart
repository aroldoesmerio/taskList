import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _readData().then((data) {
        _toDoList = json.decode(data);
      });
    });
  }

  void addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    addToDo();
                  },
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_toDoList[index]["title"]),
                  value: _toDoList[index]["ok"],
                  secondary: CircleAvatar(
                    child: Icon(
                        _toDoList[index]["ok"] ? Icons.check : Icons.error),
                  ),
                  onChanged: (c) {
                    setState(() {
                      _toDoList[index]["ok"] = c;
                      _saveData();
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

/*

** ====== Consumo da API ===== ** 
1 - import 'package:path_provider/path_provider.dart';
2 - Criar o getFile() para obter os dados 
  2.1 - para o File funcionar é necessário importar dart:io 
    Future<File> _getFile() async{
      final directory = await getApplicationDocumentsDirectory(); 
      return File("${directory.path}/data.json");
    }
3 - Criar o saveData para salvar os dados
  3.1 - Antes de criar o save data criar uma Lista vazia 
    3.1.1 = 
      class _MyHomeState extends State<MyHome> {
        List _toDoList = []; 
      @override
  3.2 - Criar o Future saveData() e colocar tanto o getFile quanto o saveData 
  dentro da Classe _MyHomeState
      Future<File> _saveData() async{
        String data = json.encode(_toDoList);
        final file = await _getFile();
        return file.writeAsString(data);
      }
4 - Criar o readData 
    Future<String> _readData() async{
        try {
          final file = await _getFile();
          return file.readAsString(); 
        } 
        catch (e) {
            return null; 
        }
    }
5 - Criar o initState para persistir os dados
class _MyHomeState extends State<MyHome> {
  final _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _readData().then((data) {
        _toDoList = json.decode(data);
      });
    });
  }

  6 - Método _addToDo, Logo abaixo do initstate 

     void addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

*/
