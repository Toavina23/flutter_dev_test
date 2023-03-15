part of 'item_list_bloc.dart';

enum ItemListStatus { loading, failed, loaded, initial }

@immutable
class ItemListState extends Equatable {
  final ItemListStatus status;
  final List<ItemEntity> items;
  final Failure? failure;
  final int currentPage;

  const ItemListState(
      {this.status = ItemListStatus.initial,
      this.items = const [],
      this.failure,
      this.currentPage = 0});

  ItemListState copyWith(
      {ItemListStatus? status,
      List<ItemEntity>? items,
      Failure? failure,
      int? currentPage}) {
    return ItemListState(
        status: status ?? this.status,
        items: items ?? this.items,
        failure: failure ?? this.failure,
        currentPage: currentPage ?? this.currentPage);
  }

  @override
  List<Object?> get props => [items, failure];
}
