import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/presentation/blocs/item_list/item_list_bloc.dart';

class ItemsList extends StatefulWidget {
  const ItemsList({super.key});

  @override
  State<ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My items")),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: BlocBuilder<ItemListBloc, ItemListState>(
            builder: (context, state) {
              if (state.status == ItemListStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status == ItemListStatus.loaded) {
                int itemsCount = state.items.length;
                int startIndex = state.currentPage > 0 ? itemsCount : 0;
                return ListView.builder(
                  itemCount: itemsCount,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(state.items[startIndex + index].title),
                    );
                  },
                );
              }
              return Container();
            },
          )),
    );
  }
}
