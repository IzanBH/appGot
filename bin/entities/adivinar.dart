import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

class Adivinar {
  static const base = 'https://anapioficeandfire.com/api';

  static Future<List<Map<String, dynamic>>> cargarPersonajes() async {
    final lista = <Map<String, dynamic>>[];
    int personaje = 1;
    while (true) {
      final respuesta = await http
          .get(Uri.parse('$base/characters?page=$personaje&pageSize=50'));
      if (respuesta.statusCode != 200) break;
      final datos = jsonDecode(respuesta.body) as List;
      for (var item in datos) {
        Map<String, dynamic> personaje = item as Map<String, dynamic>;
        if ((personaje['name'] as String).isNotEmpty) {
          lista.add(personaje);
        }
      }
      if (datos.length < 50) break;
      personaje++;
    }
    return lista;
  }

  static String txt(Map<String, dynamic> personaje) => [
        personaje['name'],
        (personaje['aliases'] as List? ?? []),
        (personaje['titles'] as List? ?? [])
      ].join(' ').toLowerCase();

  static bool aplicarFiltro(int indice, Map<String, dynamic> personaje) {
    String texto = txt(personaje);
    String nombre = (personaje['name'] as String).toLowerCase();

    List<String> dragon = ['daenerys', 'targaryen', 'rhaegar', 'aegon'];
    List<String> bastardo = ['snow', 'sand', 'stone', 'rivers', 'flowers'];
    List<String> arma = [
      'jon snow',
      'ned stark',
      'eddard stark',
      'jaime lannister',
      'brienne',
      'sandor',
      'gregor',
      'arya',
      'robb stark',
      'stannis',
      'arthur dayne',
      'drogo',
      'euron',
      'oberyn',
      'barristan',
      'jorah',
      'daario',
      'bronn',
      'tywin',
      'kevan',
      'victarion',
      'balon',
      'theon',
      'beric',
      'tormund',
      'mance',
      'qotho',
      'haggo',
      'cohollo',
      'syrio',
      'vargo',
      'ulf',
      'hugh hammer',
      'criston cole',
      'daemon targaryen',
      'aemond',
      'gerold',
      'jason lannister',
      'quellon',
      'vickon',
      'steffon',
      'rodrik cassel',
      'jeor mormont',
      'allard',
      'imry',
      'monford',
      'harlen',
      'lyonel',
      'damon lannister',
    ];
    List<String> apellido = [
      'stark',
      'lannister',
      'targaryen',
      'baratheon',
      'greyjoy',
      'martell',
      'tyrell'
    ];
    List<String> noble = ['lord', 'lady', 'prince', 'princess'];
    List<String> inteligente = ['tyrion', 'cersei', 'petyr', 'varys'];
    List<String> norte = ['wildling', 'mance', 'tormund', 'ygritte'];
    List<String> traicionado = [
      'ned',
      'robb',
      'jon',
      'daenerys',
      'tyrion',
      'stannis',
      'robert'
    ];
    List<String> trono = ['king', 'queen', 'prince'];
    List<String> fuerte = ['gregor', 'sandor', 'brienne', 'drogo'];
    List<String> magia = ['melisandre', 'bran', 'thoros', 'bloodraven'];

    List<String> adulto = [
      'lord',
      'lady',
      'king',
      'queen',
      'ser ',
      'khal',
      'lady',
      'sir',
      'khal',
      'khaleesi',
      'maester',
      'brienne '
    ];
    List<String> bueno = [
      'stark',
      'jon snow',
      'arya',
      'samwell',
      'brienne',
      'samwell'
    ];
    List<String> resucitado = [
      'jon snow',
      'beric',
      'catelyn',
      'gregor',
      'rey de la noche'
    ];

    List<String> stark = [
      'stark',
      'jon snow',
      'ned',
      'robb',
      'arya',
      'sansa',
      'bran',
      'rickon'
    ];

    List<String> lannister = [
      'lannister',
      'tyrion',
      'jaime',
      'cersei',
      'tywin',
      'kevan'
    ];

    List<String> targaryen = [
      'targaryen',
      'daenerys',
      'viserys',
      'rhaegar',
      'aemon'
    ];

    List<String> baratheon = [
      'baratheon',
      'robert',
      'stannis',
      'renly',
      'joffrey',
      'tommen'
    ];
    bool esMujer = personaje['gender'] == 'Female';
    bool esProtagonista = (personaje['tvSeries'] as List? ?? []).isNotEmpty;
    bool apareceEnTv = (personaje['tvSeries'] as List? ?? []).isNotEmpty;
    bool estaVivo = (personaje['died'] as String? ?? '').isEmpty;
    List<String> pareja = [
      'samwell', 'sam tarly', 'oberyn', 'oberyn nymeros',
      'jon snow', 'tormund', 'mance', 'daario',

      // Stark
      'ned stark', 'eddard stark', 'robb stark', 'rickard stark',
      'benjen stark', 'lyanna stark',

      // Lannister
      'tyrion', 'jaime', 'cersei', 'tywin', 'kevan',
      'lancel', 'stafford',

      // Targaryen
      'daenerys', 'rhaegar', 'viserys', 'aegon',
      'daemon targaryen', 'jaehaerys',

      // Baratheon
      'robert', 'stannis', 'renly', 'steffon',

      // Greyjoy
      'balon', 'euron', 'theon', 'victarion', 'quellon',

      // Tyrell
      'mace', 'loras', 'margaery', 'garlan', 'willas',

      // Martell
      'doran', 'elia', 'quentyn', 'maron martell',

      // Otros importantes
      'drogo', 'jorah', 'davos', 'roose', 'ramsay',
      'petyr', 'littlefinger', 'varys', 'bronn',
      'barristan', 'beric', 'howland', 'hoster',
      'edmure', 'lysa', 'jon arryn', 'walder frey',
      'illyrio', 'hizdahr', 'mero', 'syrio',
    ];
    bool variasTemporadas = (personaje['tvSeries'] as List? ?? []).length > 1;

    bool tieneDragon = false;
    for (String solucion in dragon) {
      if (nombre.contains(solucion)) tieneDragon = true;
    }

    bool esBastardo = false;
    for (String solucion in bastardo) {
      if (nombre.contains(solucion)) esBastardo = true;
    }
    bool tienePareja = false;
    for (String solucion in pareja) {
      if (nombre.contains(solucion)) tienePareja = true;
    }
    bool tieneArma = false;
    for (String solucion in arma) {
      if (texto.contains(solucion)) tieneArma = true;
    }

    bool tieneApellido = false;
    for (String solucion in apellido) {
      if (nombre.contains(solucion)) tieneApellido = true;
    }

    bool esNoble = false;
    for (String solucion in noble) {
      if (texto.contains(solucion)) esNoble = true;
    }

    bool esInteligente = false;
    for (String solucion in inteligente) {
      if (nombre.contains(solucion)) esInteligente = true;
    }

    bool esDelNorte = false;
    for (String solucion in norte) {
      if (texto.contains(solucion)) esDelNorte = true;
    }

    bool fueTraicionado = false;
    for (String solucion in traicionado) {
      if (nombre.contains(solucion)) fueTraicionado = true;
    }

    bool aspiranteAlTrono = false;
    for (String solucion in trono) {
      if (texto.contains(solucion)) aspiranteAlTrono = true;
    }

    bool esFuerte = false;
    for (String solucion in fuerte) {
      if (texto.contains(solucion)) esFuerte = true;
    }

    bool tieneMagia = false;
    for (String solucion in magia) {
      if (nombre.contains(solucion)) tieneMagia = true;
    }

    bool esAdulto = false;
    for (String solucion in adulto) {
      if (texto.contains(solucion)) esAdulto = true;
    }

    bool esBueno = false;
    for (String solucion in bueno) {
      if (nombre.contains(solucion)) esBueno = true;
    }
    bool resucita = false;
    for (String solucion in resucitado) {
      if (nombre.contains(solucion)) resucita = true;
    }

    bool esStark = false;
    for (String solucion in stark) {
      if (nombre.contains(solucion)) esStark = true;
    }

    bool esLannister = false;
    for (String solucion in lannister) {
      if (nombre.contains(solucion)) esLannister = true;
    }

    bool esTargaryen = false;
    for (String solucion in targaryen) {
      if (nombre.contains(solucion)) esTargaryen = true;
    }

    bool esBaratheon = false;
    for (String solucion in baratheon) {
      if (nombre.contains(solucion)) esBaratheon = true;
    }
    List<bool> filtros = [
      esMujer,
      esAdulto,
      estaVivo,
      esBueno,
      esNoble,
      tieneApellido,
      tienePareja,
      variasTemporadas,
      tieneDragon,
      esBastardo,
      apareceEnTv,
      tieneArma,
      esProtagonista,
      esFuerte,
      esInteligente,
      esDelNorte,
      fueTraicionado,
      aspiranteAlTrono,
      tieneMagia,
      resucita,
      esStark,
      esLannister,
      esTargaryen,
      esBaratheon,
    ];

    return filtros[indice];
  }

  static List<String> preguntas = [
    '¿Es mujer?', // 0
    '¿Es adulto?', // 1
    '¿Sigue con vida?', // 2
    '¿Es buena persona?', // 3
    '¿Es tiene alto rango?', // 4
    '¿Tiene apellido de gran casa?', // 5
    '¿Tiene pareja?', // 6
    '¿Aparece en más de 1 tempoarda?', // 7
    '¿Tiene dragones?', // 8
    '¿Es bastardo?', // 9
    '¿Aparece en la serie de televisión?', // 10
    '¿Tiene un arma?', // 11

    '¿Es protagonista ?', // 13
    '¿Es conocido por su fuerza física?', // 14
    '¿Es conocido por su inteligencia?', // 15
    '¿Viene de más allá del Muro?', // 16
    '¿Ha sido traicionado?', // 17
    '¿Ha querido el Trono de Hierro?', // 18
    '¿Tiene poderes mágicos?', // 19
    '¿Puede resucitar a los muertos?',
    '¿Es de la Casa Stark?', // 33
    '¿Es de la Casa Lannister?', // 34
    '¿Es de la Casa Targaryen?', // 35
    '¿Es de la Casa Baratheon?', // 36
  ];

  bool leerSiNo(String respuesta) {
    while (true) {
      stdout.writeln('$respuesta nombre: ');
      final resultado = stdin.readLineSync()?.trim().toLowerCase() ?? '';
      if (resultado == 'si') return true;
      if (resultado == 'no') return false;
    }
  }

  Future<String> jugar() async {
    final todosLosPersonajes = await cargarPersonajes();
    List<Map<String, dynamic>> candidatos = List.from(todosLosPersonajes);
    stdout.writeln('${candidatos.length} personajes cargados.');
    List<int> indices = List.generate(preguntas.length, (i) => i);
    List<int> indicesMezclados = [];
    while (indices.isNotEmpty) {
      int inice = Random().nextInt(indices.length);
      indicesMezclados.add(indices[inice]);
      indices.removeAt(inice);
    }

    for (int i = 0; i < indicesMezclados.length; i++) {
      int indice = indicesMezclados[i];
      // ... tu lógica de filtrado ...
      String pregunta = preguntas[indice];
      bool respuesta = leerSiNo(pregunta);
      List<Map<String, dynamic>> filtrados = [];
      for (var personaje in candidatos) {
        if (aplicarFiltro(indice, personaje) == respuesta) {
          filtrados.add(personaje);
        }
      }

      if (candidatos.isEmpty) {
        stdout.writeln('No lo sé. ¡Me has ganado!');
        return 'home';
      }
      if (candidatos.length == 1) {
        final candidato = candidatos.first;
        stdout.writeln('¡Creo que es: ${candidato['name']}!');
        stdout.write('¿Acerté? (si/no): ');
        String ok = stdin.readLineSync()?.trim().toLowerCase() ?? '';
        if (ok == 'si') {
          stdout.writeln('¡Bien! Lo sabía.');
          stdout.writeln('Pulsa Enter para volver...');
          stdin.readLineSync();
          return 'home';
        } else {
          stdout.writeln('¡Vaya! Sigo intentándolo...');
          candidatos = todosLosPersonajes
              .where((nombre) => nombre['name'] != candidato['name'])
              .toList();
          indice = -1;
        }
      }
    }

    Map<String, dynamic> acertar = candidatos.first;
    stdout.writeln('¡Creo que es: ${acertar['name']}!');
    stdout.write('¿Acerté? : ');
    String ok = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    stdout.writeln(ok == 'si' ? '¡Bien! Lo sabía.' : 'Vaya... ¡La próxima!');
    stdout.writeln('Pulsa Enter para volver...');
    stdin.readLineSync();
    return 'home';
  }

  static Future<String> adivinar() async {
    Adivinar instancia = Adivinar();
    return await instancia.jugar();
  }
}
