import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus{

  Online,
  Offline,
  Conneting
}

class SocketService with ChangeNotifier {


ServerStatus _serverStatus = ServerStatus.Conneting;



SocketService(){



}

void _initConfig(){


 IO.Socket socket = IO.io('http://192.168.0.3:3000',{
   'transports': ['websocket'],
   'autoConnect': true,

 });
  
  socket.onConnect( (_) => print('connect'));
  socket.onDisconnect((_) => print('disconnect'));
 

  socket.connect();
}

}