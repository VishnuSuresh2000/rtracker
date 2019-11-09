import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rtracker/responsive.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeBpdy(),
    );
  }
}

class HomeBpdy extends StatefulWidget {
  const HomeBpdy({Key key}) : super(key: key);

  @override
  _HomeBpdyState createState() => _HomeBpdyState();
}

class _HomeBpdyState extends State<HomeBpdy> {
  String name = "";
  String dep = "";
  Map outPut = {'error': true, 'msg': null};
  bool printOut = false;

  void getPostion() async {
    try {
      var data = await Firestore.instance.collection('stafs').getDocuments();
      for (var i in data.documents) {
        print(i.documentID);
        if (i.documentID.toString() ==
            "${name.toLowerCase()}${dep.toLowerCase()}") {
          print(i.data['postion']);
          outPut['error']=false;
          outPut['msg']=i.data['postion'];
        } else {
          print("no object");
          outPut['error']=false;
          outPut['msg']='No Staf Found';
        }
      }
    } catch (e) {
      print(e);
     
    }
    setState(() {
      printOut=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ftracker"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(Responsive.responsiveHeight(context,10)),
              child: TextField(
                onChanged: (name) {
                  setState(() {
                    this.name = name;
                  });
                },
                decoration: InputDecoration(labelText: 'Faculty Name'),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(Responsive.responsiveHeight(context,10)),
              child: TextField(
                onChanged: (dep) {
                  setState(() {
                    this.dep = dep;
                  });
                },
                decoration: InputDecoration(labelText: 'Deprtment'),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Text("name:$name depatement:$dep"),
          ),
          Flexible(
            flex: 8,
            child: Center(
              child: RaisedButton(
                onPressed: () async {
                  getPostion();
                },
                child: Container(
                  width: Responsive.responsiveWidth(context,150),
                  height: Responsive.responsiveHeight(context,40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Icon(Icons.search),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text("Search Faculty"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (printOut)
            Flexible(
              flex: 5,
              child: outPut['error']
                  ? Text("Contact assistance")
                  : Text("Position Of Faculty is ${outPut['msg']}"),
            )
        ],
      ),
    );
  }
}
