// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:noteapp/database/UserDb.dart';
import 'package:provider/provider.dart';

import '../../models/UserModel.dart';
import '../../providers/UserListProvider.dart';

class UserAddPage extends StatefulWidget {
  const UserAddPage({Key? key}) : super(key: key);

  @override
  State<UserAddPage> createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: descriptionController,
            maxLines: 12,
            minLines: 7,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await UserDbHelper.instance.insertUser(
                UserModel(
                  name: nameController.text,
                  totalBalance: 0,
                  description: descriptionController.text,
                ),
              );
              Provider.of<UserListProvider>(context, listen: false)
                  .updateUserList();
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
