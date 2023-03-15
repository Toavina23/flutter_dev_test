import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dev_test/presentation/blocs/item_list/item_list_bloc.dart';
import 'package:flutter_dev_test/presentation/screen/item_list.dart';
import 'package:go_router/go_router.dart';

var router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      context.read<ItemListBloc>().add(FetchItemList());
      return const ItemsList();
    },
  )
]);
