import 'package:flutter/material.dart';
import 'package:noteapp/database/UserDb.dart';
import 'package:noteapp/models/UserModel.dart';

class UserListProvider extends ChangeNotifier {
  List<UserModel> userList = [];
  late int curUser;
  bool isLoading = true;
  void updateUserList() async {
    isLoading = true;
    userList = await UserDbHelper.instance.getAllUsers();
    curUser = userList[0].id!;
    isLoading = false;
    notifyListeners();
  }

  void updateAmount(double amount) async {
    int idx = userList.indexWhere((element) => element.id == curUser);
    userList.insert(idx, userList[idx].copy(totalBalance: amount));
    userList.removeAt(idx + 1);
    updateUserList();
  }

  UserModel getUser(int id) {
    return userList.firstWhere((element) => element.id == id);
  }

  void updateCurUser(int id) {
    curUser = userList[id].id!;
    notifyListeners();
  }
}
