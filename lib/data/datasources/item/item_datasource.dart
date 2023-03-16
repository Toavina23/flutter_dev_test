import 'package:flutter_dev_test/data/models/item_model.dart';

abstract class ItemDatasource {
  Future<List<ItemModel>> fetchItems(int start, int limit, String nameFilter);
}
