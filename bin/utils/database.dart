import 'package:mysql1/mysql1.dart';

abstract class DataBase {
  static final String _host = "localhost"; // 127.0.0.1
  static final int _port = 3306;
  static final String _user = "root";
  static final String _dbName = "juegodetronos";

  static Future<void> instalacion() async {
    var settings = ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
    );
    MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query("CREATE DATABASE IF NOT EXISTS $_dbName");
    await conn.query("USE $_dbName");
    await DataBase.crearTablaUsers(conn);
    await DataBase.crearTablajuegodetronos(conn);
    await conn.close();
  }

  static Future<MySqlConnection> obtenerConexion() async {
    var settings =
        ConnectionSettings(host: _host, port: _port, user: _user, db: _dbName);
    MySqlConnection conn = await MySqlConnection.connect(settings);
    return conn;
  }

  static Future<void> crearTablaUsers(MySqlConnection conn) async {
    await conn.query("""CREATE TABLE IF NOT EXISTS users  (
    iduser INT PRIMARY KEY AUTO_INCREMENT, 
    nombre VARCHAR(20) NOT NULL,
    nick VARCHAR(10) NOT NULL,
    password VARCHAR(10) NOT NULL)""");
  }

  static Future<void> crearTablajuegodetronos(MySqlConnection conn) async {
    await conn.query("""CREATE TABLE IF NOT EXISTS juegodetronos 
  (idjuegodetronos INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  genero VARCHAR(20),
  casa VARCHAR(100),
  nacimiento INT,
  fallecimiento INT)""");
  }

  static Future<void> crearTablaUsuariojuegodetronos(
      MySqlConnection conn) async {
    await conn.query("""CREATE TABLE IF NOT EXISTS usuariojuegodetronos
  (idusuariojuegodetronos INT PRIMARY KEY AUTO_INCREMENT,
  idusuario INT NOT NULL,
  idjuegodetronos INT NOT NULL)""");
  }
}
