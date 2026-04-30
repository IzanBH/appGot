import 'dart:io';
import 'utils/navegacion.dart';
import 'utils/database.dart';

void main() async {
  await DataBase.instalacion();
  String menu = Navegacion.inicio;
  while (true) {
    switch (menu) {
      case "principal":
        menu = Navegacion.principal();
        break;
      case "registro":
        menu = await Navegacion.registro();
        break;
      case "login":
        menu = await Navegacion.login();
        break;
      case "home":
        menu = await Navegacion.home();
        break;
      case "relacion":
        menu = await Navegacion.relacionpersonaje();
        break;
      case "adivinar":
        menu = await Navegacion.adivinar();
        break;
      case "buscar":
        menu = await Navegacion.buscar();
        break;
    }
    if (menu == "salir") {
      print("Has elegido salir");
      break;
    }
  }
}
