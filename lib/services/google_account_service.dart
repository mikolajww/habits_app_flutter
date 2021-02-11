import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'google_account_service.g.dart';

class GoogleAccountService = _GoogleAccountService with _$GoogleAccountService;

abstract class _GoogleAccountService with Store {
  static const apiKey = 'AIzaSyBXqGsq3-YwSbt9o5PorxMJv4kIkGOcqYw';
  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/drive',
        'https://www.googleapis.com/auth/calendar',
      ],
      clientId: '167090502483-5pvf7u6kpd6gh0m7km74tmjr2lk5frj2.apps.googleusercontent.com'
  );

  @observable
  GoogleSignInAccount currentAccount;

  @action
  login() async {
    currentAccount = await googleSignIn.signIn();
  }

  @action
  logout() async {
    currentAccount = await googleSignIn.disconnect();
  }

  Future<List<String>> getUserFileList() async {
    const endpoint = 'https://www.googleapis.com/drive/v3/files?key=$apiKey';
    var auth = await googleSignIn.currentUser.authentication;
    var token = auth.accessToken;
    final http.Response response = await http.get(
      endpoint,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      },
    );
    var result = <String>[];
    if(response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      for (var file in responseBody['files']) {
        result.add(file['name']);
      }
      return result;
    }
    else {
      throw Exception('$endpoint returned ${response.statusCode}');
    }
  }
}