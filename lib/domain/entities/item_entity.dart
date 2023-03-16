import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  const ItemEntity(
      this.albumId, this.id, this.title, this.url, this.thumbnailUrl);
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  @override
  List<Object?> get props => [albumId, id, title, url, thumbnailUrl];
}
