import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Screens/main_screen.dart';
import 'package:torg/providers/name.dart';
import 'package:torg/providers/project.dart';
import 'package:torg/providers/task.dart';

class NameScreen extends StatelessWidget {
  const NameScreen({super.key});
  static TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<Name>().getName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data == null) {
          return greetingScreen(context);
        } else {
          String? nameNullable = snapshot.data!.name;
          String name = nameNullable.toString();
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (context) => Projects()),
                    ChangeNotifierProvider(create: (context) => TaskProv()),
                    ChangeNotifierProvider(create: (context) => Name()),
                  ],
                  child: MainScreen(name: name),
                );
              },
            ));
          });
          return Container();
        }
      },
    );
  }

  Widget greetingScreen(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Taorg!",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    border: UnderlineInputBorder()),
              ),
            ),
            ElevatedButton(
                onPressed: () async{
                  if(nameController.text.isEmpty){  
                    return;
                  }
                  final nav = Navigator.of(context);
                  await context.read<Name>().addName(nameController.text);
                  nav.pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  create: (context) => Projects(),
                                ),
                                ChangeNotifierProvider(
                                  create: (context) => TaskProv(),
                                ),
                                ChangeNotifierProvider(
                                    create: (context) => Name()),
                              ],
                              child: MainScreen(
                                name: nameController.text,
                              ),
                            )),
                    ModalRoute.withName('/'),
                  );
                },
                child: const Text("Next"))
          ],
        ),
      ),
    );
  }
}
