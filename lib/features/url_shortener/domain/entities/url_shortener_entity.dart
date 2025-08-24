import 'package:equatable/equatable.dart';

class ShortUrlEntity extends Equatable {
  final String alias;
  final String originalUrl;
  final String shortUrl;

  ShortUrlEntity({
    required this.alias,
    required this.originalUrl,
    required this.shortUrl,
  });

  @override
  List<Object?> get props => [alias, originalUrl, shortUrl];
}
