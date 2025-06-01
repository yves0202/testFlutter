import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'sg', 'fr'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? sgText = '',
    String? frText = '',
  }) =>
      [enText, sgText, frText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // HomePage
  {
    'j93dbkk2': {
      'en': 'Buscar',
      'fr': 'Rechercher',
      'sg': '',
    },
    'lkd28unq': {
      'en': 'Hola, Byron Canga',
      'fr': 'Bonjour, Byron Canga',
      'sg': '',
    },
    '7vqczx67': {
      'en': 'Qué estás buscando ?',
      'fr': 'Qu\'est-ce que tu cherches ?',
      'sg': '',
    },
    'kgmnr0lv': {
      'en': 'Rentar Casa',
      'fr': 'Louer une maison',
      'sg': '',
    },
    'k0tzhz1z': {
      'en': 'Apartamentos',
      'fr': 'Appartements',
      'sg': '',
    },
    'hsckyeou': {
      'en': 'Compartido',
      'fr': 'Partager',
      'sg': '',
    },
    '0i20qkys': {
      'en': 'Loft',
      'fr': 'Grenier',
      'sg': '',
    },
    'hijiqexv': {
      'en': 'Justo para ti',
      'fr': 'Juste pour toi',
      'sg': '',
    },
    'fnwbshi2': {
      'en': 'Ver más',
      'fr': 'Voir plus',
      'sg': '',
    },
    'k0ptbqdb': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '',
    },
    'd63755qt': {
      'en': 'Pear House',
      'fr': 'Maison de la poire',
      'sg': '',
    },
    'x2y44v64': {
      'en': '\$1150',
      'fr': '1150 \$',
      'sg': '',
    },
    '2fzqjpa6': {
      'en': 'Cartajena, Colombia ',
      'fr': 'Cartajena, Colombie',
      'sg': '',
    },
    '9f7ljl9n': {
      'en': '3 habitaciones',
      'fr': '3 chambres',
      'sg': '',
    },
    'ejl4jn3s': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': '',
    },
    'srxd3j5b': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': '',
    },
    'la6hdakb': {
      'en': '4,7',
      'fr': '4,7',
      'sg': '',
    },
    'zueybegm': {
      'en': 'Doral',
      'fr': 'Doral',
      'sg': '',
    },
    'b04zv1xu': {
      'en': '\$850',
      'fr': '850 \$',
      'sg': '',
    },
    'ff4neb1s': {
      'en': 'Quito, Ecuador',
      'fr': 'Quito, Équateur',
      'sg': '',
    },
    '6dt9a4hf': {
      'en': '4 habitaciones',
      'fr': '4 chambres',
      'sg': '',
    },
    '9om1yd4d': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': '',
    },
    'w55lblo7': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': '',
    },
    '66s790kf': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '',
    },
    'cokoxv3x': {
      'en': 'Venecia',
      'fr': 'Venise',
      'sg': '',
    },
    '9gucmn8b': {
      'en': '\$2500',
      'fr': '2500 \$',
      'sg': '',
    },
    'e6zz47fb': {
      'en': 'Madrid, España',
      'fr': 'Madrid, Espagne',
      'sg': '',
    },
    'tavu2vfl': {
      'en': '4 habitaciones',
      'fr': '4 chambres',
      'sg': '',
    },
    '889s0vgc': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': '',
    },
    'vba44ch3': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': '',
    },
    '057inss0': {
      'en': 'Populares',
      'fr': 'Populaires',
      'sg': '',
    },
    '21688ju3': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '',
    },
    '33piryco': {
      'en': 'Plaza Sol',
      'fr': 'Plaza Sol',
      'sg': '',
    },
    'oe5icipm': {
      'en': 'Santo Domingo, Ecuador',
      'fr': 'Saint-Domingue, Équateur',
      'sg': '',
    },
    'dp6zd82i': {
      'en': '\$980',
      'fr': '980 \$',
      'sg': '',
    },
    '4xfc3juc': {
      'en': '2 Habitaciones',
      'fr': '2 chambres',
      'sg': '',
    },
    'z92k0p7b': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': '',
    },
    'hd2wr8fw': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': '',
    },
    'kr5vog5r': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '',
    },
    'fcgmremm': {
      'en': 'San Francisco',
      'fr': 'San Francisco',
      'sg': '',
    },
    'ln9d8vuk': {
      'en': 'Roma, Italia',
      'fr': 'Rome, Italie',
      'sg': '',
    },
    'mb0qfq2y': {
      'en': '\$1150',
      'fr': '1150 \$',
      'sg': '',
    },
    'nrv8zozk': {
      'en': '2 Habitaciones',
      'fr': '2 chambres',
      'sg': '',
    },
    'to2hg78d': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': '',
    },
    '3jexteyt': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': '',
    },
    '8twkr8ag': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '',
    },
    '1y4lvmc7': {
      'en': 'Percia',
      'fr': 'Percie',
      'sg': '',
    },
    'ltr13c9i': {
      'en': 'El Carmen, Ecuador',
      'fr': 'El Carmen, Équateur',
      'sg': '',
    },
    '0gm65hej': {
      'en': '\$3450',
      'fr': '3450 \$',
      'sg': '',
    },
    'o8k77cuh': {
      'en': '2 Habitaciones',
      'fr': '2 chambres',
      'sg': '',
    },
    'vu78p8n7': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': '',
    },
    'u2xfqor0': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': '',
    },
    'tut4nbx3': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': '',
    },
  },
  // Detalle
  {
    'uapkcxcd': {
      'en': 'Pear House',
      'fr': 'Maison de la poire',
      'sg': '',
    },
    'm5q9wwcw': {
      'en': '\$1150',
      'fr': '1150 \$',
      'sg': '',
    },
    'owcbsy9y': {
      'en': 'Solo, Central Java',
      'fr': 'Solo, Java central',
      'sg': '',
    },
    'ettw0t8k': {
      'en': '2 habitaciones',
      'fr': '2 chambres',
      'sg': '',
    },
    'fknohpxt': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': '',
    },
    'eadfxe29': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': '',
    },
    '3otyc53b': {
      'en': 'Descripcion',
      'fr': 'Description',
      'sg': '',
    },
    'vuy17juk': {
      'en':
          'Minimalist and clean house with modern interior in the Central of Java. Take a virtual tour and discover it from the inside ',
      'fr':
          'Maison minimaliste et épurée, à l\'intérieur moderne, située dans le centre de Java. Découvrez-la de l\'intérieur grâce à une visite virtuelle.',
      'sg': '',
    },
    'mqnfuxke': {
      'en': 'Galería',
      'fr': 'Galerie',
      'sg': '',
    },
    'bu9ge757': {
      'en': 'Book Now',
      'fr': 'Réservez maintenant',
      'sg': '',
    },
    'y3crb847': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': '',
    },
  },
  // TestHome
  {
    'o8f6wgli': {
      'en': 'Language',
      'fr': '',
      'sg': '',
    },
    'v7qy57tb': {
      'en': 'Search...',
      'fr': '',
      'sg': '',
    },
    '8e7j1xay': {
      'en': 'English',
      'fr': '',
      'sg': '',
    },
    'dmlp8vef': {
      'en': 'Francais',
      'fr': '',
      'sg': '',
    },
    '60647jhj': {
      'en': 'Sango',
      'fr': '',
      'sg': '',
    },
    'bbj815my': {
      'en': 'Next',
      'fr': '',
      'sg': '',
    },
    'hp2qbrxp': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': '',
    },
  },
  // TestHomeCopy
  {
    'fszywf63': {
      'en': 'Hello World',
      'fr': '',
      'sg': '',
    },
    'n24mpyvp': {
      'en': 'Hello World',
      'fr': '',
      'sg': '',
    },
    'x1slm02k': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': '',
    },
  },
  // Miscellaneous
  {
    '8vx8iska': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'ro1o0ulg': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'qllf2n7n': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'ti171il6': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    '630nsfoj': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'o2al05gk': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'op1f0ks2': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    's9436r6n': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'kqacd125': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'amtpaydt': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'tgn7nuy2': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    '6b2mla7p': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'zkrk5kff': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'pord5omr': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'z4j5tvoh': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'vu5j9wck': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    '6yhys501': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'sy2es2m0': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'l9meizac': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    '4lj81r9s': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'yorelsux': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    'djt1ou06': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    '8nzb7ee5': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    '4hdiebdu': {
      'en': '',
      'fr': '',
      'sg': '',
    },
    's3ni109m': {
      'en': '',
      'fr': '',
      'sg': '',
    },
  },
].reduce((a, b) => a..addAll(b));
