import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
  (ref) => SettingsController(),
);

class SettingsState {
  const SettingsState({this.storeOriginalImages = true});

  final bool storeOriginalImages;

  SettingsState copyWith({bool? storeOriginalImages}) => SettingsState(
        storeOriginalImages: storeOriginalImages ?? this.storeOriginalImages,
      );
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState()) {
    _load();
  }

  static const _storeImagesKey = 'store_original_images';
  SharedPreferences? _prefs;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_storeImagesKey);
    _prefs = prefs;
    if (value != null) {
      state = state.copyWith(storeOriginalImages: value);
    }
  }

  Future<void> setStoreOriginalImages(bool value) async {
    state = state.copyWith(storeOriginalImages: value);
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setBool(_storeImagesKey, value);
  }
}
