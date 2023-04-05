import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_sockets/services/band_socket.dart';
import 'package:app_sockets/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BandSocketService())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BandNames Pool',
          initialRoute: 'home',
          routes: {
            'home': (_) => const HomeScreen(),
            'status': (_) => const StatusScreen()
          },
          theme: ThemeData.light().copyWith(
              appBarTheme: const AppBarTheme(
                  elevation: 1, backgroundColor: Colors.indigo))),
    );
  }
}
