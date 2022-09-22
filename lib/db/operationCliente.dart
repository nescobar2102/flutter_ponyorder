import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cliente.dart';

class OperationCliente {

  static Future<Database> _openDB() async {
    var sql = "CREATE TABLE IF NOT EXISTS tercero  (id_tercero TEXT,  id_sucursal_tercero INTEGER,"
        "id_tipo_identificacion TEXT,dv TEXT , nombre TEXT,direccion TEXT,id_pais TEXT,id_depto TEXT,id_ciudad TEXT,"
        "id_barrio TEXT,telefono TEXT,id_actividad TEXT,id_tipo_empresa TEXT,cliente TEXT,fecha_creacion TEXT,"
        "nombre_sucursal TEXT,primer_apellido TEXT,segundo_apellido TEXT, primer_nombre TEXT,segundo_nombre TEXT,"
        "flag_persona_nat TEXT, estado_tercero TEXT,vendedor TEXT,id_lista_precio TEXT,id_forma_pago TEXT,usuario TEXT,"
        "flag_enviado TEXT,e_mail TEXT,telefono_celular TEXT,e_mail_fe TEXT,nit TEXT);"
        "CREATE TABLE IF NOT EXISTS  tercero_cliente( id_tercero TEXT,   id_sucursal_tercero INTEGER  ,   id_forma_pago TEXT,"
          "id_precio_item TEXT,  id_vendedor TEXT,   id_suc_vendedor INTEGER, id_medio_contacto TEXT, id_zona character TEXT,"
          "flag_exento_iva TEXT,  dia_cierre INTEGER,    id_impuesto_reteiva TEXT,  id_agente_reteiva TEXT,id_impuesto_reteica TEXT,"
              " id_agente_reteica TEXT,  id_impuesto_retefuente TEXT, id_agente_retefuente TEXT,  id_agente_retecree TEXT,"
          "id_impuesto_retecree TEXT,  id_tamanno INTEGER,  limite_credito TEXT,  dias_gracia TEXT,flag_cartera_vencida  TEXT,"
          "dcto_cliente TEXT, dcto_adicional TEXT, numero_facturas_vencidas TEXT,  nit TEXT);"
        "CREATE TABLE IF NOT EXISTS tercero_direccion(   id_tercero TEXT,  id_sucursal_tercero INTEGER,   id_direccion  TEXT, direccion TEXT,"
          "telefono  TEXT,  id_pais  TEXT,  id_ciudad  TEXT,  id_depto TEXT,  tipo_direccion  TEXT,nit TEXT);";

         return  openDatabase(join(await getDatabasesPath(),'pony.db'),onCreate: (db,version){
           return db.execute(sql);
      });
  }



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
}
