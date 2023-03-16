import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ticketing/cubit/language_cubit.dart';

import 'package:ticketing/locales/am.dart' as am;
import 'package:ticketing/locales/en.dart' as en;

String $t(BuildContext context, String key, [String defaultValue = '***']) {
  try {
    final List<String> parts = key.split('.');
    final AppLocale currentLocale =
        BlocProvider.of<LanguageCubit>(context, listen: true).state.locale;
    // context.select<LanguageCubit>().state.locale;
    final lang = currentLocale == AppLocale.am ? am.am : en.en;
    dynamic result = lang[parts[0]];
    for (var i = 1; i < parts.length; i++) result = result[parts[i]];
    return result ?? 'xxx';
  } catch (ex) {
    return defaultValue;
  }
}
