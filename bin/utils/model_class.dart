import 'package:mysql1/mysql1.dart';
import '../utils/utils.dart';

abstract class ModelClass {
  abstract String tableName;
  abstract String primaryKey;

  fromDataBase(ResultRow row);
  Future<List> all() async {
    MySqlConnection? conn;
    List listado = [];
    try {
      conn = await DataBase.obtenerConexion();
      var registros = await conn.query("SELECT * FROM $tableName");

      for (ResultRow registro in registros) {
        listado.add(fromDataBase(registro));
      }
      return listado;
    } catch (error) {
      print(error);
      return listado;
    } finally {
      if (conn != null) {
      
        conn.close(); 
      } 
    }
  }

  Future get(int id) async {
    MySqlConnection? conn;

    try {
      conn = await DataBase.obtenerConexion();
      var registro = await conn.query(
        "SELECT * FROM $tableName WHERE $primaryKey = ?"[id],
      );
      return fromDataBase(registro.first);
    } catch (error) {
      print(error);
      return int;
    } finally {
      if (conn != null) {
        conn.close();
      }
    }
  }
}
