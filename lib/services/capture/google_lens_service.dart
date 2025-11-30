import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Сервис для работы с Google Lens
/// Позволяет открыть Google Lens с изображением для перевода и распознавания текста
/// 
/// Примечание: Google Lens не предоставляет публичный API для получения результата обратно,
/// поэтому пользователю нужно будет вручную скопировать переведённый текст из Google Lens
/// и вставить его в приложение
class GoogleLensService {
  /// Пытается открыть Google Lens
  /// 
  /// На Android: пытается открыть через несколько способов:
  /// 1. URL scheme googlelens://
  /// 2. Intent с пакетом com.google.ar.lens
  /// 3. Play Store, если приложение не установлено
  /// 
  /// На iOS: Google Lens доступен через приложение Google
  /// 
  /// Возвращает true, если удалось открыть, false в противном случае
  Future<bool> tryOpenLens() async {
    try {
      if (Platform.isAndroid) {
        // Способ 1: Пробуем открыть через URL scheme
        try {
          final lensUri = Uri.parse('googlelens://');
          if (await canLaunchUrl(lensUri)) {
            final launched = await launchUrl(
              lensUri,
              mode: LaunchMode.externalApplication,
            );
            if (launched) {
              if (kDebugMode) {
                debugPrint('✅ Google Lens открыт через URL scheme');
              }
              return true;
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ Не удалось открыть через URL scheme: $e');
          }
        }

        // Способ 2: Пробуем открыть через Intent с пакетом
        try {
          // Используем market:// для открытия приложения или Play Store
          final marketUri = Uri.parse('market://details?id=com.google.ar.lens');
          if (await canLaunchUrl(marketUri)) {
            final launched = await launchUrl(
              marketUri,
              mode: LaunchMode.externalApplication,
            );
            if (launched) {
              if (kDebugMode) {
                debugPrint('✅ Открыт Play Store для Google Lens');
              }
              return true;
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ Не удалось открыть через Play Store: $e');
          }
        }

        // Способ 3: Пробуем открыть через веб-версию Play Store
        try {
          final webUri = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.google.ar.lens',
          );
          if (await canLaunchUrl(webUri)) {
            final launched = await launchUrl(
              webUri,
              mode: LaunchMode.externalApplication,
            );
            if (launched) {
              if (kDebugMode) {
                debugPrint('✅ Открыт Play Store (веб) для Google Lens');
              }
              return true;
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ Не удалось открыть через веб Play Store: $e');
          }
        }

        // Способ 4: Пробуем открыть через приложение Google (которое содержит Lens)
        try {
          final googleUri = Uri.parse('com.google.android.googlequicksearchbox://');
          if (await canLaunchUrl(googleUri)) {
            final launched = await launchUrl(
              googleUri,
              mode: LaunchMode.externalApplication,
            );
            if (launched) {
              if (kDebugMode) {
                debugPrint('✅ Открыто приложение Google (может содержать Lens)');
              }
              return true;
            }
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('⚠️ Не удалось открыть приложение Google: $e');
          }
        }
      }

      // Если ничего не сработало
      if (kDebugMode) {
        debugPrint('❌ Не удалось открыть Google Lens автоматически');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Ошибка при попытке открыть Google Lens: $e');
      }
      return false;
    }
  }

  /// Проверяет, установлен ли Google Lens на устройстве
  Future<bool> isInstalled() async {
    if (Platform.isAndroid) {
      try {
        // Пробуем несколько способов проверки
        final lensUri = Uri.parse('googlelens://');
        if (await canLaunchUrl(lensUri)) {
          return true;
        }
        
        // Альтернативная проверка через market
        final marketUri = Uri.parse('market://details?id=com.google.ar.lens');
        // Если можем открыть market, значит можем проверить установку
        // Но это не гарантирует, что приложение установлено
        return false;
      } catch (e) {
        return false;
      }
    }
    // На iOS Google Lens доступен через приложение Google
    return true;
  }
}

