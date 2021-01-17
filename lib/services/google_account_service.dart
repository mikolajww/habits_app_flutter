import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobx/mobx.dart';

part 'google_account_service.g.dart';

class GoogleAccountService = _GoogleAccountService with _$GoogleAccountService;

abstract class _GoogleAccountService with Store {

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
}