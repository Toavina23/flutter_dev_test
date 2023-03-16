part of 'item_list_bloc.dart';

@immutable
abstract class ItemListEvent {}

class FetchItemList implements ItemListEvent {
  const FetchItemList({this.searchTitle});
  final String? searchTitle;
}

class FilterItemList implements ItemListEvent {
  const FilterItemList(this.searchTitle);
  final String searchTitle;
}
