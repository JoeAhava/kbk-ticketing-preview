import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'language_state.dart';

enum AppLocale { am, en }

class LanguageCubit extends Cubit<LanguageState> {
  final AppLocale currentLocale;
  LanguageCubit({this.currentLocale})
      : super(LanguageState(locale: currentLocale));

  void changeLang(currentLocale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(LanguageState(locale: currentLocale));
    await prefs.setBool(
      'isEnglish',
      currentLocale == AppLocale.en ? true : false,
    );
  }
}
