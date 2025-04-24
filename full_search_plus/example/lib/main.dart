import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:full_search_plus_example/demo.dart';
import 'package:full_search_plus/full_search_plus.dart';
import 'package:full_search_plus_example/search_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Result> _result = [];
  TextEditingController resultController = TextEditingController();

  String _path = "";
  final String _schema = schema;
  final String _doc = demo;
  late SearchEngine _engine;

  @override
  void initState() {
    super.initState();
    _initSearchEngine();
    resultController.addListener(_search);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _initSearchEngine() async {
    _engine = SearchEngine();
    SearchEngine.setup();

    final directory = await getApplicationDocumentsDirectory();
    _path = directory.path;

    final res = _engine.openOrCreate(_path, _schema);
    debugPrint("openOrCreate result $res");

    var exists = await _engine.exists();
    debugPrint('engine exists: $exists');

    await Future.delayed(Duration(seconds: 3));
    var demo = jsonDecode(_doc);
    for (var v in demo) {
      final result = await _engine.getByI64('message_id', v['message_id']);
      debugPrint('search for ${v['message_id']} $result \n\n');
      if (result == null) {
        var s = jsonEncode(v);
        _engine.index(s);
      }
    }
  }

  void _search() async {
    final keyword = resultController.text;
    final keys = keyword.split(' ');
    var key = '';
    for (var v in keys) {
      if (v == '') {
        continue;
      }
      key = '$key content:$v';
    }
    debugPrint('keyword updating: $key');
    final res = await _engine.search(key, ["content"], 1, 10);
    debugPrint('edwin 71 $res');
    if (null != res) {
      setState(() {
        _result = (json.decode(res) as List).map((e) => Result.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Full Text Search'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: resultController,
                // onChanged: (v) => resultController.text = v,
                decoration: InputDecoration(
                  labelText: 'Name the Pup',
                ),
              ),
              Flexible(child: SearchList(_result),)
            ],
          ),
        ),
      ),
    );
  }
}
