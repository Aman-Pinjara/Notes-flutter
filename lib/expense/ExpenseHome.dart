// ignore_for_file: prefer_const_constructors

import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:noteapp/common/MyDrawer.dart';
import 'package:noteapp/note/NoteHome.dart';

class ExpenseHome extends StatefulWidget {
  const ExpenseHome({Key? key}) : super(key: key);

  @override
  State<ExpenseHome> createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      backgroundColor: Colors.white,
      body: RawScrollbar(
        thumbVisibility: true,
        thickness: 5,
        thumbColor: Colors.red,
        interactive: false,
        child: Stack(
          children: [
            Positioned(
              top: 650,
              left: -150,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: -170,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 280,
              left: -40,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              // ignore: prefer_const_literals_to_create_immutables
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  leading: Builder(builder: (context) {
                    return IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  }),
                  backgroundColor: Colors.white,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned(
                          top: -60,
                          right: -30,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 70,
                          top: 90,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.cyanAccent.withOpacity(0.8),
                            ),
                          ),
                        ),
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 7,
                              sigmaY: 7,
                            ),
                            child: Container(),
                          ),
                        )
                      ],
                    ),
                    titlePadding: const EdgeInsets.only(bottom: 20),
                    centerTitle: true,
                    title: Text(
                      "Expense",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  expandedHeight: 180,
                  centerTitle: true,
                ),
                // gridNote()
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            elevation: 1,
            backgroundColor: Colors.greenAccent,
            child: Icon(Icons.add),
          ),
          SizedBox(
            height: 30,
          ),
          FloatingActionButton(
            onPressed: () {},
            elevation: 1,
            backgroundColor: Colors.redAccent,
            child: Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
