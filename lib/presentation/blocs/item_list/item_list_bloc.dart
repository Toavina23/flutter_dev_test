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
    on<FilterItemList>(_onFilterItemList);
  }
  _onFetchItemList(FetchItemList event, Emitter<ItemListState> emit) async {
    emit(state.copyWith(status: ItemListStatus.loading));
    Either<Failure, List<ItemEntity>> result =
        await _getItems.execute(GetItemsParams(state.currentPage, itemPerPage));
    result.fold((failure) {
      emit(state.copyWith(status: ItemListStatus.failed, failure: failure));
    }, (items) {
      List<ItemEntity> mergedItemList = [...state.items, ...items];
      if (event.searchTitle != null && event.searchTitle!.isNotEmpty) {
        List<ItemEntity> filteredItems =
            _filterItems(mergedItemList, event.searchTitle!);
        emit(state.copyWith(
            status: ItemListStatus.loaded,
            items: filteredItems,
            currentPage: state.currentPage + 1));
      } else {
        emit(state.copyWith(
            status: ItemListStatus.loaded,
            items: [...state.items, ...items],
            currentPage: state.currentPage + 1));
      }
    });
  }

  _onFilterItemList(FilterItemList event, Emitter<ItemListState> emit) {
    if (event.searchTitle.isNotEmpty) {
      List<ItemEntity> filteredItems =
          _filterItems(state.items, event.searchTitle);
      emit(state.copyWith(items: filteredItems));
    } else {
      add(const FetchItemList());
    }
  }

  _filterItems(List<ItemEntity> items, String title) {
    List<ItemEntity> filteredItems = [];
    for (var item in state.items) {
      if (item.title.contains(title)) filteredItems.add(item);
    }
    return filteredItems;
  }
}
