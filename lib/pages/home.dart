import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';



class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context,listen: false);

  socketService.socket.on('active-bands',_handleActiveBands);

    super.initState();
    
  }
  _handleActiveBands(dynamic payload){
      this.bands = (payload as List)
    .map(((band) => Band.fromMap(band)))
    .toList();
    setState(() {
      
    });



  }
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context,listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  

  List<Band> bands =[
    // Band(id: '1', name:'Metallica',votes:5),
    // Band(id: '2', name:'Queen',votes:5),
    // Band(id: '3', name:'Clarita',votes:5),
    // Band(id: '4', name:'Muse',votes:5),
  ];

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
           child: (socketService.serverStatus == ServerStatus.Online)
           ? Icon(Icons.check_circle,color: Colors.blue,)
           : Icon(Icons.offline_bolt,color: Colors.red,)
           ,
          )
        ],
        title:Text('Bands Names',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
           _showGraph(context),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: ((context, index) {
          
                return _bandTile(bands[index]);
                
                }),
            ),
          ),
          _showGraph(context),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: Icon(Icons.add_to_drive),
        ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context,listen: false);
    return Dismissible(
      //Se elimino Key(band.id)
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,

      onDismissed: (_) {
        //Llamar borrado en el server
        socketService.emit('delete-band',{'id':band.id});
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
              socketService.emit('vote-band',{'id':band.id});
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
        autofocus: true,
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
  
   
  
  if (name.length > 1) {
  final socketService = Provider.of<SocketService>(context,listen: false);

    socketService.emit('add-new-band',{'name': name});
    
  }
  Navigator.pop(context);
}




Widget _showGraph(context){

  Map<String, double> dataMap = new Map();
    bands.forEach((band) { 
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
  
  return Container(
    width: double.infinity,
    height: 200,
    child: PieChart(
      dataMap: dataMap,
      chartType: ChartType.ring,
      )
    );
}

}



