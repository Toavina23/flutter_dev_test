import 'package:flutter_dev_test/data/datasources/item/item_datasource.dart';
import 'package:flutter_dev_test/data/models/item_model.dart';
import 'package:flutter_dev_test/domain/entities/item_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/utils/exceptions.dart';
import 'package:flutter_dev_test/domain/repositories/item_repository.dart';
import 'package:flutter_dev_test/utils/failures.dart';

class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl(this._itemDatasource);
  final ItemDatasource _itemDatasource;
  @override
  Future<Either<Failure, List<ItemEntity>>> getItems(
      int start, int limit, String nameFilter) async {
    try {
      List<ItemModel> itemModels =
          await _itemDatasource.fetchItems(start, limit, nameFilter);
      return right(itemModels.map((model) => model.toEntity()).toList());
    } on HttpException catch (e) {
      return left(NetworkFailure(e.message));
    } on UnknownException catch (e) {
      return left(UnknowFailure(e.message));
    }
  }
}
