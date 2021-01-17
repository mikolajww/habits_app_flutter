// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_account_service.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GoogleAccountService on _GoogleAccountService, Store {
  final _$currentAccountAtom =
      Atom(name: '_GoogleAccountService.currentAccount');

  @override
  GoogleSignInAccount get currentAccount {
    _$currentAccountAtom.reportRead();
    return super.currentAccount;
  }

  @override
  set currentAccount(GoogleSignInAccount value) {
    _$currentAccountAtom.reportWrite(value, super.currentAccount, () {
      super.currentAccount = value;
    });
  }

  final _$loginAsyncAction = AsyncAction('_GoogleAccountService.login');

  @override
  Future login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  final _$logoutAsyncAction = AsyncAction('_GoogleAccountService.logout');

  @override
  Future logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
currentAccount: ${currentAccount}
    ''';
  }
}
