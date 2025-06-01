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
      'sg': 'yeke',
    },
    'lkd28unq': {
      'en': 'Hola, Byron Canga',
      'fr': 'Bonjour, Byron Canga',
      'sg': 'baara, Byron Canga',
    },
    '7vqczx67': {
      'en': 'Qué estás buscando ?',
      'fr': 'Qu\'est-ce que tu cherches ?',
      'sg': 'ndo ni yeke ni ?',
    },
    'kgmnr0lv': {
      'en': 'Rentar Casa',
      'fr': 'Louer une maison',
      'sg': 'sengä da',
    },
    'k0tzhz1z': {
      'en': 'Apartamentos',
      'fr': 'Appartements',
      'sg': 'da ti apartment',
    },
    'hsckyeou': {
      'en': 'Compartido',
      'fr': 'Partager',
      'sg': 'kpengba',
    },
    '0i20qkys': {
      'en': 'Loft',
      'fr': 'Grenier',
      'sg': 'loft',
    },
    'hijiqexv': {
      'en': 'Justo para ti',
      'fr': 'Juste pour toi',
      'sg': 'pêpê na mo',
    },
    'fnwbshi2': {
      'en': 'Ver más',
      'fr': 'Voir plus',
      'sg': 'leke yè',
    },
    'k0ptbqdb': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '4,5',
    },
    'd63755qt': {
      'en': 'Pear House',
      'fr': 'Maison de la poire',
      'sg': 'Pear House',
    },
    'x2y44v64': {
      'en': '\$1150',
      'fr': '1150 \$',
      'sg': '\$1150',
    },
    '2fzqjpa6': {
      'en': 'Cartajena, Colombia ',
      'fr': 'Cartajena, Colombie',
      'sg': 'Cartajena, Colombia',
    },
    '9f7ljl9n': {
      'en': '3 habitaciones',
      'fr': '3 chambres',
      'sg': '3 da-kua',
    },
    'ejl4jn3s': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': 'Wifi',
    },
    'srxd3j5b': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': 'Garage',
    },
    'la6hdakb': {
      'en': '4,7',
      'fr': '4,7',
      'sg': '4,7',
    },
    'zueybegm': {
      'en': 'Doral',
      'fr': 'Doral',
      'sg': 'Doral',
    },
    'b04zv1xu': {
      'en': '\$850',
      'fr': '850 \$',
      'sg': '\$850',
    },
    'ff4neb1s': {
      'en': 'Quito, Ecuador',
      'fr': 'Quito, Équateur',
      'sg': 'Quito, Ecuador',
    },
    '6dt9a4hf': {
      'en': '4 habitaciones',
      'fr': '4 chambres',
      'sg': '4 da-kua',
    },
    '9om1yd4d': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': 'Wifi',
    },
    'w55lblo7': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': 'Garage',
    },
    '66s790kf': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '4,5',
    },
    'cokoxv3x': {
      'en': 'Venecia',
      'fr': 'Venise',
      'sg': 'Venecia',
    },
    '9gucmn8b': {
      'en': '\$2500',
      'fr': '2500 \$',
      'sg': '\$2500',
    },
    'e6zz47fb': {
      'en': 'Madrid, España',
      'fr': 'Madrid, Espagne',
      'sg': 'Madrid, España',
    },
    'tavu2vfl': {
      'en': '4 habitaciones',
      'fr': '4 chambres',
      'sg': '4 da-kua',
    },
    '889s0vgc': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': 'Wifi',
    },
    'vba44ch3': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': 'Garage',
    },
    '057inss0': {
      'en': 'Populares',
      'fr': 'Populaires',
      'sg': 'ayeke zo-kùe',
    },
    '21688ju3': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '4,5',
    },
    '33piryco': {
      'en': 'Plaza Sol',
      'fr': 'Plaza Sol',
      'sg': 'Plaza Sol',
    },
    'oe5icipm': {
      'en': 'Santo Domingo, Ecuador',
      'fr': 'Saint-Domingue, Équateur',
      'sg': 'Santo Domingo, Ecuador',
    },
    'dp6zd82i': {
      'en': '\$980',
      'fr': '980 \$',
      'sg': '\$980',
    },
    '4xfc3juc': {
      'en': '2 Habitaciones',
      'fr': '2 chambres',
      'sg': '2 da-kua',
    },
    'z92k0p7b': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': 'Wifi',
    },
    'hd2wr8fw': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': 'Garage',
    },
    'kr5vog5r': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '4,5',
    },
    'fcgmremm': {
      'en': 'San Francisco',
      'fr': 'San Francisco',
      'sg': 'San Francisco',
    },
    'ln9d8vuk': {
      'en': 'Roma, Italia',
      'fr': 'Rome, Italie',
      'sg': 'Roma, Italia',
    },
    'mb0qfq2y': {
      'en': '\$1150',
      'fr': '1150 \$',
      'sg': '\$1150',
    },
    'nrv8zozk': {
      'en': '2 Habitaciones',
      'fr': '2 chambres',
      'sg': '2 da-kua',
    },
    'to2hg78d': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': 'Wifi',
    },
    '3jexteyt': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': 'Garage',
    },
    '8twkr8ag': {
      'en': '4,5',
      'fr': '4,5',
      'sg': '4,5',
    },
    '1y4lvmc7': {
      'en': 'Percia',
      'fr': 'Percie',
      'sg': 'Percia',
    },
    'ltr13c9i': {
      'en': 'El Carmen, Ecuador',
      'fr': 'El Carmen, Équateur',
      'sg': 'El Carmen, Ecuador',
    },
    '0gm65hej': {
      'en': '\$3450',
      'fr': '3450 \$',
      'sg': '\$3450',
    },
    'o8k77cuh': {
      'en': '2 Habitaciones',
      'fr': '2 chambres',
      'sg': '2 da-kua',
    },
    'vu78p8n7': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': 'Wifi',
    },
    'u2xfqor0': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': 'Garage',
    },
    'tut4nbx3': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': 'da',
    },
  },
  // Detalle
  {
    'uapkcxcd': {
      'en': 'Pear House',
      'fr': 'Maison de la poire',
      'sg': 'Pear House',
    },
    'm5q9wwcw': {
      'en': '\$1150',
      'fr': '1150 \$',
      'sg': '\$1150',
    },
    'owcbsy9y': {
      'en': 'Solo, Central Java',
      'fr': 'Solo, Java central',
      'sg': 'Solo, Central Java',
    },
    'ettw0t8k': {
      'en': '2 habitaciones',
      'fr': '2 chambres',
      'sg': '2 da-kua',
    },
    'fknohpxt': {
      'en': 'Wifi',
      'fr': 'Wifi',
      'sg': 'Wifi',
    },
    'eadfxe29': {
      'en': 'Garage',
      'fr': 'Garage',
      'sg': 'Garage',
    },
    '3otyc53b': {
      'en': 'Descripcion',
      'fr': 'Description',
      'sg': 'fa-ndoli',
    },
    'vuy17juk': {
      'en':
          'Minimalist and clean house with modern interior in the Central of Java. Take a virtual tour and discover it from the inside ',
      'fr':
          'Maison minimaliste et épurée, à l\'intérieur moderne, située dans le centre de Java. Découvrez-la de l\'intérieur grâce à une visite virtuelle.',
      'sg': 'da ti kua-möngö na kêkerêke ti ködörö Java. Leke da na akui',
    },
    'mqnfuxke': {
      'en': 'Galería',
      'fr': 'Galerie',
      'sg': 'galerie',
    },
    'bu9ge757': {
      'en': 'Book Now',
      'fr': 'Réservez maintenant',
      'sg': 'tene fadè',
    },
    'y3crb847': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': 'da',
    },
  },
  // TestHome
  {
    'o8f6wgli': {
      'en': 'Language',
      'fr': 'Langue',
      'sg': 'yângâ',
    },
    'v7qy57tb': {
      'en': 'Search...',
      'fr': 'Recherche...',
      'sg': 'yeke...',
    },
    '8e7j1xay': {
      'en': 'English',
      'fr': 'Anglais',
      'sg': 'anglais',
    },
    'dmlp8vef': {
      'en': 'Francais',
      'fr': 'Français',
      'sg': 'français',
    },
    '60647jhj': {
      'en': 'Sango',
      'fr': 'Sango',
      'sg': 'sängö',
    },
    'bbj815my': {
      'en': 'Next',
      'fr': 'Suivant',
      'sg': 'gbè',
    },
    'hp2qbrxp': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': 'da',
    },
  },
  // TestHomeCopy
  {
    'fszywf63': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
      'sg': 'baara löndö',
    },
    'n24mpyvp': {
      'en': 'Hello World',
      'fr': 'Bonjour le monde',
      'sg': 'baara löndö',
    },
    'x1slm02k': {
      'en': 'Home',
      'fr': 'Maison',
      'sg': 'da',
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
