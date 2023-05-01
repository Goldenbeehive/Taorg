 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import 'package:torg/providers/project.dart';
class ProjForm extends StatefulWidget {
  const ProjForm({Key? key, required this.update}) : super(key: key);
  final Function() update;
  @override
  State<ProjForm> createState() => _ProjFormState();
}

class _ProjFormState extends State<ProjForm> {
  final TextEditingController controller = TextEditingController();
  String? errorText;

  bool validateInput(String value) {
    if (value.isEmpty) {
      setState(() {
        errorText = 'Input cannot be empty';
      });
      return false;
    } else {
      setState(() {
        errorText = null;
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            controller: controller,
            onChanged: validateInput,
            decoration: InputDecoration(
              errorText: errorText,
              labelText: 'Project Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: ElevatedButton(
                    onPressed: () async{
                      final nav = Navigator.of(context);
                      if (validateInput(controller.text)) {
                        await context.read<Projects>().addProj(controller.text);
                        widget.update();
                        nav.pop();
                      }
                      widget.update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Ok")),
              ),
            ),
          ],
        )
      ],
    );
  }
}

