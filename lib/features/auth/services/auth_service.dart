import 'dart:convert';
import 'package:amazon_clone/constants/commons/bottom_bar.dart';
//import 'package:amazon_clone/features/home/screen/home_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      User user = User(
        id: '',
        email: email,
        name: name,
        password: password,
        address: '',
        type: '',
        token: '',
        cart: [],
      );
      http.Response response = await http.post(Uri.parse("${uri}/api/signup"),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, "Account Created! Login with the same credentials!");
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(Uri.parse("${uri}/api/signin"),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false)
                .setUser(response.body);
            await prefs.setString(
                'x-auth-token', jsonDecode(response.body)['token']);
            Navigator.pushNamedAndRemoveUntil(
              context,
              //HomeScreen.routeName,
              BottomBar.routeName,
              (route) => false,
            );
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUserData({
    required BuildContext context,
  }) async {
    try {
      //   http.Response response = await http.post(Uri.parse("${uri}/api/signin"),
      //       body: jsonEncode({'email': email, 'password': password}),
      //       headers: <String, String>{
      //         'Content-Type': 'application/json; charset=UTF-8',
      //       });
      //   // ignore: use_build_context_synchronously
      //   httpErrorHandle(
      //       response: response,
      //       context: context,
      //       onSuccess: () async {
      //         final SharedPreferences prefs =
      //             await SharedPreferences.getInstance();
      //         Provider.of<UserProvider>(context, listen: false)
      //             .setUser(response.body);
      //         await prefs.setString(
      //             'x-auth-token', jsonDecode(response.body)['token']);
      //         Navigator.pushNamedAndRemoveUntil(
      //           context,
      //           HomeScreen.routeName,
      //           (route) => false,
      //         );
      //       });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      if (token == null) prefs.setString('x-auth-token', '');
      http.Response tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });
      var response = jsonDecode(tokenRes.body);
      if (response) {
        http.Response userRes = await http.get(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
