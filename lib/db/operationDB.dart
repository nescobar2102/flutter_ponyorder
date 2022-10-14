import 'package:sqflite/sqflite.dart';
 import 'package:path/path.dart';

import '../models/usuario.dart';
import '../models/cliente.dart';
import '../models/sale.dart';
import '../models/units.dart';
import '../models/tercero.dart';
import '../models/tercero_cliente.dart';
import '../models/tercero_direccion.dart';
import '../models/tipo_pago.dart';
import '../models/empresa.dart';
import '../models/ciudad.dart';
import '../models/tipo_doc.dart'; 
import '../models/factura.dart'; 
import '../models/clasificacion_item.dart'; 
import '../models/precio_item.dart'; 
import '../models/zona.dart'; 
import '../models/medio_contacto.dart'; 
import '../models/pedido.dart'; 

 import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqlite_api.dart';


class OperationDB {
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _openDB();
  }

  static Future<Database> _openDB() async {
     var databasesPath = await getDatabasesPath();
     String path = join(databasesPath, "demo_asset_example.db");
  // await deleteDatabase(path);
   // print("path $path");
    const tableUsuario = """
            CREATE TABLE IF NOT EXISTS usuario(id INTEGER PRIMARY KEY, usuario TEXT, password TEXT,nit TEXT,id_tipo_doc_pe TEXT,id_tipo_doc_rc TEXT)
      ;""";
    const tableCuotaVenta = """
            CREATE TABLE IF NOT EXISTS  cuota_venta( id INTEGER PRIMARY KEY AUTOINCREMENT, venta TEXT, cuota TEXT, id_linea TEXT, nombre TEXT, nit TEXT,id_vendedor TEXT,id_suc_vendedor INTEGER)
      ;""";
    const tableBanco = """
          CREATE TABLE IF NOT EXISTS banco( id_banco TEXT NOT NULL, descripcion TEXT, nit TEXT NOT NULL)
     ;""";
    const tableBarrio = """
        CREATE TABLE IF NOT EXISTS barrio
              (
                  id_pais TEXT NOT NULL,
                  id_depto TEXT NOT NULL,
                  id_ciudad  TEXT NOT NULL,
                  id_barrio TEXT NOT NULL,
                  nombre TEXT,
                  nit TEXT NOT NULL
              )
     ;""";
    const tableCiudad = """       
          CREATE TABLE IF NOT EXISTS  ciudad
          (
              id_pais TEXT NOT NULL,
              id_depto TEXT NOT NULL,
              id_ciudad TEXT NOT NULL,
              nombre TEXT,
              nit TEXT NOT NULL 
          )
      ;""";
    const tableclasificacion_item = """   
          CREATE TABLE IF NOT EXISTS clasificacion_item
          (
              id_clasificacion TEXT NOT NULL,
              descripcion TEXT,
              id_padre TEXT,
              nivel integer,
              es_padre TEXT,
              nit TEXT NOT NULL,
              foto TEXT ,
              imagen TEXT   
          )
      ;""";
    const tableConceptos = """   
         CREATE TABLE IF NOT EXISTS conceptos
              (
                  id_concepto TEXT NOT NULL,
                  descripcion TEXT,
                  naturalezacta TEXT,
                  nit TEXT NOT NULL,
                  id_auxiliar TEXT 
              )
      ;""";
    const tablecuentas_por_tercero = """   
       CREATE TABLE IF NOT EXISTS  cuentas_por_tercero
        (
            id_empresa  TEXT NOT NULL,
            id_sucursal TEXT NOT NULL,
            tipo_doc TEXT NOT NULL,
            numero integer NOT NULL,
            cuota integer ,
            dias integer,
            id_tercero TEXT NOT NULL,
            id_vendedor TEXT NOT NULL,
            id_sucursal_tercero integer NOT NULL,
            fecha TEXT,
            vencimiento TEXT,
            credito TEXT,
            dctomax TEXT,
            debito TEXT,
            id_destino TEXT,
            id_proyecto TEXT,
            nit TEXT  NOT NULL,
            id_empresa_cruce TEXT,
            id_sucursal_cruce TEXT,
            tipo_doc_cruce TEXT,
            numero_cruce integer,
            cuota_cruce integer 
        )
      ;""";

    const tableDepto = """   
           CREATE TABLE IF NOT EXISTS  depto
        (
          id_pais TEXT NOT NULL,
          id_depto TEXT NOT NULL,
          nombre TEXT,
          nit TEXT NOT NULL 
      )
            ;""";
                const tableEmpresa = """   
          CREATE TABLE IF NOT EXISTS empresa
          (
              nit TEXT NOT NULL,
              razon_social TEXT NOT NULL,
              id_tipo_empresa TEXT NOT NULL,
              pre_actividad_economica TEXT NOT NULL,
              pre_cuenta TEXT NOT NULL,
              pre_medio_contacto TEXT NOT NULL,
              id_moneda TEXT NOT NULL,
              direccion TEXT NOT NULL,
              telefono TEXT NOT NULL,
              dv TEXT NOT NULL,
              fax TEXT NOT NULL,
              id_pais TEXT NOT NULL,
              id_depto TEXT NOT NULL,
              id_ciudad TEXT NOT NULL,
              regimen_tributario TEXT NOT NULL,
              flag_iva TEXT NOT NULL,
              flag_forma_pago_efectivo TEXT NOT NULL,
              correo_electronico TEXT NOT NULL,
              id_empresa TEXT NOT NULL,
              estado TEXT NOT NULL
          )  ;""";

    const tableFactura = """   
          CREATE TABLE IF NOT EXISTS factura
        (   
              id_tercero TEXT,
              numero TEXT,
              fecha TEXT,
              total_fac TEXT,
              id_item TEXT,
              descripcion_item TEXT,
              precio TEXT,
              cantidad TEXT,
              total TEXT 
        )
            ;""";

    const tableFacturaDet = """   
     CREATE TABLE IF NOT EXISTS factura_det
      (
          numero TEXT,
          id_item TEXT,
          descripcion_item TEXT,
          precio TEXT,
          id_empresa TEXT,
          id_sucursal integer,
          id_tipo_doc TEXT,
          cantidad TEXT
      ) 
   ;""";

    const tableFormaPago = """   
   CREATE TABLE IF NOT EXISTS forma_pago
      (
          id_forma_pago TEXT NOT NULL,
          descripcion TEXT,
          id_precio_item TEXT,
          nit TEXT NOT NULL 
      )
   ;""";

    const tableItem = """   
    CREATE TABLE IF NOT EXISTS item
    (
        id_item TEXT NOT NULL,
        descripcion TEXT,
        referencia TEXT,
        id_impuesto TEXT,
        tipo_impuesto TEXT,
        dcto_producto TEXT,
        dcto_maximo TEXT,
        flag_facturable TEXT,
        flag_serial TEXT,
        flag_kit TEXT,
        id_clasificacion TEXT,
        id_padre_clasificacion TEXT,
        id_unidad_compra TEXT,
        exento_impuesto TEXT,
        flag_existencia TEXT,
        flag_dcto_volumen  TEXT,
        nit TEXT NOT NULL,
        saldo_inventario TEXT  
    ) 
   ;""";

    const tableItemDcto = """   
    CREATE TABLE IF NOT EXISTS item_dcto
    (
        id_item  TEXT  NOT NULL,
        consecutivo integer NOT NULL,
        cantidad_inicial TEXT ,
        cantidad_final  TEXT ,
        tasa_dcto  TEXT ,
        ultima_actualizacion  TEXT ,
        nit TEXT NOT NULL
      )
   ;""";
    const tableMedioContacto = """   
   CREATE TABLE IF NOT EXISTS medio_contacto
    (
        id_medio_contacto TEXT NOT NULL,
        descripcion TEXT,
        nit TEXT NOT NULL  
    )
   ;""";
    const tablePais = """   
     CREATE TABLE IF NOT EXISTS pais
(
    id_pais TEXT NOT NULL,
    nombre TEXT,
    ie_pais TEXT,
    nacionalidad TEXT,
    nit TEXT NOT NULL 
)
   ;""";

    const tablePedido = """  
CREATE TABLE IF NOT EXISTS  pedido
(
    id_empresa TEXT NOT NULL,
    id_sucursal TEXT NOT NULL,
    id_tipo_doc TEXT NOT NULL,
    numero integer NOT NULL,
    id_tercero  TEXT,
    id_sucursal_tercero integer  ,
    id_vendedor  TEXT,
    id_suc_vendedor integer ,
    fecha  TEXT,
    vencimiento TEXT,
    fecha_entrega TEXT,
    fecha_trm  TEXT,
    id_forma_pago  TEXT,
    id_precio_item  TEXT,
    id_direccion TEXT,
    id_moneda TEXT,
    trm  TEXT,
    subtotal  TEXT,
    total_costo  TEXT,
    total_iva TEXT,
    total_dcto  TEXT,
    total  TEXT,
    total_item  TEXT,
    orden_compra  TEXT,
    estado  TEXT,
    flag_autorizado  TEXT,
    comentario  TEXT,
    observacion  TEXT,
    letras  TEXT,
    id_direccion_factura TEXT,
    usuario TEXT,
    id_tiempo_entrega integer,
    flag_enviado TEXT,
    nit TEXT NOT NULL    
)
   ;""";

    const tablePedidoDet = """  
CREATE TABLE IF NOT EXISTS  pedido_det
(
    id_empresa TEXT NOT NULL,
    id_sucursal TEXT NOT NULL,
    id_tipo_doc TEXT NOT NULL,
    numero integer NOT NULL,
    consecutivo integer NOT NULL,
    id_item TEXT NOT NULL,
    descripcion_item TEXT,
    id_bodega TEXT,
    cantidad TEXT,
    precio TEXT,
    precio_lista TEXT,
    tasa_iva TEXT,
    total_iva TEXT,
    tasa_dcto_fijo TEXT,
    total_dcto_fijo TEXT,
    total_dcto TEXT,
    costo TEXT,
    subtotal TEXT,
    total TEXT,
    total_item TEXT,
    id_unidad TEXT,
    cantidad_kit TEXT,
    cantidad_de_kit TEXT,
    recno integer  ,
    id_precio_item  TEXT,
    factor TEXT,
    id_impuesto_iva TEXT,
    total_dcto_adicional TEXT,
    tasa_dcto_adicional  TEXT,
    id_kit TEXT,
    precio_kit TEXT,
    tasa_dcto_cliente integer ,
    total_dcto_cliente integer ,
    nit  TEXT NOT NULL 
)   ;""";

    const tablePrecioItem = """  
CREATE TABLE IF NOT EXISTS  precio_item
(
    id_precio_item  TEXT NOT NULL,
    descripcion  TEXT,
    vigencia_desde TEXT,
    vigencia_hasta  TEXT,
    id_margen_item  TEXT,
    id_moneda TEXT,
    flag_iva_incluido  TEXT,
    flag_lista_base  TEXT,
    nit TEXT NOT NULL    
) ;""";

    const tablePrecioItemDet = """  
CREATE TABLE IF NOT EXISTS precio_item_det
(
    precio TEXT,
    id_precio_item TEXT NOT NULL,
    id_item TEXT NOT NULL,
    descuento_maximo TEXT ,
    id_talla TEXT NOT NULL,
    id_moneda TEXT ,
    id_unidad_compra TEXT NOT NULL,
    nit TEXT NOT NULL 
) ;""";

    const tableTercero = """  
CREATE TABLE IF NOT EXISTS  tercero
(
    id_tercero TEXT NOT NULL,
    id_sucursal_tercero integer NOT NULL,
    id_tipo_identificacion TEXT NOT NULL,
    dv TEXT,
    nombre TEXT,
    direccion TEXT,
    id_pais TEXT  NOT NULL,
    id_depto TEXT  NOT NULL,
    id_ciudad TEXT  NOT NULL,
    id_barrio TEXT  NOT NULL,
    telefono TEXT  NOT NULL, 
    id_actividad TEXT , 
    id_tipo_empresa TEXT  NOT NULL,
    cliente TEXT DEFAULT 'SI',
    fecha_creacion TEXT  ,
    nombre_sucursal  TEXT  ,
    primer_apellido  TEXT  ,
    segundo_apellido  TEXT  ,
    primer_nombre TEXT  ,
    segundo_nombre TEXT  ,
    flag_persona_nat  TEXT  ,
    estado_tercero  TEXT  ,
    vendedor  TEXT  ,
    id_lista_precio  TEXT  ,
    id_forma_pago  TEXT  ,
    usuario  TEXT  ,
  	flag_enviado	TEXT DEFAULT 'NO',
    e_mail  TEXT  ,
    telefono_celular TEXT  ,
    e_mail_fe  TEXT  ,
    nit  TEXT  NOT NULL,
    PRIMARY KEY("id_tercero")
) ;""";

    const tableTerceroCliente = """  
CREATE TABLE IF NOT EXISTS  tercero_cliente
(
    id_tercero TEXT NOT NULL,
    id_sucursal_tercero integer NOT NULL,
    id_forma_pago TEXT NOT NULL,
    id_precio_item TEXT NOT NULL,
    id_vendedor TEXT NOT NULL,
    id_suc_vendedor integer NOT NULL,
    id_medio_contacto TEXT  ,
    id_zona TEXT ,
    flag_exento_iva TEXT  L,
    dia_cierre integer,
    id_impuesto_reteiva TEXT  ,
    id_agente_reteiva TEXT  ,
    id_impuesto_reteica TEXT  ,
    id_agente_reteica TEXT  ,
    id_impuesto_retefuente TEXT  ,
    id_agente_retefuente TEXT  ,
    id_agente_retecree TEXT  ,
    id_impuesto_retecree TEXT  ,
    id_tamanno integer,
    limite_credito TEXT  ,
    dias_gracia TEXT  ,
    flag_cartera_vencida TEXT  ,
    dcto_cliente TEXT  ,
    dcto_adicional TEXT  ,
    numero_facturas_vencidas TEXT  ,
    nit TEXT NOT NULL 
) ;""";

    const tableTerceroDireccion = """  
CREATE TABLE IF NOT EXISTS tercero_direccion
(
    id_tercero TEXT NOT NULL,
    id_sucursal_tercero integer NOT NULL,
    id_direccion TEXT NOT NULL,
    direccion TEXT,
    telefono  TEXT,
    id_pais  TEXT,
    id_ciudad  TEXT,
    id_depto  TEXT,
    tipo_direccion  TEXT,
    nit TEXT NOT NULL 
) ;""";
    const tableTipoDoc = """  
CREATE TABLE IF NOT EXISTS  tipo_doc
(
    id_empresa TEXT NOT NULL,
    id_sucursal TEXT NOT NULL,
    id_clase_doc TEXT,
    id_tipo_doc TEXT NOT NULL,
    consecutivo integer NOT NULL,
    descripcion TEXT,
    nit TEXT NOT NULL 
) ;""";
    const tableTipoEmpresa = """  
CREATE TABLE IF NOT EXISTS  tipo_empresa
(
    id_tipo_empresa TEXT NOT NULL,
    descripcion TEXT,
    nit TEXT NOT NULL    
) ;""";
    const tableTipoIdenti = """  
CREATE TABLE IF NOT EXISTS tipo_identificacion
(
    id_tipo_identificacion TEXT NOT NULL,
    descripcion TEXT 
) ;""";
    const tableTipoPago = """  
CREATE TABLE IF NOT EXISTS tipo_pago
(
    id_tipo_pago TEXT NOT NULL,
    descripcion TEXT,
    nit TEXT NOT NULL 
) ;""";
    const tableTipoPagoDet = """  
CREATE TABLE IF NOT EXISTS tipo_pagodet
(
    id_tipo_pago  TEXT NOT NULL,
    cuota integer NOT NULL,
    dias integer ,
    tasa TEXT,
    nit  TEXT NOT NULL,
    id_auxiliar TEXT
) ;""";
    const tableZona = """  
CREATE TABLE IF NOT EXISTS zona
(
    id_zona TEXT NOT NULL,
    descripcion TEXT,
    id_padre TEXT,
    nivel integer,
    es_padre TEXT,
    nit TEXT NOT NULL 
) ;""";
    const tableKit = """
  CREATE TABLE IF NOT EXISTS kit
  (
      id_kit TEXT NOT NULL,
      descripcion TEXT,
      precio_kit TEXT,
      precio_kit_iva TEXT,
      flag_vigencia TEXT,
      fecha_inicial TEXT,
      fecha_final TEXT,
      ultima_actualizacion TEXT,
      nit TEXT NOT NULL   
  ) ;""";
    const tableKitDet = """
CREATE TABLE IF NOT EXISTS  kit_det
(
    id_kit TEXT NOT NULL,
    id_item  TEXT NOT NULL,
    id_bodega  TEXT ,
    cantidad  TEXT ,
    tasa_dcto TEXT ,
    precio TEXT ,
    valor_total TEXT ,
    tasa_iva TEXT ,
    valor_iva TEXT ,
    total TEXT ,
    ultima_actualizacion TEXT ,
    nit TEXT  NOT NULL 
);""";
    const tableCarteraProveedores = """
CREATE TABLE IF NOT EXISTS CARTERA_PROVEEDORES_DET
(
    id_empresa TEXT NOT NULL,
    id_sucursal TEXT NOT NULL,
    id_tipo_doc TEXT NOT NULL,
    numero integer NOT NULL,
    consecutivo integer NOT NULL,
    id_empresa_cruce TEXT ,
    id_sucursal_cruce TEXT,
    id_tipo_doc_cruce TEXT  ,
    numero_cruce integer,
    fecha TEXT,
    vencimiento TEXT,
    debito TEXT ,
    credito TEXT ,
    id_vendedor TEXT ,
    id_forma_pago TEXT ,
    documento_forma_pago TEXT ,
    id_sucursal_tercero integer ,
    id_tercero TEXT ,
    cuota TEXT ,
    distribucion TEXT ,
    descripcion TEXT ,
    trm TEXT ,
    id_recaudador TEXT ,
    id_suc_recaudador integer,
    fecha_trm TEXT ,
    total_factura TEXT ,
    id_concepto TEXT ,
    id_moneda TEXT ,
    id_destino TEXT ,
    id_proyecto TEXT ,
    cuota_cruce integer,
    id_banco TEXT ,
    nit TEXT  NOT NULL  
);""";

    const viewCartera = """
 CREATE VIEW SALDO_CARTERA AS 
SELECT CT.ID_EMPRESA,
CT.ID_SUCURSAL,
CT.TIPO_DOC,
CT.NUMERO,
CT.CUOTA,
--CAST (round(julianday( (date(( NOW) ), 'localtime') ) -(round(julianday(CT.VENCIMIENTO, '+' || TC.DIAS_GRACIA, || ' days', 'localtime') ) )  ) as DIAS_VENCIDOS,
--CAST (round(julianday( (date((NOW) ), 'localtime') ) -(round(julianday(CT.VENCIMIENTO, 'localtime') ) )  )  as DIAS,
CT.ID_TERCERO,
CT.ID_VENDEDOR,
CT.ID_SUCURSAL_TERCERO,
CT.FECHA,
TC.DIAS_GRACIA,
CT.VENCIMIENTO,
CT.CREDITO,
--CT.ID_AUXILIAR,
CT.DCTOMAX,
CT.DEBITO,
CT.ID_DESTINO,
CT.ID_PROYECTO
FROM CUENTAS_POR_TERCERO CT
INNER JOIN
TERCERO_CLIENTE TC ON (CT.ID_TERCERO = TC.ID_TERCERO AND
CT.ID_SUCURSAL_TERCERO = TC.ID_SUCURSAL_TERCERO)
GROUP BY CT.ID_EMPRESA,
CT.ID_SUCURSAL,
CT.TIPO_DOC,
CT.NUMERO,
CT.CUOTA,
CT.ID_TERCERO,
CT.ID_VENDEDOR,
CT.ID_SUCURSAL_TERCERO,
CT.FECHA,
TC.DIAS_GRACIA,
CT.VENCIMIENTO,
--CT.ID_AUXILIAR,
CT.DCTOMAX,
CT.CUOTA_CRUCE,
CT.ID_DESTINO,
CT.ID_PROYECTO
HAVING SUM(CT.DEBITO) < -0.01 OR
SUM(CT.DEBITO) > 0.01
UNION ALL
SELECT C.ID_EMPRESA,
C.ID_SUCURSAL,
C.ID_TIPO_DOC_CRUCE,
C.NUMERO_CRUCE,
C.CUOTA_CRUCE,
--CAST (round(julianday( (date((NOW) ), 'localtime') ) -(round(julianday(C.VENCIMIENTO, '+'  || TC.DIAS_GRACIA, || 'days', 'localtime') ) ) ) as  DIAS_VENCIDOS,
--CAST (round(julianday( (date((NOW) ), 'localtime') ) -(round(julianday(C.VENCIMIENTO, 'localtime') ) )  ) as  DIAS,
C.ID_TERCERO,
C.ID_VENDEDOR,
C.ID_SUCURSAL_TERCERO,
C.FECHA,
TC.DIAS_GRACIA,
C.VENCIMIENTO,
C.CREDITO,
--C.ID_AUXILIAR,
0,
C.DEBITO,
C.ID_DESTINO,
C.ID_PROYECTO
FROM CARTERA_PROVEEDORES_DET C
INNER JOIN
TERCERO_CLIENTE TC ON (C.ID_TERCERO = TC.ID_TERCERO AND
C.ID_SUCURSAL_TERCERO = TC.ID_SUCURSAL_TERCERO)
WHERE C.DISTRIBUCION = 'DC';""";


    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute(tableUsuario);
      await db.execute(tableCuotaVenta);
      await db.execute(tableBanco);
      await db.execute(tableBarrio);
      await db.execute(tableCiudad);
      await db.execute(tableclasificacion_item);
      await db.execute(tableConceptos);
      await db.execute(tablecuentas_por_tercero);
      await db.execute(tableDepto);
      await db.execute(tableEmpresa);
      await db.execute(tableFactura);
      await db.execute(tableFacturaDet);
      await db.execute(tableFormaPago);
      await db.execute(tableItem);
      await db.execute(tableItemDcto);
      await db.execute(tableMedioContacto);
      await db.execute(tablePais);
      await db.execute(tablePedido);
      await db.execute(tablePedidoDet);
      await db.execute(tablePrecioItem);
      await db.execute(tablePrecioItemDet);
      await db.execute(tableTercero);
      await db.execute(tableTerceroCliente);
      await db.execute(tableTerceroDireccion);
      await db.execute(tableTipoDoc);
      await db.execute(tableTipoEmpresa);
      await db.execute(tableTipoIdenti);
      await db.execute(tableTipoPago);
      await db.execute(tableTipoPagoDet);
      await db.execute(tableZona);
      await db.execute(tableKit);
      await db.execute(tableKitDet);
      await db.execute(tableCarteraProveedores);
       await db.execute(viewCartera);
      print("crearon tablas");
    }, version: 2);
  }

  //insertar los usuarios
  static Future<void> insertUser(Usuario usuario) async {
    Database database = await _openDB();
    await database.insert('usuario', usuario.toMap());
  }

  // Obtiene todos los usuarios
  static Future<List<Usuario>> usuariosAll() async {
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
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM usuario WHERE usuario = '$usuario' and password = '$password'");
    print("resultado de sql $res[0]['nit']");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }

  static Future<void> deleteDataUsuario() async {
    Database database = await _openDB();
    await database.rawDelete('DELETE FROM usuario');
  }

  //seccion de tercero cliente
  static Future getClient(String nit) async {
    print("entra a validar getClient  BD");
    Database database = await _openDB(); 

        final res = await database.rawQuery(
        "  SELECT tercero.id_tercero,tercero.id_sucursal_tercero, usuario,id_tipo_identificacion,tercero.dv,tercero.telefono,ciudad.nombre AS ciudad,tercero.direccion,"
        " tercero.primer_nombre || ' ' || primer_apellido AS nombre_completo ,"
        " nombre_sucursal,e_mail,tercero.nit,limite_credito,tercero.id_forma_pago, "
        "  id_suc_vendedor,id_empresa, tercero_cliente.id_precio_item as lista_precio "
        " FROM tercero JOIN tercero_cliente ON tercero_cliente.id_tercero=tercero.id_tercero AND tercero.nit=tercero_cliente.nit "
        " JOIN ciudad ON tercero.id_ciudad=ciudad.id_ciudad AND tercero.nit=ciudad.nit"
        " JOIN empresa ON empresa.nit=tercero.nit"
        " WHERE tercero.nit ='$nit'"
        " ORDER BY 1 ASC ");  
         
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  static Future insertCliente(Cliente cliente) async {
    print("INSERTA a validar el usuario a la BD $cliente");
    Database database = await _openDB();

    var flag = await validaInsertCliente(cliente.id_tercero);
    if (flag){
      final res = await database
          .rawQuery(" select id_tipo_empresa from empresa where  nit ='${cliente.nit}'  ");
      var id_tipo_empresa = res[0]['id_tipo_empresa'].toString();

            int id1 = await database.rawInsert("INSERT INTO tercero("
                " id_tercero,id_sucursal_tercero,id_tipo_identificacion, dv, nombre, direccion, id_pais, id_depto,id_forma_pago,id_lista_precio,"
                " id_ciudad, id_barrio, telefono,fecha_creacion,nombre_sucursal,"
                " primer_apellido, segundo_apellido, primer_nombre, segundo_nombre,flag_persona_nat,estado_tercero,e_mail,nit,id_tipo_empresa)"
                " VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},${cliente.id_tipo_identificacion}, ${cliente.dv},'${cliente.nombre}','${cliente.direccion}',${cliente.id_pais}, ${cliente.id_depto},'${cliente.id_forma_pago}','${cliente.id_lista_precio}',"
                " ${cliente.id_ciudad}, ${cliente.id_barrio}, ${cliente.telefono}, '${cliente.fecha_creacion}', '${cliente.nombre_sucursal}',"
                " '${cliente.primer_apellido}', '${cliente.segundo_apellido}', '${cliente.primer_nombre}','${cliente.segundo_nombre}', '${cliente.flag_persona_nat}', 'ACTIVO','${cliente.e_mail}',${cliente.nit},'${id_tipo_empresa}')");

            int id2 = await database.rawInsert("INSERT INTO tercero_cliente("
                " id_tercero, id_sucursal_tercero,id_forma_pago,id_precio_item ,id_vendedor,id_suc_vendedor,id_medio_contacto, id_zona,nit,limite_credito )"
                "  VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'${cliente.id_forma_pago}', ${cliente.id_precio_item},${cliente.id_vendedor}, ${cliente.id_suc_vendedor},"
                "  ${cliente.id_medio_contacto},'${cliente.id_zona}', '${cliente.nit}', '0')");
            print("insert de tercero_cliente $id2");

            int id3 = await database.rawInsert("INSERT INTO tercero_direccion("
                " id_tercero, id_sucursal_tercero, id_direccion, direccion, telefono, id_pais, id_ciudad, id_depto, tipo_direccion, nit)"
                " VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'1', '${cliente.direccion}',${cliente.telefono}, ${cliente.id_pais},${cliente.id_ciudad}, ${cliente.id_depto},"
                " 'Factura', ${cliente.nit})");
            print("insert de tercero direccion$id3");

            int id4 = await database.rawInsert("INSERT INTO tercero_direccion("
                "id_tercero, id_sucursal_tercero, id_direccion, direccion, telefono, id_pais, id_ciudad, id_depto, tipo_direccion, nit)"
                "   VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'2', '${cliente.direccion}',${cliente.telefono}, ${cliente.id_pais},${cliente.id_ciudad}, ${cliente.id_depto},"
                "   'Mercancia', ${cliente.nit})");
            print("insert de tercero direccion$id4");  
          }

  }

  //insertar los tercero que viene de la api
  static Future<bool> validaInsertCliente(String tercero) async {
    var flag = false;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM tercero WHERE id_tercero = '$tercero' ");
    print("resultado de sql $res ");
    if (res.length == 0 ) {    
      flag = true;        
    }  
      final res1 = await database
        .rawQuery("SELECT * FROM tercero_cliente WHERE id_tercero = '$tercero' ");  
    if (res1.length == 0 ) {   
      flag = true;        
    }  
       final res2 = await database
        .rawQuery("SELECT * FROM tercero_direccion WHERE id_tercero = '$tercero' ");
    if (res2.length == 0 ) {    
      flag = true;        
    }
  print("calidacion deasd falg $flag");
    return flag;
  }

  
  //insertar los tercero que viene de la api
  static Future<bool> updateCliente(String tercero,String nit) async {
    var flag = false;
    Database database = await _openDB();
      final res = await database
        .rawQuery(" UPDATE tercero SET   flag_enviado='SI' 	WHERE  id_tercero = '$tercero' and nit = '$nit'");
    print("resultado de sql upadte$res ");
    if (res.length == 0 ) {    
      flag = true;        
    }  
    
 
    return flag;
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
    Database database = await _openDB();
    await database.rawDelete('DELETE  FROM cuota_venta');
  }


  static Future getCBalance(
      String nit, String id_vendedor, String fecha) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select  sum (venta) as total_venta,sum(cuota ) as total_cuota,(sum (venta) *100 / sum(cuota) ) as balance_general,'MES' as tipo "
        " from cuota_venta  where id_vendedor='$id_vendedor' "
        " union "
        " select sum(total) as total_ventas_dia,0,0,'DIA_PEDIDO' as tipo "
        " from pedido where id_vendedor='$id_vendedor'  and nit='$nit'  and  fecha='$fecha' "
        " union "
        " select sum(credito) as total_ventas_dia, 0,0,'DIA_RECIBO'  as tipo "
        " from cuentas_por_tercero where id_vendedor='$id_vendedor'  and nit='$nit' and  fecha='$fecha' and nit = '$nit' and id_vendedor = '$id_vendedor'");

    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  /// Simple query with sqflite helper
  static Future getCuotaValue(String nit, String id_vendedor) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT venta, cuota,nombre, ( venta  *100 / cuota) as porcentaje  from cuota_venta WHERE nit = '$nit' and id_vendedor = '$id_vendedor'");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  /// fin cuota de venta
  //Units

  ///pedidos
  /// Simple query with sqflite helper
  static Future getFacturaId(String id_tercero) async {
    Database database = await _openDB();
    final res = await database
        .rawQuery(" select numero, fecha, total_fac ,id_item , descripcion_item , precio, cantidad,  total  from factura"
               " where id_tercero= '$id_tercero' order by  numero desc ");   
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  //insertar los tercero que viene de la api
  static Future<bool> insertTercero(Tercero tercero) async {
    var idTercero = tercero.id_tercero;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM tercero WHERE id_tercero = '$idTercero' ");
    print("resultado de sql $res ");
    if (res.length == 0) {    
       await database.insert('tercero', tercero.toMap());
       return true;
    } else{
      return false;
    }
  }

  //insertar los tercero que viene de la api
  static Future<bool>insertTerceroCliente(TerceroCliente tercerocliente) async {
     var idTercero = tercerocliente.id_tercero;
    Database database = await _openDB();
     final res = await database
        .rawQuery("SELECT * FROM tercero_cliente WHERE id_tercero = '$idTercero' ");
  
    if (res.length == 0) {    
     await database.insert('tercero_cliente', tercerocliente.toMap());
      return true;
    } else{
      return false;
    }    
  }

  //insertar los tercero que viene de la api
  static Future<bool> insertTerceroDireccion(
      TerceroDireccion tercerodireccion) async {
           var idTercero = tercerodireccion.id_tercero;
            var id_direccion = tercerodireccion.id_direccion;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM tercero_direccion WHERE id_tercero = '$idTercero' and id_direccion = '$id_direccion' ");
    print("resultado de sql $res ");
    if (res.length == 0) {    
      await database.insert('tercero_direccion', tercerodireccion.toMap());
      return true;
    } else{
      return false;
    }
  }

  /// Simple query with sqflite helper
  static Future getTercero() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*)  FROM tercero ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }

  /// Simple query with sqflite helper
  static Future getTerceroCliente() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM tercero_cliente ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }

  /// Simple query with sqflite helper
  static Future getTerceroDireccion() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*)  FROM tercero_direccion");   
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  //tipo de pagos de
    //insertar los tercero que viene de la api
  static Future<bool> insertTipoPago(TipoPago tipopago) async {
    var id_tipo_pago = tipopago.id_tipo_pago;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM tipo_pago WHERE id_tipo_pago = '$id_tipo_pago' "); 
    if (res.length == 0) {    
       await database.insert('tipo_pago', tipopago.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getTipoPago() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM tipo_pago ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }

   
  //insertar las empresa que viene de la api
  static Future<bool> insertEmpresa(Empresa empresa) async {
    var nit = empresa.nit;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM empresa WHERE nit = '$nit' "); 
    if (res.length == 0) {    
       await database.insert('empresa', empresa.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getEmpresa() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM empresa ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }

  
  //insertar las ciudad que viene de la api
  static Future<bool> insertCiudad(Ciudad ciudad) async {
    var id_ciudad = ciudad.id_ciudad;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM ciudad WHERE id_ciudad = '$id_ciudad' "); 
    if (res.length == 0) {    
       await database.insert('ciudad', ciudad.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getCiudad() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM ciudad ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
   static Future  getCiudadList(String nit,String id_depto ) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery(" SELECT id_ciudad as value, nombre as label from ciudad WHERE nit = '$nit' and  id_depto ='$id_depto' "); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }
 
  
  
  //insertar las zona> que viene de la api
  static Future<bool> insertZona(Zona zona) async {
    var id_zona = zona.id_zona;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM zona WHERE id_zona = '$id_zona' "); 
    if (res.length == 0) {    
       await database.insert('zona', zona.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getZona() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM zona ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
   static Future  getZonaList(String nit) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery(" select id_zona as value, descripcion as label  FROM zona WHERE nit = $nit "); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }

  
  
  //insertar las zona> que viene de la api
  static Future<bool> insertMedioContacto(MedioContacto medio_contacto) async {
    var id_medio_contacto = medio_contacto.id_medio_contacto;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM medio_contacto WHERE id_medio_contacto = '$id_medio_contacto' "); 
    if (res.length == 0) {    
       await database.insert('medio_contacto', medio_contacto.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getMedioContacto() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM medio_contacto");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
   static Future  getMedioContactoList(String nit) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery(" select id_medio_contacto as value, descripcion as label from medio_contacto WHERE nit = $nit "); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }
  
  
   
  static Future<bool> insertTipoIdentificacion(TipoIdentificacion tipoident) async {
    var id_tipo_identificacion = tipoident.id_tipo_identificacion;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM tipo_identificacion WHERE id_tipo_identificacion = '$id_tipo_identificacion' "); 
    if (res.length == 0) {    
       await database.insert('tipo_identificacion', tipoident.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getTipoIdentificacion() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM tipo_identificacion");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
   static Future  getTipoIdentificacionList() async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery(" select id_tipo_identificacion as value, descripcion as label from tipo_identificacion  ORDER BY descripcion ASC "); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }


  static Future<bool> insertTipoEmpresa(TipoEmpresa tipoempresa) async {
    var id_tipo_empresa = tipoempresa.id_tipo_empresa;
     var nit = tipoempresa.nit;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM tipo_empresa WHERE id_tipo_empresa = '$id_tipo_empresa' and nit = '$nit'"); 
    if (res.length == 0) {    
       await database.insert('tipo_empresa', tipoempresa.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getTipoEmpresa() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM tipo_empresa");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
   static Future  getTipoEmpresaList(String nit) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery(" select id_tipo_empresa value, descripcion as label from tipo_empresa  where nit='$nit'"); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }

  
  static Future<bool> insertBarrio(Barrio barrio) async {
    var id_barrio = barrio.id_barrio;
     var nit = barrio.nit;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM barrio WHERE id_barrio = '$id_barrio' and nit = '$nit'"); 
    if (res.length == 0) {    
       await database.insert('barrio', barrio.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getBarrio() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM barrio");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
   static Future  getBarrioList(String nit) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery(" select id_barrio as value, nombre as label FROM barrio  where nit='$nit'"); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }
  
  
  static Future<bool> insertDepto(Depto depto) async {
    var id_depto = depto.id_depto;
    var nit = depto.nit;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM depto WHERE id_depto = '$id_depto' and nit = '$nit'"); 
    if (res.length == 0) {    
       await database.insert('depto', depto.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getDepto() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM depto");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
   static Future  getDeptoList(String nit) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery(" select id_depto as value, nombre as label from depto where nit='$nit'"); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }

  //insertar las ciudad que viene de la api
  static Future<bool> insertTipoDoc(TipoDoc tipodoc) async {
    var empresa = tipodoc.id_empresa;
    var id_tipo_doc = tipodoc.id_tipo_doc;
    var nit = tipodoc.nit;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM tipo_doc WHERE id_empresa = '$empresa'  and id_tipo_doc = '$id_tipo_doc' and nit = '$nit'"); 
    if (res.length == 0) {    
       await database.insert('tipo_doc', tipodoc.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getTipoDoc() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM tipo_doc ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  //pantalla de pedido
  //insertar getConsecutivoTipoDoc
  static Future  getConsecutivoTipoDoc(String nit, String id_tipo_doc , String id_empresa) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT max(consecutivo) as consecutivo  from tipo_doc WHERE  nit = '$nit' and id_tipo_doc = '$id_tipo_doc' and id_empresa= '$id_empresa'"); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }
   static Future  getDireccion(String nit, String id_tercero ) async {  
    Database database = await _openDB();
      final res = await database
        .rawQuery("  SELECT  id_direccion  as value,direccion as label FROM tercero_direccion WHERE id_tercero= '$id_tercero' and  nit ='$nit' "); 
      if (res.length >0) {  
        return res;
      } else{
        return false;
      }
  }

  
  //insertar las factura que viene de la api
  static Future<bool> insertFactura(Factura factura) async {
    var numero = factura.numero;
    var id_item = factura.id_item;
    var id_tercero = factura.id_tercero;
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM factura WHERE numero = '$numero' and id_item = '$id_item' and id_tercero = '$id_tercero'"); 
    if (res.length == 0) {    
       await database.insert('factura', factura.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getFactura() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM factura ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }


  
  //insertar las factura que viene de la api
  static Future<bool> insertClasificacionItem(ClasificacionItems clasi) async {
    var id_clasificacion = clasi.id_clasificacion;
    var nit = clasi.nit; 
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM clasificacion_item WHERE id_clasificacion = '$id_clasificacion' and nit = '$nit' "); 
    if (res.length == 0) {    
       await database.insert('clasificacion_item', clasi.toMap());
       return true;
    } else{
      return false;
    }
  }  
  
  /// Simple query with sqflite helper
  static Future getClasificacionItem() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM clasificacion_item ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
  //insertar las factura que viene de la api
  static Future<bool> insertPrecioItem(PrecioItems precio) async {
    var id_precio_item = precio.id_precio_item;
    var nit = precio.nit; 
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM precio_item WHERE id_precio_item = '$id_precio_item' and nit = '$nit' "); 
    if (res.length == 0) {    
       await database.insert('precio_item', precio.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getPrecioItem() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM precio_item ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
  //insertar las factura que viene de la api
  static Future<bool> insertPrecioItemDet(PrecioItemsDet precio) async {
    var id_precio_item = precio.id_precio_item;
    var nit = precio.nit; 
     var id_item = precio.id_item; 
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM precio_item_det WHERE id_precio_item = '$id_precio_item' and nit = '$nit'  and id_item = '$id_item'"); 
    if (res.length == 0) {    
       await database.insert('precio_item_det', precio.toMap());
       return true;
    } else{
      return false;
    }
  }
  
  /// Simple query with sqflite helper
  static Future getPrecioItemDet() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM precio_item_det ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }

  
  //insertar las factura que viene de la api
  static Future<bool> inserItem(Items item) async {
   
    var nit = item.nit; 
     var id_item = item.id_item; 
    Database database = await _openDB();
      final res = await database
        .rawQuery("SELECT * FROM item WHERE id_item = '$id_item' and nit = '$nit' "); 
    if (res.length == 0) {    
       await database.insert('item', item.toMap());
       return true;
    } else{
      return false;
    }
  }
  /// Simple query with sqflite helper
  static Future deleteItem() async {
    Database database = await _openDB();
    final res = await database.rawQuery("DELETE FROM item ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  /// Simple query with sqflite helper
  static Future getItem() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM item ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }
  
  
  static Future<bool> insertPedido(Pedido pedido) async {
    var numero = pedido.numero;
    var id_empresa = pedido.id_empresa;
    var nit = pedido.nit;
    var id_sucursal = pedido.id_sucursal;
    var id_tipo_doc = pedido.id_tipo_doc;
    Database database = await _openDB();
      final res = await database    
        .rawQuery(" SELECT * FROM pedido WHERE id_empresa ='$id_empresa' and id_sucursal= '$id_sucursal' and id_tipo_doc ='$id_tipo_doc' and numero='$numero' and nit= '$nit'"); 
    if (res.length == 0) {    
       await database.insert('pedido', pedido.toMap());
       return true;
    } else{
      return false;
    }
  }
   
  static Future getPedido() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM pedido");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  } 
  static Future updateConsecutivo(int numero,String nit,String id_tipo_doc) async {
   var nuevo_conse =  numero + 1;
    Database database = await _openDB();
    final res = await database.rawQuery("UPDATE  tipo_doc SET consecutivo='$nuevo_conse'  WHERE id_tipo_doc='id_tipo_doc' AND nit='$nit' ");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  } 

 

    static Future<bool> insertPedidoDet(PedidoDet pedidodet) async {
    var numero = pedidodet.numero;
    var id_item = pedidodet.id_item;
    var nit = pedidodet.nit;
    var id_tipo_doc = pedidodet.id_tipo_doc;
    Database database = await _openDB();
      final res = await database    
        .rawQuery(" SELECT * FROM pedido_det WHERE id_item='$id_item' and  id_tipo_doc ='$id_tipo_doc' and numero='$numero' and nit= '$nit'");
    if (res.length == 0) {    
       await database.insert('pedido_det', pedidodet.toMap());
       return true;
    } else{
      return false;
    }
  }
  static Future getPedidoDetNum(numero) async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM pedido_det where numero = '$numero' ");
    if (res.length > 0) {
      print("existen pedido det $res");
      return res;
    } else {
      return null;
    }
  }
  static Future getPedidoDet() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM pedido_det");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }


  static Future getHistorialPedidos(idVendedor,fecha1,fecha2,search) async {
    Database database = await _openDB();

    var sql = "SELECT T.NOMBRE  as nombre , T.nombre_sucursal as nombre_sucursal ,P.ID_EMPRESA,P.ID_SUCURSAL,"
    "P.ID_TIPO_DOC,P.NUMERO,  STRFTIME('%d/%m/%Y ', P.FECHA)  AS fecha,  "
    "P.TOTAL,P.ESTADO,TD.DIRECCION  FROM PEDIDO P "
    "INNER JOIN TERCERO_DIRECCION TD ON (TD.ID_TERCERO = P.ID_TERCERO "
    "AND TD.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO "
    "AND TD.ID_DIRECCION = P.ID_DIRECCION) INNER JOIN TERCERO T ON (T.ID_TERCERO = P.ID_TERCERO "
    "AND T.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO) WHERE P.ID_VENDEDOR ='$idVendedor' "
        "AND  date(FECHA)  >= '$fecha1'  AND  date(FECHA)  <=  '$fecha2' ";
    if (search != '@') {
      if (!search.isNaN)  {
    sql += ' AND T.ID_TERCERO = "$search" OR P.NUMERO = "$search" ';
    } else {
    sql += ' AND T.NOMBRE ILIKE  "%$search%"  OR  T.NOMBRE_SUCURSAL ILIKE "%$search%" ';
    }
    }
    print("rel sql de historial de pedido $sql");
    final res = await database.rawQuery(sql);
    print("el resultado $res");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  static Future getHistorialPedidosDetalle(numero,nit) async {
    Database database = await _openDB();

    var sql = " SELECT id_item,descripcion_item,cantidad,precio,total FROM pedido_det"
               " where nit ='$nit' and numero = '$numero'";
    print("rel sql de historial de pedido det $sql");
    final res = await database.rawQuery(sql);
    print("el resultado $res");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  static Future getVisitados(idVendedor,fecha) async {
    Database database = await _openDB();

    var sql = "SELECT T.NOMBRE as nombre, T.nombre_sucursal as nombre_sucursal ,T.direccion ,T.telefono "
    "FROM PEDIDO P INNER JOIN TERCERO_DIRECCION TD ON (TD.ID_TERCERO =P.ID_TERCERO "
    "AND TD.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO AND TD.ID_DIRECCION = P.ID_DIRECCION) "
    "INNER JOIN TERCERO T ON (T.ID_TERCERO = P.ID_TERCERO AND  T.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO) "
    "WHERE P.ID_VENDEDOR = '$idVendedor' AND date(FECHA)  = '$fecha'  "
    "GROUP BY T.NOMBRE , T.nombre_sucursal ,T.direccion ,T.telefono";

    print("rel sql visitados $sql");
    final res = await database.rawQuery(sql);
    print("el resultado $res");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }
  //seccion de tercero cliente
  static Future getSaldoCartera(String id_tercero, String  id_sucursal_tercero) async {
 
    Database database = await _openDB();
     final res = await database.rawQuery(
        " SELECT SUM(CT.DEBITO - CT.CREDITO)  AS DEBITO   FROM SALDO_CARTERA AS CT " 
          "  WHERE CT.ID_TERCERO = '$id_tercero'   AND CT.ID_SUCURSAL_TERCERO = '$id_sucursal_tercero' "  );   
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }


  //seccion de tercero cliente
  static Future getFormPago(String id_tercero, String nit ) async {

    Database database = await _openDB();
    final res = await database.rawQuery(
      "SELECT id_tipo_pago,descripcion FROM TERCERO "
       " INNER JOIN  tipo_pago ON tipo_pago.id_tipo_pago=tercero.id_forma_pago AND tercero.nit=tipo_pago.nit"
       " AND id_tercero= '$id_tercero' and tercero.nit ='$nit' ");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }
  
   //seccion de tercero pedido
  static Future getClasificacionProductos(String nit, String  nivel,String  id_padre) async {
 print("busca los producto snivel $nivel");
    Database database = await _openDB();
     final res = await database.rawQuery(
        " SELECT * FROM clasificacion_item  WHERE  nit = '$nit' AND nivel=$nivel AND id_padre='$id_padre' "
        " ORDER BY descripcion ASC "  );   
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }
  //seccion de tercero pedido
  static Future getItems(String nit, String  id_clasificacion) async {
 print("busca los producto getItems $id_clasificacion ");
    Database database = await _openDB();
     final res = await database.rawQuery(
        "  SELECT * from item i LEFT JOIN precio_item_det pd  ON pd.id_item = i.id_item "
        "  WHERE i.nit= '$nit' and id_clasificacion='$id_clasificacion'  ORDER BY descripcion ASC  "  );   
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }


  //seccion de tercero pedidonit
  static Future getPrecioProducto(String nit, String  idItem, String _itemsListPrecio) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        "  SELECT precio, descuento_maximo,id_item FROM precio_item_det "
        " WHERE id_item='$idItem' AND id_precio_item = '$_itemsListPrecio' AND nit='$nit' "  );
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }
}
