import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/custom/TodoCard.dart';
import 'package:to_do_app/pages/add_Todo_Page.dart';
import 'package:to_do_app/pages/view_data.dart';

class Home extends StatefulWidget {
 const  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Home(),
    AddTodoPage(),
    AddTodoPage(),
  ];

  final Stream<QuerySnapshot> _stream= FirebaseFirestore.instance.collection("Todo").snapshots();

  var iconData;

  var iconColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text("Today Schedule's",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        actions:  const [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile.jpg"),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.only(left: 22.0),
              child: Text("Monday 21",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 34,
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
       // type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.black87,
        items:  [
        const  BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTodoPage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration:const  BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [
                        Colors.indigoAccent,
                        Colors.purple,
                      ],
                  ),
                ),
                child:const Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Add'
          ),
        const  BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 32,
              color: Colors.white,
            ),
            label: 'Setting',
          ),
        ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context , snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context , index){
                //  final DocumentSnapshot documentSnapshot= snapshot.data!.docs[index];
                  Map<String,dynamic> document =
                     snapshot.data!.docs[index].data() as Map<String , dynamic> ;

                     switch(document["category"]){
                       case "Work" :
                          iconData = Icons.run_circle_outlined;
                          iconColor =Colors.red;
                         break;
                       case "Workout" :
                         iconData = Icons.alarm;
                         iconColor =Colors.red;
                         break;
                       case "Food" :
                         iconData = Icons.local_grocery_store;
                         iconColor =Colors.red;
                         break;
                       case "Run" :
                         iconData = Icons.run_circle_outlined;
                         iconColor =Colors.red;
                         break;
                       case "Design" :
                         iconData = Icons.design_services;
                         iconColor =Colors.red;
                         break;
                       default :
                         iconData = Icons.design_services;
                         iconColor =Colors.red;
                  }
                  return InkWell(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewData(
                            document: document,
                            id: snapshot.data!.docs[index].id,
                          )));
                    },
                    child: TodoCard(
                            title: document["title"],
                            iconData: iconData,
                            iconColor: iconColor,
                            iconBgColor: Colors.white,
                            check: true,
                            time: "10",
                    ),
                  );
                }
            );
          }
          return const Center (
              child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}