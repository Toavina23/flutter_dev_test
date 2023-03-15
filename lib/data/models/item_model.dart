import 'package:equatable/equatable.dart';
import 'package:flutter_dev_test/domain/entities/item_entity.dart';

class ItemModel extends Equatable {
  const ItemModel(
      this.albumId, this.id, this.title, this.url, this.thumbnailUrl);
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  factory ItemModel.fromApi(Map<String, dynamic> data) {
    return ItemModel(data['albumId'], data['id'], data['title'], data['url'],
        data['thumbnailUrl']);
  }
  ItemEntity toEntity() {
    return ItemEntity(albumId, id, title, url, thumbnailUrl);
  }

  @override
  List<Object?> get props => [albumId, id, title, url, thumbnailUrl];
}
