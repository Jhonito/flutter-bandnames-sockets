import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit('emitir-mensaje');
    return Scaffold(
      body: Center(
        child: Text('ServerStatus:${ socketService.serverStatus}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send_and_archive),
        elevation: 1,
        onPressed: (){
          socketService.emit(
            'emitir-mensaje',{
              'nombre': 'Flutter',
              'mensaje': 'hola desde flutter'
            }
          );


        }
      ),
    );
  }
}