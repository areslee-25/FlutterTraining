extension JsonFormatter on Map<String, dynamic> {
  dynamic decode<T>(
    String key, {
    String? alternativeKey,
  }) {
    try {
      dynamic data = this[key];
      if (data == null) {
        if (alternativeKey != null) {
          return decode(alternativeKey);
        }
        //  debug
        //  print('Json Key = $key is Null');
      }
      return convertDynamicToType<T>(data);
    } catch (e) {
      print('Parse Json Error: $e, Key: $key');
    }
  }

  dynamic convertDynamicToType<T>(dynamic data) {
    dynamic result = data;

    switch (T) {
      case int:
        result = data != null ? (data as num).toInt() : 0;
        break;
      case double:
        result = data != null ? (data as num).toDouble() : 0.0;
        break;
      default:
        result = data != null ? data : "";
        break;
    }
    return result as T;
  }
}
