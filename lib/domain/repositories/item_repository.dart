import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/domain/entities/item_entity.dart';
import 'package:flutter_dev_test/utils/failures.dart';

abstract class ItemRepository {
  Future<Either<Failure, List<ItemEntity>>> getItems(
      int start, int limit, String nameFilter);
}
