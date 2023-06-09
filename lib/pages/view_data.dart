import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewData extends StatefulWidget {
    ViewData({Key? key ,required  this.document, required this.id}) : super(key: key);

    final Map<String, dynamic>  document;
    final String id;

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {

  late TextEditingController _titleController ;
  late TextEditingController _descriptionController;
  late String  taskType ;
  late String  category ;
  bool edit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String title = widget.document["title"] ==null ? "Enter some data" :widget.document["title"] ;
    _titleController = TextEditingController( text: title);

    String description = widget.document["description"] == null ? "Hello Bidur" : widget.document["description"];
    _descriptionController = TextEditingController(text:  description);
    taskType = widget.document["task"] ?? "task";
    category = widget.document["category"] ?? "category";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: SingleChildScrollView(
          padding:const EdgeInsets.only(left: 15) ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const   SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.white,
                        size: 28,
                      ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){
                         FirebaseFirestore.instance
                             .collection("Todo")
                             .doc(widget.id)
                             .delete()
                             .then((value) {
                               Navigator.pop(context);
                         }
                         );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red ,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: edit? Colors.red : Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children:  [
                        Text(
                         edit ? "Editing": "View ",
                          style: const TextStyle(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        ),
                       const SizedBox(
                          width: 5.0,
                        ),
                        const Text(
                          "Your Todo",
                          style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              label("Task Title"),
              const SizedBox(height: 12.0),
              title(),
              const SizedBox(height: 12.0),
              label("Task Type"),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  taskSelect("Important", 0xff2664fa),
                  const SizedBox(width: 20.0),
                  taskSelect("Planned", 0xff2bc8d9),
                ],
              ),
              const SizedBox(height: 12.0),

              label("Description"),
              const SizedBox(height: 20.0),
              description(),

              const SizedBox(height: 12.0),
              label("Category"),
              const SizedBox(height: 12.0),
              Wrap(
                runSpacing: 10,
                children: [
                  categorySelect('Food',0xffff6d6e ),
                  const SizedBox(width: 20.0),
                  categorySelect('Workout', 0xff58c490),
                  const SizedBox(width: 20.0),
                  categorySelect('Work',0xffe69045),
                  categorySelect('Design',0xff234ebd ),
                  const SizedBox(width: 20.0),
                  categorySelect('Run', 0xff82117e),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              edit ? button() : Container(),
            ],
          ),
        ),
      ),
    );
  }
  Widget title (){
    return Container(
      width: MediaQuery.of(context).size.width -35,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        enabled: edit,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Task Title',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(left: 20.0 , right: 20.0)
        ),
      ),
    );
  }
  Widget description (){
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width - 35,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enabled: edit,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Description',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(left: 20.0 , right: 20.0)
        ),
      ),
    );
  }
  Widget taskSelect ( String label , int color){
    return InkWell(
      onTap:edit
          ? (){
                setState(() {
                  taskType = label;
                });
              }
           : null,
      child: Chip(
        backgroundColor: taskType == label ? Colors.white : Color(color),   //  0xffff6dde
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        label : Text(label),
        labelStyle: TextStyle(
          color:  taskType == label ? Colors.black : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ) ,
        labelPadding: const EdgeInsets.symmetric(horizontal: 17.0 , vertical: 3.8),
      ),
    );
  }
  Widget categorySelect ( String label , int color){
    return InkWell(
      onTap: edit
          ? (){
            setState(() {
              category = label;
            });
          }
       : null,
      child: Chip(
        backgroundColor: category == label ? Colors.white : Color(color),   //  0xffff6dde
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        label : Text(label),
        labelStyle: TextStyle(
          color:  category == label ? Colors.black : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ) ,
        labelPadding: const EdgeInsets.symmetric(horizontal: 17.0 , vertical: 3.8),
      ),
    );
  }
  Widget label (String label){
    return Text(
      label ,
      style: const TextStyle(
          color: Colors.white ,
          fontSize: 18 ,
          fontWeight: FontWeight.bold),
    );
  }
  Widget button(){
    return InkWell(
      onTap: (){
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update(
            {
              "title" : _titleController.text,
              "task" : taskType,
              "description" : _descriptionController.text,
              "category" : category
            }
        );
        const text = 'Task has been updated successfully';
        final snackbar = SnackBar(
          content: const Text(text),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: (){},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.pop(context);
      },
      child: Container(
        height: 56.0,
        width: MediaQuery.of(context).size.width -30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: const LinearGradient(
              colors:  [
                Color(0xff8a32f1),
                Color(0xffad32f9),
              ]
          ),
        ),
        child: const Center(
          child: Text(
            "Update Todo" ,
            style: TextStyle(
                color : Colors.white ,
                fontSize: 18.0 ,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
  // Widget button(){
  //   return InkWell(
  //     onTap: (){
  //       FirebaseFirestore.instance.collection("Todo").doc(widget.id).update(
  //           {
  //             "title" : _titleController.text,
  //             "task" : taskType,
  //             "description" : _descriptionController.text,
  //             "category" : category
  //           }
  //       );
  //       const text = 'Task has been updated successfully';
  //       final snackbar = SnackBar(
  //         content: const Text(text),
  //         duration: const Duration(seconds: 3),
  //         backgroundColor: Colors.red,
  //         action: SnackBarAction(
  //           label: 'Dismiss',
  //           onPressed: (){},
  //         ),
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackbar);
  //       Navigator.pop(context);
  //     },
  //     child: Container(
  //       height: 56.0,
  //       width: MediaQuery.of(context).size.width -30,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20.0),
  //         gradient: const LinearGradient(
  //             colors:  [
  //               Color(0xff8a32f1),
  //               Color(0xffad32f9),
  //             ]
  //         ),
  //       ),
  //       child: const Center(
  //         child: Text(
  //           "Update Todo" ,
  //           style: TextStyle(
  //               color : Colors.white ,
  //               fontSize: 18.0 ,
  //               fontWeight: FontWeight.w600),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

