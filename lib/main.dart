import 'package:flutter/material.dart';
import 'package:torg/providers/name.dart' as prov;
import 'package:provider/provider.dart';
import 'Screens/name_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taorg',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home:  Scaffold(
        
        body: ChangeNotifierProvider(
          create: (context) => prov.Name(),
          child: const NameScreen(),
        ),
      ),
       
    );
  }
}
