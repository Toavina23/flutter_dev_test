import 'package:dio/dio.dart';
import 'package:flutter_dev_test/data/datasources/item/item_datasource.dart';
import 'package:flutter_dev_test/data/models/item_model.dart';
import 'package:flutter_dev_test/utils/exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ItemRemoteDatasource extends ItemDatasource {
  @override
  Future<List<ItemModel>> fetchItems(
      int start, int limit, String nameFilter) async {
    BaseOptions options = BaseOptions(baseUrl: dotenv.env["SERVER_URL"]!);
    Dio dio = Dio(options);
    Map<String, dynamic> queryParams = {
      "_start": start,
      "_limit": limit,
    };
    if (nameFilter.isNotEmpty) {
      queryParams.addAll({"title_like": nameFilter.trim()});
    }
    try {
      var response = await dio.get("/photos", queryParameters: queryParams);
      List<ItemModel> itemsModel = [];
      itemsModel.addAll((response.data as List<dynamic>).map((row) {
        return ItemModel.fromApi(row as Map<String, dynamic>);
      }));
      return itemsModel;
    } on DioError catch (e) {
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 500:
            throw const HttpException(
                "Une erreur est survenue pendant la récupération des données");
          case 404:
            throw const HttpException("Ressource non trouvé");
          default:
            throw const HttpException(
                "Une erreur inconnue est survenue pendant la connexion au serveurs");
        }
      } else {
        throw const HttpException("Le serveur n'a retourné aucune réponse");
      }
    } catch (e) {
      throw const UnknownException(
          "Une erreur inconnue est survenue pendant l'opération");
    }
  }
}
