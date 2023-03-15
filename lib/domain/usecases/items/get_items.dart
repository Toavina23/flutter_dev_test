import 'package:dartz/dartz.dart';
import 'package:flutter_dev_test/domain/entities/item_entity.dart';
import 'package:flutter_dev_test/domain/repositories/item_repository.dart';
import 'package:flutter_dev_test/domain/usecases/usecase.dart';
import 'package:flutter_dev_test/utils/failures.dart';

class GetItemsParams {
  GetItemsParams(this.start, this.limit);
  final int start;
  final int limit;
}

class GetItems
    implements Usecase<GetItemsParams, Either<Failure, List<ItemEntity>>> {
  GetItems(this._itemRepository);
  final ItemRepository _itemRepository;

  @override
  execute(params) async {
    var items = await _itemRepository.getItems(params.start, params.limit);
    return items;
  }
}
