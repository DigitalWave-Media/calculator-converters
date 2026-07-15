import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppShareService {
  static const MethodChannel _channel =
      MethodChannel('com.digitalwave.calculatorconverters/app_share');

  /// Shares the application's APK file via system share chooser on Android,
  /// or displays share information on fallback platforms.
  static Future<void> shareApp(BuildContext context) async {
    try {
      final bool? success = await _channel.invokeMethod<bool>('shareApp');
      if (success != true && context.mounted) {
        _showFallbackShareDialog(context);
      }
    } on PlatformException catch (e) {
      debugPrint('Error sharing app APK: ${e.message}');
      if (context.mounted) {
        _showFallbackShareDialog(context);
      }
    } catch (e) {
      debugPrint('Unexpected error sharing app APK: $e');
      if (context.mounted) {
        _showFallbackShareDialog(context);
      }
    }
  }

  static void _showFallbackShareDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Share Calculator & Converters',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Text(
          'Share the Calculator & Converters app with your friends and family!',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
