import 'package:flutter_dev_test/data/datasources/item/item_remote_datasource.dart';
import 'package:flutter_dev_test/data/repositories/item_repository_impl.dart';
import 'package:flutter_dev_test/domain/usecases/items/get_items.dart';
import 'package:flutter_dev_test/presentation/blocs/item_list/item_list_bloc.dart';
import 'package:get_it/get_it.dart';

var getIt = GetIt.instance;

inject() {
  getIt.registerLazySingleton<ItemRemoteDatasource>(
      () => ItemRemoteDatasource());

  getIt.registerLazySingleton<ItemRepositoryImpl>(
      () => ItemRepositoryImpl(getIt.get<ItemRemoteDatasource>()));

  getIt.registerLazySingleton<GetItems>(
      () => GetItems(getIt.get<ItemRepositoryImpl>()));

  getIt
      .registerFactory<ItemListBloc>(() => ItemListBloc(getIt.get<GetItems>()));
}
