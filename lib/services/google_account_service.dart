import 'dart:convert';

import 'package:Habitect/data/to_do_item.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'google_account_service.g.dart';

class GoogleAccountService = _GoogleAccountService with _$GoogleAccountService;

abstract class _GoogleAccountService with Store {
  static const apiKey = 'AIzaSyBXqGsq3-YwSbt9o5PorxMJv4kIkGOcqYw';
  static const habitectFolderName = '.habitect_data';
  static String habitectFolderId = null;
  static String habitectFileName = 'habitect.json';
  static String habitectFileId = null;

  static const gapisAuthority = 'www.googleapis.com';
  static const gapisGDrivePath = '/drive/v3/files';
  static const gapisGDriveUploadPath = 'upload/drive/v3/files';
  static const boundary = 'ABCDEFG';
  static const delim = '\r\n--$boundary\r\n';
  static const closeDelim = '\r\n--$boundary--';
  //static const filesEndpoint = 'https://www.googleapis.com/drive/v3/files';

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/calendar',
  ], clientId: '167090502483-5pvf7u6kpd6gh0m7km74tmjr2lk5frj2.apps.googleusercontent.com');

  @observable
  GoogleSignInAccount currentAccount;

  @action
  login() async {
    currentAccount = await googleSignIn.signIn();
    var folderId = await isFolderPresent(habitectFolderName);
    if (folderId == null) {
      print("No folder with name $habitectFolderName found");
      print("Creating folder");
      habitectFolderId = await createFolder(habitectFolderName);
      habitectFileId = await initFile(habitectFileName);
    } else {
      habitectFolderId = folderId;
      habitectFileId = await getHabitectFileId();
      print("Found folder with name $habitectFolderName and id $habitectFolderId");
      print("Found existing file with name $habitectFileName and id $habitectFileId");
    }
  }

  @action
  logout() async {
    currentAccount = await googleSignIn.disconnect();
  }

  Future<String> getToken() async {
    var auth = await googleSignIn.currentUser.authentication;
    return auth.accessToken;
  }

  Future<String> getHabitectFileId() async {
    const Map<String, String> queryParams = {'key': apiKey};
    var token = await getToken();
    var uri = Uri.https(gapisAuthority, gapisGDrivePath, queryParams);
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      for (var file in responseBody['files']) {
        if (file['name'] == habitectFileName) {
          return file['id'];
        }
      }
      return null;
    } else {
      throw Exception('$uri returned ${response.statusCode}');
    }
  }

  String createMultipartBody(String name, List<ToDoItem> todos, bool updateParents) {
    var metadata;
    if (updateParents) {
      metadata = jsonEncode({
        'name': name,
        'mimeType': 'application/json',
        'parents': ['$habitectFolderId']
      });
    } else {
      metadata = jsonEncode({'name': name, 'mimeType': 'application/json'});
    }

    var multipartBody = delim +
        'Content-Type: application/json;charset=UTF-8\r\n\r\n' +
        metadata +
        delim +
        'Content-Type: application/json\r\n\r\n' +
        jsonEncode(todos) +
        '\r\n' +
        closeDelim;
    return multipartBody;
  }

  Future<String> updateFile(List<ToDoItem> todos) async {
    const Map<String, String> queryParams = {'key': apiKey, 'uploadType': 'multipart'};
    var token = await getToken();
    var uri = Uri.https(gapisAuthority, gapisGDriveUploadPath + "/$habitectFileId", queryParams);
    var multipartBody = createMultipartBody(habitectFileName, todos, false);
    print(multipartBody);
    final http.Response response = await http.patch(
      uri,
      body: multipartBody,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'multipart/related; boundary=$boundary',
        'Content-Length': multipartBody.length.toString()
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody['id'];
    } else {
      throw Exception('$uri returned ${response.statusCode}');
    }
  }

  Future<String> initFile(String name) async {
    const Map<String, String> queryParams = {'key': apiKey, 'uploadType': 'multipart'};
    var token = await getToken();
    var uri = Uri.https(gapisAuthority, gapisGDriveUploadPath, queryParams);
    var multipartBody = createMultipartBody(name, [], true);
    final http.Response response = await http.post(
      uri,
      body: multipartBody,
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'multipart/related; boundary=$boundary',
        'Content-Length': multipartBody.length.toString()
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody['id'];
    } else {
      throw Exception('$uri returned ${response.statusCode}');
    }
  }

  Future<String> createFolder(String folderName) async {
    const Map<String, String> queryParams = {'key': apiKey};
    var token = await getToken();
    var uri = Uri.https(gapisAuthority, gapisGDrivePath, queryParams);
    final http.Response response = await http.post(
      uri,
      body: jsonEncode(<String, String>{'name': folderName, 'mimeType': 'application/vnd.google-apps.folder'}),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return responseBody['id'];
    } else {
      throw Exception('$uri returned ${response.statusCode}');
    }
  }

  Future<String> isFolderPresent(String folderName) async {
    Map<String, String> queryParams = {
      'key': apiKey,
      'q': "trashed = false and name contains '$folderName' and 'root' in parents"
    };
    var token = await getToken();
    var uri = Uri.https(gapisAuthority, gapisGDrivePath, queryParams);
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      for (var file in responseBody['files']) {
        print(file);
        if (file['name'].toString() == folderName) {
          return file['id'];
        }
      }
      return null;
    } else {
      throw Exception('$uri returned ${response.statusCode}');
    }
  }
}
