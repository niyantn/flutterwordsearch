import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:flutter/src/material/colors.dart';

const int GRID_COUNT = 10;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        //scaffoldBackgroundColor: Colors.blue,
        accentColor: Colors.amber,
      ),
      home: MyHomePage(title: 'Word Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _saved = <String>[];
  final List<String> _savedwords = <String>[];
  final List<String> _letters = <String>[];
  final List<bool> _userletters = <bool>[];
  final List<String> _words = <String>[];
  final List<double> _drag_x = <double>[];
  final List<double> _drag_y = <double>[];
  //final List<int> _positions = <int>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 24);
  final TextStyle _bigFont = const TextStyle(fontSize: 18);
  
  int _wordcount = 0;
  String checker;
  int _startin = 0;
  int _endin = 0;

  void _initialize(){
    //_wordcount = 0;
    _words.add("SWIFT");
    _words.add("KOTLIN");
    _words.add("OBJECTIVEC");
    _words.add("VARIABLE");
    _words.add("JAVA");
    _words.add("MOBILE");
    for(var i = 0; i < GRID_COUNT * GRID_COUNT; i++){
      _letters.add("Z");
      _userletters.add(false);
    }
    /*
    while(_positions.length < _words.length){
      int p = _words.length - 1;
      int q = randomBetween(0,p);
      int r = 10 * q;
      if(_positions.contains(r)){
        continue;
      }
      else{
        _positions.add(r);
      }
    }
    for(var n = 0; n < _positions.length; n++){
      print(_positions[n]);
    }
    for(var j = 0; j < _words.length; j++){
      int start = _positions[j];
      for(var k = 0; k < _words[j].length; k++){
        _letters[start+k] = _words[j][k];
      }
    }*/
    _letters[0] = "S";
    _letters[1] = "W";
    _letters[2] = "I";
    _letters[3] = "F";
    _letters[4] = "T";
    _letters[10] = "K";
    _letters[11] = "O";
    _letters[12] = "T";
    _letters[13] = "L";
    _letters[14] = "I";
    _letters[15] = "N";
    _letters[20] = "O";
    _letters[21] = "B";
    _letters[22] = "J";
    _letters[23] = "E";
    _letters[24] = "C";
    _letters[25] = "T";
    _letters[26] = "I";
    _letters[27] = "V";
    _letters[28] = "E";
    _letters[29] = "C";
    _letters[30] = "V";
    _letters[31] = "A";
    _letters[32] = "R";
    _letters[33] = "I";
    _letters[34] = "A";
    _letters[35] = "B";
    _letters[36] = "L";
    _letters[37] = "E";
    _letters[40] = "J";
    _letters[41] = "A";
    _letters[42] = "V";
    _letters[43] = "A";
    _letters[50] = "M";
    _letters[51] = "O";
    _letters[52] = "B";
    _letters[53] = "I";
    _letters[54] = "L";
    _letters[55] = "E";
    for(var i = 0; i < GRID_COUNT * GRID_COUNT; i++){
      if(_letters[i] == "Z"){
        _letters[i] = randomAlpha(1);
      }
    }
  }
  void _incrementCounter() {
    checker = "";
    bool found = false;
    bool done = false;
    bool repeat = false;
    for(var i = 0; i < _saved.length; i++){
      checker = checker + _saved[i];
    }
    /*for(var i = 0; i < _words.length; i++){
      if (checker == _words[i]){
        found = true;
      }
    }*/
    if(_words.contains(checker)){
      found = true;
    }
    if (found){
      if (_savedwords.contains(checker)){
        repeat = true;
      }
      else{
        _savedwords.add(checker);
        _wordcount++;
      }
    }
    if (_wordcount == 6){
      done = true;
    }
    _showDialog(checker, found, done, repeat);
    _saved.clear();
  }
  void _showDialog(String l, bool n, bool m, bool o) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("You submitted $checker!"),
          //insetAnimationCurve: null,
          //insetAnimationDuration: null,
          content: n ? o ?
            new Text("You already found that word! Click the upper right arrow to see your words.") :
            m ?
            new Text("You found all the words. Hooray!!") :
            new Text("Good job! You've found $_wordcount words") :
            new Text("That wasn't a word we're looking for!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _clearSaved(){
    setState(() { 
      _savedwords.clear();
      _wordcount = 0;
    });
    Navigator.of(context).pop();
  }
  Widget _letterGrid(var ui){
    //_initialize();
    //print(s.width);
    //print(s.height);
    return Container(
      //margin: const EdgeInsets.only(bottom: 8.0),
      alignment: Alignment.center,
      child: GestureDetector(
        onPanDown: (details) {
          //print(details.localPosition.dx);
          //print(details.localPosition.dy);
        },
        onPanUpdate: (details) {
          //print(details.localPosition.dx);
          //print(details.localPosition.dy);
          _colorLetter(details.localPosition.dx, details.localPosition.dy, ui);
          _drag_x.add(details.localPosition.dx);
          _drag_y.add(details.localPosition.dy);
        },
        onPanEnd: (details) {
          _findWord(ui);
          _incrementCounter();
          _clearDrag();
        },
        child: GridView.count(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: GRID_COUNT,
          children: List.generate(GRID_COUNT*GRID_COUNT, (index) {
            return Container(
              decoration: new BoxDecoration(
                //borderRadius: BorderRadius.circular(20.0),
                color: _userletters[index] ? Colors.yellow.shade200 : null,
              ),
              alignment: Alignment.center,
              child: ListTile(
                title: Text(_letters[index], style: _bigFont),
                //onTap: () => _chooseTile(_letters[index]),
              ),
            );
          }),
        ),
      ),
    );
  }
  void _findWord(var t){
    double startx = _drag_x.first;
    double endx = _drag_x.last;
    double starty = _drag_y.first;
    double endy = _drag_y.last;
    int begx = 0;
    int finx = 0;
    int begy = 0;
    int finy = 0;
    begx = startx ~/ (t.size.width / GRID_COUNT);
    finx = endx ~/ (t.size.width / GRID_COUNT);
    begy = starty ~/ (t.size.width / GRID_COUNT);
    finy = endy ~/ (t.size.width / GRID_COUNT);
    if(begy == finy){
      for(var i = begx; i <= finx; i++){
        int a = i+(10*begy);
        if(_userletters[a]){
          _saved.add(_letters[a]);
        }
      }
    }
    if(begx == finx){
      for(var i = begy; i <= finy; i++){
        int b = begx+(10*i);
        if(_userletters[b]){
          _saved.add(_letters[b]);
        }
      }
    }
    _drag_x.clear();
    _drag_y.clear();
  }
  void _clearDrag(){
    for(var i = 0; i < _userletters.length; i++){
      if (_userletters[i]){
        setState((){
          _userletters[i] = false;
        });
      }
    }
  }
  void _colorLetter(double x, double y, var t){
    int myx = x ~/ (t.size.width / GRID_COUNT);
    int myy = y ~/ (t.size.width / GRID_COUNT);
    int pos = myx + (10*myy);
    setState((){
      _userletters[pos] = true;
    });
  }
  Widget _wordBox(){
    return Column(
      children: <Widget>[
        Center(
          child: Text("Word Box", style: _biggerFont),
        ),
        Text("1. SWIFT", style: _bigFont),
        Text("2. KOTLIN", style: _bigFont),
        Text("3. OBJECTIVEC", style: _bigFont),
        Text("4. VARIABLE", style: _bigFont),
        Text("5. JAVA", style: _bigFont),
        Text("6. MOBILE", style: _bigFont)
      ]
    );
  }
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedwords.map(
                (String text) {
              return ListTile(
                title: Text(text),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Found Words: $_wordcount'),
            ),
            body: ListView(children: divided),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _clearSaved,
              tooltip: 'Clear',
              icon: Icon(Icons.autorenew),
              label: Text("Restart"),
              elevation: 30.0,
              highlightElevation: 0.0,
            ),
          );
        },
      ),
    );
  }
  /*void _chooseTile(String text) {
    _saved.add(text);
  }*/
  @override
  Widget build(BuildContext context) {
    var outputUI = MediaQuery.of(context);
    _initialize();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: _pushSaved),
        ],
      ),
      body: Container(
        child: new Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _letterGrid(outputUI),
            SizedBox(height: outputUI.size.height / 44),
            Divider(
              indent: outputUI.size.width / 12,
              endIndent: outputUI.size.width / 12,
              thickness: 3.0,
              color: Colors.black,
            ),
            SizedBox(height: outputUI.size.height / 44),
            _wordBox(),
          ],
        ),
        /*decoration: new BoxDecoration(
          color: Colors.grey,
          //borderRadius: BorderRadius.circular(20.0),
          gradient: new LinearGradient(
            colors: [Colors.grey, Colors.white, Colors.grey],
            tileMode: TileMode.mirror,
          ),
        ),*/
      ),
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: _incrementCounter,
        tooltip: 'Send',
        icon: Icon(Icons.send),
        label: Text("Send Word"),
        elevation: 30.0,
        highlightElevation: 0.0,
      ),*/
    );
  }
}
