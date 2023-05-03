import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/components/name_form.dart';
import 'package:torg/providers/name.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.settings),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SizedBox(
                        height: 350,
                        child: Column(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Divider(
                                thickness: 2.0,
                                color: Colors.black,
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 13.0),
                                child: Text(
                                  'New Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                            ChangeNotifierProvider(
                              create: (context) => Name(),
                              child: const NameForm(),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black),
                  bottom: BorderSide(width: 1.0, color: Colors.black),
                ),
              ),
              child: Text(
                "Change Name",
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
