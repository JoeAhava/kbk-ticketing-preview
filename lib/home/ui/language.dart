import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing/cubit/language_cubit.dart';
import 'package:ticketing/utils.dart';

class Language extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => Language());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text($t(context, 'language.appbar')),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          _Language('English',
              active: BlocProvider.of<LanguageCubit>(context, listen: true)
                      .state
                      .locale ==
                  AppLocale.en,
              langCode: AppLocale.en),
          _Language('አማርኛ',
              active: BlocProvider.of<LanguageCubit>(context, listen: true)
                      .state
                      .locale ==
                  AppLocale.am,
              langCode: AppLocale.am),
        ],
      ),
    );
  }
}

class _Language extends StatelessWidget {
  final String language;
  final AppLocale langCode;
  final bool active;

  _Language(this.language, {this.active = false, this.langCode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              active
                  ? Icon(Icons.check_circle,
                      color: Theme.of(context).primaryColor)
                  : SizedBox(width: 10, height: 10)
            ],
          ),
        ),
      ),
      onTap: () {
        context.read<LanguageCubit>().changeLang(this.langCode);
      },
    );
  }
}
