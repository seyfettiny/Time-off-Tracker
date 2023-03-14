import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  /*
  TODO: settingsRef = ref.watch(settingsProvider);
  TODO: return LocaleNotifier(Locale(settingsRef.locale), ref);
  */
  return LocaleNotifier(Locale('en'), ref);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(Locale state, this.ref) : super(state);

  final Ref ref;

  void changeLocale(Locale locale) {
    //TODO: ref.watch(/* Update Settings *)
    state = locale;
  }
}
