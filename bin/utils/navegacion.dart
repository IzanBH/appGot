import 'dart:io';
import '../entities/entities.dart';
import '../entities/relacionpersonaje.dart';
import 'dart:async';
import '../entities/adivinar.dart';

abstract class Navegacion {
  static String inicio = "principal";

  static String principal() {
    String opcion;
    do {
      stdout.writeln("""Elige una opción:
    1. Iniciar sesión
    2. Registrarse
    3. Salir""");
      opcion = stdin.readLineSync() ?? "Error";
      if (opcion != "1" && opcion != "2" && opcion != "3") {
        stdout.writeln("Opción no válida");
      }
    } while (opcion != "1" && opcion != "2" && opcion != "3");
    if (opcion == "1") {
      return "login";
    } else if (opcion == "2") {
      return "registro";
    } else {
      return "salir";
    }
  }

  static Future<String> registro() async {
    String nombre;
    String nombreUsuario;
    String password;
    Map<String, String> datos = {};
    do {
      stdout.writeln("""Registro:
  Introduce tu nombre""");
      nombre = stdin.readLineSync() ?? "Error";
      stdout.writeln("Introduce tu nombreUsuario");
      nombreUsuario = stdin.readLineSync() ?? "Error";
      stdout.writeln("Introduce tu contraseña");
      password = stdin.readLineSync() ?? "Error";
      if (nombre.isEmpty || nombreUsuario.isEmpty || password.isEmpty) {
        stdout.writeln("Ningún campo puede estar vacío");
      }
      if (password.length < 6) {
        stdout.writeln("La contraseña no puede tener menos de 6 caracteres");
      }
    } while (nombre.isEmpty ||
        nombreUsuario.isEmpty ||
        password.isEmpty ||
        password.length < 6);

    datos = {"nombre": nombre, "nick": nombreUsuario, "password": password};
    bool registrado = await Usuario.registro(datos);
    if (registrado) {
      print("Te has registrado correctamente");
      return "principal";
    } else {
      print("El usuario ya existe, vuelve a intentarlo");
      return "registro";
    }
  }

  static Future<String> login() async {
    String nombreUsuario;
    String password;
    do {
      stdout.writeln("""Login:
  Introduce tu nombre de usuario""");
      nombreUsuario = stdin.readLineSync() ?? "Error";
      stdout.writeln("Introduce tu contraseña");
      password = stdin.readLineSync() ?? "Error";
      if (nombreUsuario.isEmpty || password.isEmpty) {
        stdout.writeln("Ningún campo puede estar vacío");
      }
      if (password.length < 6) {
        stdout.writeln("La contraseña no puede tener menos de 6 caracteres");
      }
    } while (nombreUsuario.isEmpty || password.isEmpty || password.length < 6);

    bool logeado = await Usuario.login(nombreUsuario, password);
    if (logeado) {
      return "home";
    } else {
      print("Incorrecto");
      return "principal";
    }
  }

  static Future<String> home() async {
    String opcion;
    do {
      stdout.writeln("""Elige:
    1. Relación de personajes
    2. Adivinar personaje
    3. Buscar personaje
    4. Salir""");
      opcion = stdin.readLineSync() ?? "Error";
      if (opcion != "1" && opcion != "2" && opcion != "3" && opcion != "4") {
        stdout.writeln("Opción no válida");
      }
    } while (opcion != "1" && opcion != "2" && opcion != "3" && opcion != "4");

    if (opcion == "1") {
      return "relacion";
    }
    if (opcion == "2") {
      return "adivinar";
    }
    if (opcion == "3") {
      return "buscar";
    }

    return "salir";
  }

  static Future<String> buscar() async {
    print("Escribe el nombre  del  personaje que quieres buscar:");
    String respuesta = stdin.readLineSync() ?? "error";
    Personajes? personaje =
        await Personajes.obtenerjuegodetronos(identificador: respuesta);
    if (personaje == null) {
      print('Error');
      return "buscar";
    }

    print("""Has encontrado un personaje!! 
    Nombre: ${personaje.nombre}
    ID:          ${personaje.idjuegodetronos}
    Género:      ${personaje.genero}
    Casa:        ${personaje.casa}
    Cultura:      ${personaje.cultura}
    Título:       ${personaje.titulos}
    Apodo:        ${personaje.apodos}
    Nacionalidad: ${personaje.nacionalidad}
    Vivo:         ${personaje.vivo == true ? "Sí" : "No"}
}   """);
    stdout.writeln('Pulsa Enter para volver...');
    stdin.readLineSync();

    return "home";
  }

  static Future<String> adivinar() async {
    Adivinar adivinar = Adivinar();
    String res = await adivinar.jugar();

    return res;
  }

  static Future<String> relacionpersonaje() async {
    return await RelacionPersonaje();
  }
}
