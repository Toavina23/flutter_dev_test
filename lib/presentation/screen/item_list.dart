import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/domain/entities/item_entity.dart';
import 'package:flutter_dev_test/presentation/blocs/item_list/item_list_bloc.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemListBlock = context.read<ItemListBloc>();
    _scrollController.addListener(
      () {
        var nextPageTrigger = 0.95 * _scrollController.position.maxScrollExtent;
        if (nextPageTrigger < _scrollController.position.pixels) {
          itemListBlock.add(FetchItemList());
        }
      },
    );
    return Scaffold(
      appBar: AppBar(title: const Text("My items")),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: BlocBuilder<ItemListBloc, ItemListState>(
            bloc: itemListBlock,
            builder: (context, state) {
              if (state.status == ItemListStatus.loading &&
                  state.items.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status == ItemListStatus.loaded) {
                int itemsCount = state.items.length;
                int startIndex = state.currentPage > 0 ? itemsCount : 0;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: itemsCount + 1,
                  itemBuilder: (_, index) {
                    int computedIndex = startIndex + index;
                    if (computedIndex == itemsCount) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    ItemEntity currentItem = state.items[computedIndex];
                    return ListTile(
                        title: ItemComponent(
                      item: currentItem,
                    ));
                  },
                );
              } else if (state.status == ItemListStatus.failed) {
                return Center(
                  child: Text(state.failure!.message),
                );
              }
              return Container();
            },
          )),
    );
  }
}

class ItemComponent extends StatelessWidget {
  const ItemComponent({super.key, required this.item});
  final ItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 3,
      children: [
        Image(image: NetworkImage(item.thumbnailUrl)),
        Text(item.title),
      ],
    );
  }
}
