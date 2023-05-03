import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torg/Screens/project_screen.dart';
import 'package:torg/components/task_list.dart';
import 'package:torg/providers/name.dart';
import 'package:torg/providers/project.dart';
import 'package:torg/Models/project.dart';
import 'package:torg/components/project_form.dart';
import 'package:torg/providers/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.name});
  final String name;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController projController = TextEditingController();

  void bottomsheetUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        title(),
        projects(context),
        todaysTasks(),
      ],
    );
  }

// Today's Tasks widgets section --------------------------------------------
  Widget todaysTasks() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 23,
                color: Colors.grey.withOpacity(0.8),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const TaskList(),
        ],
      ),
    );
  }

// Projects widgets section --------------------------------------------
  Widget projects(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Projects",
              style: TextStyle(
                fontSize: 23,
                color: Colors.grey.withOpacity(0.8),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          FutureBuilder<List<Project>>(
            future: context.read<Projects>().getName(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator());
              }
              List<Project> list = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 150,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length + 1,
                    itemBuilder: (context, index) {
                      if (index == list.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 1.0, top: 1.0),
                          child: addProj(),
                        );
                      }
                      return SizedBox(
                        width: 150,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (context) => Projects(),
                                      ),
                                      ChangeNotifierProvider(
                                        create: (context) => TaskProv(),
                                      ),
                                    ],
                                    child: ProjectScreen(
                                        project: list[index],
                                        update: bottomsheetUpdate),
                                  ),
                                ));
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Card(
                              elevation: 2.0,
                              color: generateSoftColor(list[index].name!),
                              child: Stack(children: [
                                FutureBuilder(
                                  future: context
                                      .read<Projects>()
                                      .amountUpcoming(list[index].name!),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Positioned(
                                          left: 5.0,
                                          bottom: 0,
                                          child: SizedBox(
                                              height: 30,
                                              width: 100,
                                              child: Card(
                                                  elevation: 3.0,
                                                  color: generateSoftColor(
                                                      list[index].name!),
                                                  child: Center(
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: const Text(
                                                              " 0 Upcoming  ",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)))))));
                                    }
                                    return Positioned(
                                      left: 5.0,
                                      bottom: 0,
                                      child: SizedBox(
                                        height: 30,
                                        child: Card(
                                          elevation: 3.0,
                                          color: generateSoftColor(
                                              list[index].name!),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Text(
                                                "${snapshot.data} Upcoming",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, bottom: 30),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(16.0),
                                                bottomLeft:
                                                    Radius.circular(16.0),
                                              ),
                                              color: generateDarkerColor(
                                                  list[index].name!),
                                            ),
                                            width: 10.0,
                                            height: 40.0,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              list[index].name!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ])),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget addProj() {
    return InkWell(
        borderRadius: BorderRadius.circular(10),
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
                      height: 200,
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
                                'Project Data',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                          ChangeNotifierProvider(
                              create: (context) => Projects(),
                              child: ProjForm(
                                update: bottomsheetUpdate,
                              ))
                        ],
                      )),
                );
              });
        },
        child: DottedBorder(
          dashPattern: const [5, 5],
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          child: Container(
            height: 150,
            width: 150,
            color: Colors.transparent,
            child: Center(
              child: DottedBorder(
                dashPattern: const [5, 5],
                borderType: BorderType.Circle,
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ),
        ));
  }

// Title widgets section --------------------------------------------
  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder(
            future: context.read<Name>().getName(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              String name = snapshot.data!.name!;
              return Flexible(
                  child: Row(children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.name == "" ? "Welcome!" : "Welcome, $name",
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ]));
            }),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Icon(Icons.task_alt),
        ),
      ],
    );
  }
}

// Helper functions
Color generateSoftColor(String str) {
  const saturation = 0.5;
  const lightness = 0.9;
  final hue = ((str.hashCode % 360) + 360) % 360;
  return HSLColor.fromAHSL(1.0, hue.toDouble(), saturation, lightness)
      .toColor();
}

Color generateDarkerColor(String str) {
  final softColor = generateSoftColor(str);
  final hslColor = HSLColor.fromColor(softColor);
  final darkColor =
      hslColor.withLightness((hslColor.lightness * 0.7).clamp(0.0, 1.0));
  return darkColor.toColor();
}
