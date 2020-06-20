import 'package:flutter/painting.dart';
import 'package:quiver/collection.dart';

/// Caches laid-out [TextPainter] widgets, since it is expensive to layout them every frame
class TextLayoutCache {
  /// Create a [TextLayoutCache]
  TextLayoutCache(this._textDirection, int maximumSize) : _cache = LruMap<int, TextPainter>(maximumSize: maximumSize);

  final LruMap<int, TextPainter> _cache;
  final TextDirection _textDirection;
  static TextLayoutCache _globalCache;
  static TextLayoutCache get inst => _globalCache ??= TextLayoutCache(TextDirection.ltr, 250);

  /// Get cached painter or layout new
  TextPainter getOrPerformLayout(TextSpan text, {double maxWidth = double.infinity}) {
    final cachedPainter = _cache[hashValues(text.hashCode, maxWidth)];
    if (cachedPainter != null) {
      return cachedPainter;
    } else {
      return _performAndCacheLayout(text, maxWidth);
    }
  }

  TextPainter _performAndCacheLayout(TextSpan text, double maxWidth) {
    final textPainter = TextPainter(text: text, textDirection: _textDirection)..layout(maxWidth: maxWidth);

    _cache[hashValues(text.hashCode, maxWidth)] = textPainter;

    return textPainter;
  }
}
