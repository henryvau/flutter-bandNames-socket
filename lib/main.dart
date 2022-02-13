import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
import 'pages/status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService() )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: 'home',
        debugShowCheckedModeBanner: false,
        routes: {
          'home':(_) => HomePage(),
          'status':(_) => StatusPage(),

        }
      ),
    );
  }
}
