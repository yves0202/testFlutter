import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  String _currentLanguage = '';
  String get currentLanguage => _currentLanguage;
  set currentLanguage(String value) {
    _currentLanguage = value;
  }

  dynamic _translations;
  dynamic get translations => _translations;
  set translations(dynamic value) {
    _translations = value;
  }

  bool _isTranslationLoaded = false;
  bool get isTranslationLoaded => _isTranslationLoaded;
  set isTranslationLoaded(bool value) {
    _isTranslationLoaded = value;
  }

  dynamic _frenchTranslations = jsonDecode(
      '{\"app_name\":\"Mon Application\",\"welcome\":\"Bienvenue\",\"login\":\"Connexion\",\"email\":\"E-mail\",\"password\":\"Mot de passe\",\"submit\":\"Soumettre\",\"cancel\":\"Annuler\",\"settings\":\"Parametres\",\"language\":\"Langue\",\"logout\":\"Deconnexion\",\"profile\":\"Profil\"}');
  dynamic get frenchTranslations => _frenchTranslations;
  set frenchTranslations(dynamic value) {
    _frenchTranslations = value;
  }

  dynamic _englishTranslations = jsonDecode(
      '{\"app_name\":\"My Application\",\"welcome\":\"Welcome\",\"login\":\"Login\",\"email\":\"Email\",\"password\":\"Password\",\"submit\":\"Submit\",\"cancel\":\"Cancel\",\"settings\":\"Settings\",\"language\":\"Language\",\"logout\":\"Logout\",\"profile\":\"Profile\"}');
  dynamic get englishTranslations => _englishTranslations;
  set englishTranslations(dynamic value) {
    _englishTranslations = value;
  }

  dynamic _sangoTranslations = jsonDecode(
      '{\"app_name\":\"App ti mbi\",\"welcome\":\"Bâra ôko\",\"login\":\"Duguë\",\"email\":\"E-mail\",\"password\":\"Kôde\",\"submit\":\"Sängö\",\"cancel\":\"Balë\",\"settings\":\"Paramètres\",\"language\":\"Yângâ\",\"logout\":\"Fini duguë\",\"profile\":\"Profil\"}');
  dynamic get sangoTranslations => _sangoTranslations;
  set sangoTranslations(dynamic value) {
    _sangoTranslations = value;
  }
}
