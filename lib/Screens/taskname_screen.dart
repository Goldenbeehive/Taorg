import 'package:flutter/material.dart';

class TaskNameScreen extends StatelessWidget {
  const TaskNameScreen({super.key,required this.text});
final String text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
                Center(child: Text(text,textAlign: TextAlign.center,style: const TextStyle(fontSize: 30,),),)
          ],
        ),
      ),
    );
  }
}
