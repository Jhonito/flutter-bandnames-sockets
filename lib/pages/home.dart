import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';



class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Band> bands =[
    Band(id: '1', name:'Metallica',votes:5),
    Band(id: '2', name:'Queen',votes:5),
    Band(id: '3', name:'Clarita',votes:5),
    Band(id: '4', name:'Muse',votes:5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Bands Names',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ((context, index) {

          return _bandTile(bands[index]);
          
          }),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: Icon(Icons.add_to_drive),
        ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      //Se elimino Key(band.id)
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,

      onDismissed: (DismissDirection direction) {
        //Llamar borrado en el server
        print('direction: $direction');
        print('id: ${band.id}');
      },
      background: Container(
        padding: EdgeInsets.only(left:10),
      color:Colors.blue,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Delete Band')
        ),),
     
      child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[300],
              child: Text(band.name.substring(0,2)),
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
            onTap: () {
              print(band.name);
            },
          ),
    );
  }


addNewBand(){
final textcontroller = TextEditingController();
if(!Platform.isAndroid){
// showDialog(
//   context: context, 
//   builder: (builder){
//     return AlertDialog(
//       title: Text('New Band name:'),
//       content: TextField(
//         controller: textcontroller,
//       ),
//       actions: [
//         MaterialButton(
//           child: Text('add'),
//           elevation: 5,
//           textColor: Colors.blue,
//           onPressed: (){
//            addBandToList(textcontroller.text);
//         })
//       ],
//     );
//   }
//   );

showCupertinoDialog(
  context: context, 
  builder: (_){
    return CupertinoAlertDialog(
      title: Text('New Band Name:'),
      content: CupertinoTextField(
        controller: textcontroller,
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('add'),
          isDefaultAction: true,
          onPressed: () => addBandToList(textcontroller.text),
        ),
        CupertinoDialogAction(
          child: Text('Dismiss'),
          isDefaultAction: true,
          onPressed: () {
            
            Navigator.pop(context);
          },
        ),

      ],

    );

  }
  
);

}




}


void addBandToList (String name) {
  print(name);
  if (name.length > 1) {

    this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 1));
    setState(() {
      
    });
  }
  Navigator.pop(context);
}

}



