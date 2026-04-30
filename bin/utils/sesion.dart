import "../entities/usuario.dart";
import 'package:mysql1/mysql1.dart';
import 'utils.dart';

abstract class Sesion {
  static Usuario? usuario;

  static Future<bool> login(String nick, String password) async {
    MySqlConnection conn = await DataBase.obtenerConexion();
    var respuesta = await conn.query('SELECT * FROM users WHERE nick = ?', [
      nick,
    ]);
    bool noExiste = respuesta.isEmpty; //es una varable
    if (noExiste || respuesta.first[3] != password) {
      // Si no exsite o la contraseñ no bcoincide false
      await conn.close();
      return false;
    }

    await conn.close();
    usuario = Usuario.fromDataBase(respuesta.first);
    return true;
  }
}
