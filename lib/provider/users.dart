import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rupa_creation/modal/user.dart';
import 'package:rupa_creation/utility/app_urls.dart';

class Users with ChangeNotifier{
  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }
  final String authToken;

  Users({required this.authToken, List<User>? users}) : _users = users ?? [];

  Future<void> fetchAndSetUsers()async {
    final url = '${AppUrl.baseUrl}/users.json?auth=$authToken';
    try{
      final response = await http.get(Uri.parse(url));
      if (response.body == 'null') {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<User> loadedUsers = [];
      extractedData.forEach((userId, userData) {
        User ud = User.fromJson(userData, userId);
        if(!ud.email!.contains('rupaCreation69')) {
          loadedUsers.add(ud);
        }
      });
      _users = loadedUsers;
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  // Future addUser(String username) async {
  //   const url = '${AppUrl.users}.json';
  //   try{
  //     final response = await http.post(Uri.parse(url), body: json.encode({
  //       "username": username
  //     }));
  //     Jobs newUser = Jobs(userId: json.decode(response.body)['name']);
  //     _users.add(newUser);
  //     notifyListeners();
  //   }catch(e){
  //     rethrow;
  //   }
  // }
  // Future<List<Jobs>> getUsers() async {
  //   const url = '${AppUrl.users}.json';
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if(response.body == 'null'){
  //       return [];
  //     }
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Jobs> loadedUser = [];
  //     extractedData.forEach((key, value) {
  //
  //     });
  //     return [];
  //   }catch(e){
  //     rethrow;
  //   }
  // }
}