import 'package:flutter/material.dart';

enum Flavor { dev, stg, product }

@immutable
class Environment {
  static Flavor flavor = Flavor.dev;

  static late final Environment instance = Environment.of();

  final String endpoint;
  final String apiKey;

  const Environment._({
    required this.endpoint,
    required this.apiKey,
  });

  factory Environment.of() {
    switch (flavor) {
      case Flavor.dev:
        return Environment._dev();
      case Flavor.stg:
        return Environment._stg();
      default:
        return Environment._product();
    }
  }

  factory Environment._dev() {
    return const Environment._(
      endpoint: 'api.themoviedb.org',
      apiKey: 'c29a024e152bfd1ad3d4d0dc8cb48019',
    );
  }

  factory Environment._stg() {
    return const Environment._(
      endpoint: 'api.themoviedb.org',
      apiKey: 'c29a024e152bfd1ad3d4d0dc8cb48019',
    );
  }

  factory Environment._product() {
    return const Environment._(
      endpoint: 'api.themoviedb.org',
      apiKey: 'c29a024e152bfd1ad3d4d0dc8cb48019',
    );
  }
}
