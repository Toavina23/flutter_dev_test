import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dev_test/domain/entities/item_entity.dart';
import 'package:flutter_dev_test/domain/usecases/items/get_items.dart';
import 'package:flutter_dev_test/utils/failures.dart';
import 'package:meta/meta.dart';

part 'item_list_event.dart';
part 'item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  final int itemPerPage = 8;
  final GetItems _getItems;
  ItemListBloc(this._getItems) : super(const ItemListState()) {
    on<FetchItemList>(_onFetchItemList);
  }
  _onFetchItemList(FetchItemList event, Emitter<ItemListState> emit) async {
    emit(state.copyWith(status: ItemListStatus.loading));
    Either<Failure, List<ItemEntity>> result =
        await _getItems.execute(GetItemsParams(state.currentPage, itemPerPage));
    result.fold((failure) {
      emit(state.copyWith(status: ItemListStatus.failed, failure: failure));
    }, (items) {
      emit(state.copyWith(
          status: ItemListStatus.loaded, items: [...state.items, ...items]));
    });
  }
}
