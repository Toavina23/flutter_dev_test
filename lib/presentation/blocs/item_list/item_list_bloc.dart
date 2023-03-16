import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dev_test/domain/entities/item_entity.dart';
import 'package:flutter_dev_test/domain/usecases/items/get_items.dart';
import 'package:flutter_dev_test/utils/failures.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

part 'item_list_event.dart';
part 'item_list_state.dart';

class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  final int itemPerPage = 8;
  final GetItems _getItems;
  final Duration throttleDuration = const Duration(milliseconds: 100);
  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  ItemListBloc(this._getItems) : super(const ItemListState()) {
    on<FetchItemList>(_onFetchItemList,
        transformer: throttleDroppable(throttleDuration));
    on<FilterItemList>(_onFilterItemList);
  }
  _onFetchItemList(FetchItemList event, Emitter<ItemListState> emit) async {
    emit(state.copyWith(status: ItemListStatus.loading));
    Either<Failure, List<ItemEntity>> result = await _getItems.execute(
        GetItemsParams(state.currentPage * itemPerPage, itemPerPage,
            event.searchTitle ?? ""));
    result.fold((failure) {
      emit(state.copyWith(status: ItemListStatus.failed, failure: failure));
    }, (items) {
      if (items.isNotEmpty) {
        emit(state.copyWith(
            status: ItemListStatus.loaded,
            items: [...state.items, ...items],
            currentPage: state.currentPage + 1));
      } else {
        emit(state.copyWith(
            status: ItemListStatus.loaded,
            items: state.items,
            bottomReached: true));
      }
    });
  }

  _onFilterItemList(FilterItemList event, Emitter<ItemListState> emit) {
    if (event.searchTitle.isNotEmpty) {
      List<ItemEntity> filteredItems =
          _filterItems(state.items, event.searchTitle);
      emit(state.copyWith(items: filteredItems));
      if (filteredItems.length < itemPerPage) {
        add(FetchItemList(searchTitle: event.searchTitle));
      }
    } else {
      add(FetchItemList(searchTitle: event.searchTitle));
    }
  }

  _filterItems(List<ItemEntity> items, String title) {
    List<ItemEntity> filteredItems = [];
    for (var item in items) {
      if (item.title.contains(title)) filteredItems.add(item);
    }
    return filteredItems;
  }
}
