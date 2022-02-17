import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus{

  Online,
  Offline,
  Conneting
}

class SocketService with ChangeNotifier {


  ServerStatus _serverStatus = ServerStatus.Conneting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;



  SocketService(){
    this._initConfig();



  }

  void _initConfig(){
    String urlSocket = 'http://192.168.0.4:3000';
  //  IO.Socket socket = IO.io('http://192.168.0.5:3000',{
  //    'transports': ['websocket'],
  //    'autoConnect': true,
  //  });
    //?!*TODOConectar Socket
      this._socket= IO.io(
            urlSocket,
            IO.OptionBuilder()
                .setTransports(['websocket']) // for Flutter or Dart VM
                .enableAutoConnect()
                .setExtraHeaders({'foo': 'bar'}) // optional
                .build());
      
      this._socket.onConnect( (_) {
        print('connect');
        this._serverStatus = ServerStatus.Online;
        notifyListeners();
      });

      this._socket.onDisconnect((_) {
        print('disconnect');
        this._serverStatus = ServerStatus.Offline;
        notifyListeners();
      });

      //  socket.on('nuevo-mensaje', (payload) {
      //    print('nuevo-mensaje,$payload');
      //    print('nombre:'+ payload['nombre']);
      //    print('mensaje:'+ payload['mensaje']);
      //    print('cracatoa:'+ payload['cracatoa']);
      //    print(payload.containsKey('mensaje4') ? payload['mensaje4'] : 'no hay');
      //    notifyListeners();

      // });
    
    

      
  }

}