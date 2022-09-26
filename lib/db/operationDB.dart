import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


import '../models/usuario.dart';
import '../models/cliente.dart'; 
import '../models/sale.dart';

class OperationDB {

static Database? _database;

      Future <Database> get database async{
          return _database ??= await _openDB();
      }
  static Future<Database> _openDB() async {
 
       const tableUsuario = """
            CREATE TABLE usuario(id INTEGER PRIMARY KEY, usuario TEXT, password TEXT,nit TEXT,id_tipo_doc_pe TEXT,id_tipo_doc_rc TEXT)
      ;""";
           const tableCuotaVenta = """
            CREATE TABLE  cuota_venta( id INTEGER PRIMARY KEY AUTOINCREMENT, venta TEXT, cuota TEXT, id_linea TEXT, nombre TEXT, nit TEXT,id_vendedor TEXT,id_suc_vendedor INTEGER)
      ;""";
 
  
     return await  openDatabase(join(await getDatabasesPath(),'pony.db'),onCreate: (db,version) async {
    //   return db.execute("CREATE TABLE usuario(id INTEGER PRIMARY KEY, usuario TEXT, password TEXT,nit TEXT,id_tipo_doc_pe TEXT,id_tipo_doc_rc TEXT)",
        await db.execute(tableUsuario); 
        await db.execute(tableCuotaVenta); 
        print("crearon tablas");
     }, version: 3);
  }

  //insertar los usuarios
  static Future<void> insertUser(Usuario usuario) async {
    // Get a reference to the database.
    Database database = await _openDB();
    // In this case, replace any previous data.
    await database.insert('usuario', usuario.toMap());
  }

  // Obtiene todos los usuarios
  static Future<List<Usuario>> usuariosAll() async {
    // Get a reference to the database.
    Database database = await _openDB();
    final List<Map<String, dynamic>> usuarioMap =
        await database.query('usuario'); 
    
    return List.generate(usuarioMap.length, (i) {
      return Usuario(
        id: usuarioMap[i]['id'],
        usuario: usuarioMap[i]['usuario'],
        password: usuarioMap[i]['password'],
        nit: usuarioMap[i]['nit'],
        id_tipo_doc_pe: usuarioMap[i]['id_tipo_doc_pe'],
        id_tipo_doc_rc: usuarioMap[i]['id_tipo_doc_rc'],
      );
    });
  }
  //GET THE NO:OF NOTES

  /// Simple query with sqflite helper
  static Future getLogin(String usuario, String password) async {
    print("entra a validar el usuario a la BD");
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM usuario WHERE usuario = '$usuario' and password = '$password'");
    print("resultado de sql $res[0]['nit']");
    if(res.length>0){
      return res;
    }else{
      return null;
    }
  }
  
  static Future<void> deleteDataUsuario( ) async {
    print("se borran todos los usuarios");
    Database database = await _openDB();
    await database.rawDelete('DELETE FROM usuario');
  }

  //seccion de tercero cliente con 

  static Future getClient(String nit) async {
    print("entra a validar el usuario a la BD");
    Database database = await _openDB();
    final res = await database.rawQuery(
      "  SELECT tercero.id_tercero,tercero.id_sucursal_tercero, usuario,id_tipo_identificacion,tercero.dv,tercero.telefono,ciudad.nombre AS ciudad,tercero.direccion,"
       "  CONCAT(tercero.primer_nombre,' ',primer_apellido) AS nombre_completo ,"
      " nombre_sucursal,e_mail,tercero.nit,limite_credito,tercero.id_forma_pago,tipo_pago.descripcion as forma_pago,"
  "   tercero_cliente.id_precio_item as lista_precio,id_suc_vendedor,id_empresa"
   "  FROM tercero JOIN ciudad ON tercero.id_ciudad=ciudad.id_ciudad AND tercero.nit=ciudad.nit"
   " JOIN tercero_cliente ON tercero_cliente.id_tercero=tercero.id_tercero AND tercero.nit=tercero_cliente.nit"
  "  JOIN tipo_pago ON tipo_pago.id_tipo_pago=tercero.id_forma_pago AND tercero.nit=tipo_pago.nit "
    "JOIN empresa ON empresa.nit=tercero.nit"
  "  WHERE tercero.nit ='$nit'"
    "ORDER BY nombre_completo ASC "  );

    print("resultado de busqueda de cliente $res ");
    if(res.length>0){
      return res;
    }else{
      return null;
    }
  }

  static Future<void> insertCliente( Cliente cliente ) async {
    print("INSERTA a validar el usuario a la BD $cliente");
    Database database = await _openDB(); 

   int id1 =  await database.rawInsert( "INSERT INTO public.tercero("
           " id_tercero,id_sucursal_tercero,id_tipo_identificacion, dv, nombre, direccion, id_pais, id_depto,"
           " id_ciudad, id_barrio, telefono,cliente,fecha_creacion,nombre_sucursal,"
           "  primer_apellido, segundo_apellido, primer_nombre, segundo_nombre,e_mail,nit,id_tipo_empresa)"
      "   VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},${cliente.id_tipo_identificacion}, ${cliente.dv},${cliente.nombre}, ${cliente.direccion},${cliente.id_pais}, ${cliente.id_depto},"
      "   ${cliente.id_ciudad}, ${cliente.id_barrio}, ${cliente.telefono}, 'SI', NOW(), ${cliente.nombre_sucursal},"
      "   ${cliente.primer_apellido}, ${cliente.segundo_apellido}, ${cliente.primer_nombre},${cliente.segundo_nombre},   'SI', 'ACTIVO',${cliente.e_mail},${cliente.nit},${cliente.id_tipo_empresa})");
      print("insert de tercero $id1");

        int id2 =  await database.rawInsert( "INSERT INTO public.tercero_cliente("
        " id_tercero, id_sucursal_tercero,id_forma_pago,id_precio_item ,id_vendedor,id_suc_vendedor,id_medio_contacto, id_zona, nit)"                   
      "   VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},${cliente.id_forma_pago}, ${cliente.id_precio_item},${cliente.id_vendedor}, ${cliente.id_suc_vendedor},"
      "   ${cliente.id_medio_contacto}, ${cliente.id_zona}, ${cliente.nit}, 'SI', NOW(), ${cliente.nombre_sucursal})");
      print("insert de tercero $id2");

        int id3 =  await database.rawInsert( "INSERT INTO public.tercero_direccion("
            "id_tercero, id_sucursal_tercero, id_direccion, direccion, telefono, id_pais, id_ciudad, id_depto, tipo_direccion, nit)"
      "   VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'1', ${cliente.direccion},${cliente.telefono}, ${cliente.id_pais},${cliente.id_ciudad}, ${cliente.id_depto},"
      "   'Factura', ${cliente.nit})");
      print("insert de tercero direccion$id3");
      
        int id4 =  await database.rawInsert( "INSERT INTO public.tercero_direccion("
            "id_tercero, id_sucursal_tercero, id_direccion, direccion, telefono, id_pais, id_ciudad, id_depto, tipo_direccion, nit)"
      "   VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'2', ${cliente.direccion},${cliente.telefono}, ${cliente.id_pais},${cliente.id_ciudad}, ${cliente.id_depto},"
      "   'Mercancia', ${cliente.nit})");
      print("insert de tercero direccion$id4");
 
  }
///fin de seccion tercero cliente
 
////// inicio seccion de cuota de venta 
 
  //insertar las cuotas de venta
  static Future<void> insertCuotaVenta(Sale sale) async { 
    Database database = await _openDB(); 
    await database.insert('cuota_venta', sale.toMap());
  }

  // Obtiene todos las cuota venta
  static Future<List<Sale>> cuotaventaAll() async {
    // Get a reference to the database.
    Database database = await _openDB();
    final List<Map<String, dynamic>> cuotaMap =
        await database.query('cuota_venta'); 
    
    return List.generate(cuotaMap.length, (i) {
      return Sale(        
        venta: cuotaMap[i]['venta'],
        cuota: cuotaMap[i]['cuota'],
        id_linea: cuotaMap[i]['id_linea'],
        nombre: cuotaMap[i]['nombre'],
        nit: cuotaMap[i]['nit'],
        id_vendedor: cuotaMap[i]['id_vendedor'],
        id_suc_vendedor: cuotaMap[i]['id_suc_vendedor'],
      );
    });
  }  
 
  static Future<void> deleteCuota() async {
    print("se borran todos datos de cuota");
    Database database = await _openDB();
    await database.rawDelete('DELETE  FROM cuota_venta');
  }
/// fin cuota de venta 

}
