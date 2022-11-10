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
import '../models/recibo_caja.dart';

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

    //await deleteDatabase(path);

    const tableUsuario = """
            CREATE TABLE IF NOT EXISTS usuario(id INTEGER PRIMARY KEY, usuario TEXT, password TEXT,nit TEXT,id_tipo_doc_pe TEXT,id_tipo_doc_rc TEXT)
      ;""";
    const tableCuotaVenta = """
            CREATE TABLE IF NOT EXISTS  cuota_venta( id INTEGER PRIMARY KEY AUTOINCREMENT, venta TEXT, cuota TEXT, id_linea TEXT, nombre TEXT, nit TEXT,id_vendedor TEXT,id_suc_vendedor INTEGER)
      ;""";
    const tableBanco = """
          CREATE TABLE IF NOT EXISTS
           banco(
             id_banco TEXT NOT NULL,
              descripcion TEXT, 
              nit TEXT NOT NULL,
              PRIMARY KEY("id_banco","nit")
           )
     ;""";
    const tableBarrio = """
        CREATE TABLE IF NOT EXISTS barrio
              (
                  id_pais TEXT NOT NULL,
                  id_depto TEXT NOT NULL,
                  id_ciudad  TEXT NOT NULL,
                  id_barrio TEXT NOT NULL,
                  nombre TEXT,
                  nit TEXT NOT NULL,
               PRIMARY KEY("id_pais","id_depto","id_ciudad","id_barrio") 
              )
     ;""";
    const tableCiudad = """       
          CREATE TABLE IF NOT EXISTS  ciudad
          (
              id_pais TEXT NOT NULL,
              id_depto TEXT NOT NULL,
              id_ciudad TEXT NOT NULL,
              nombre TEXT,
              nit TEXT NOT NULL ,
          PRIMARY KEY("id_pais","id_depto","id_ciudad") 
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
              imagen TEXT,   
              PRIMARY KEY("id_clasificacion") 
          )
      ;""";
    const tableConceptos = """   
         CREATE TABLE IF NOT EXISTS conceptos
              (
                  id_concepto TEXT NOT NULL,
                  descripcion TEXT,
                  naturalezacta TEXT,
                  nit TEXT NOT NULL,
                  id_auxiliar TEXT ,
                  PRIMARY KEY("id_concepto") 
              )
      ;""";
       const tableAuxiliar = """   
         CREATE TABLE IF NOT EXISTS auxiliar
              (
                  id_auxiliar TEXT NOT NULL,
                  descripcion TEXT,
                  flag_flujo_caja TEXT DEFAULT 'NO',                
                  id_tipo_cuenta TEXT , 
                  nit TEXT NOT NULL,
                  PRIMARY KEY("id_auxiliar") 
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
          nit TEXT NOT NULL ,
           PRIMARY KEY("id_pais","id_depto") 
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
              estado TEXT NOT NULL,
              PRIMARY KEY("nit")
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
          nit TEXT NOT NULL ,
          PRIMARY KEY("id_forma_pago") 
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
        saldo_inventario TEXT  ,
        PRIMARY KEY("id_item") 
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
        nit TEXT NOT NULL,
        PRIMARY KEY("id_item","consecutivo") 
      )
   ;""";
    const tableMedioContacto = """   
   CREATE TABLE IF NOT EXISTS medio_contacto
    (
        id_medio_contacto TEXT NOT NULL,
        descripcion TEXT,
        nit TEXT NOT NULL ,
        PRIMARY KEY("id_medio_contacto" ) 
    )
   ;""";
    const tablePais = """   
     CREATE TABLE IF NOT EXISTS pais
(
    id_pais TEXT NOT NULL,
    nombre TEXT,
    ie_pais TEXT,
    nacionalidad TEXT,
    nit TEXT NOT NULL,
    PRIMARY KEY( "id_pais","nit")
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
    nit TEXT NOT NULL,
    PRIMARY KEY( "id_empresa","id_tercero","numero","id_sucursal","id_tipo_doc")
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
    nit  TEXT NOT NULL ,
    PRIMARY KEY("id_empresa","numero","id_sucursal","id_tipo_doc","consecutivo")
    )  
     ;""";


    const tablePedidoKit = """  
CREATE TABLE IF NOT EXISTS  pedido_kit
(
    id_empresa TEXT NOT NULL,
    id_sucursal TEXT NOT NULL,
    id_tipo_doc TEXT NOT NULL,
    numero integer NOT NULL,
    consecutivo integer NOT NULL,
    id_kit TEXT NOT NULL,
    id_item TEXT NOT NULL, 
    id_bodega TEXT,
    cantidad_kit  INTEGER DEFAULT 0,
    cantidad INTEGER DEFAULT 0,
    id_unidad TEXT,
    factor INTEGER DEFAULT 0,
    precio TEXT DEFAULT '0',
    total TEXT DEFAULT '0',    
    precio_kit TEXT DEFAULT 0,     
    nit  TEXT NOT NULL ,
    PRIMARY KEY( "id_empresa","numero","id_sucursal","id_tipo_doc","consecutivo")
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
    nit TEXT NOT NULL ,
    PRIMARY KEY( "id_precio_item")  
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
    nit TEXT NOT NULL ,
    PRIMARY KEY( "id_precio_item","id_item","id_talla","id_unidad_compra")  
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
    vendedor  TEXT DEFAULT 'NO',
    id_lista_precio  TEXT  ,
    id_forma_pago  TEXT  ,
    usuario  TEXT  ,
  	flag_enviado	TEXT DEFAULT 'NO',
    e_mail  TEXT  ,
    telefono_celular TEXT  ,
    e_mail_fe  TEXT  ,
    nit  TEXT  NOT NULL,
    PRIMARY KEY("id_tercero","id_sucursal_tercero")
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
    flag_exento_iva TEXT ,
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
    nit TEXT NOT NULL,
    PRIMARY KEY("id_tercero","id_sucursal_tercero")
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
    nit TEXT NOT NULL ,
    PRIMARY KEY("id_tercero","id_sucursal_tercero","id_direccion")
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
    nit TEXT NOT NULL ,
    PRIMARY KEY("id_empresa","id_sucursal","id_tipo_doc")
) ;""";
    const tableTipoEmpresa = """  
CREATE TABLE IF NOT EXISTS  tipo_empresa
(
    id_tipo_empresa TEXT NOT NULL,
    descripcion TEXT,
    nit TEXT NOT NULL,
    PRIMARY KEY("id_tipo_empresa")
) ;""";
    const tableTipoIdenti = """  
CREATE TABLE IF NOT EXISTS tipo_identificacion
(
    id_tipo_identificacion TEXT NOT NULL,
    descripcion TEXT,
    PRIMARY KEY("id_tipo_identificacion")
) ;""";
    const tableTipoPago = """  
CREATE TABLE IF NOT EXISTS tipo_pago
(
    id_tipo_pago TEXT NOT NULL,
    descripcion TEXT,
    nit TEXT NOT NULL ,
    PRIMARY KEY("id_tipo_pago")
) ;""";
    const tableTipoPagoDet = """  
CREATE TABLE IF NOT EXISTS tipo_pagodet
(
    id_tipo_pago  TEXT NOT NULL,
    cuota integer NOT NULL,
    dias integer ,
    tasa TEXT,
    nit  TEXT NOT NULL,
    id_auxiliar TEXT,
    PRIMARY KEY("id_tipo_pago","cuota")
) ;""";
    const tableZona = """  
CREATE TABLE IF NOT EXISTS zona
(
    id_zona TEXT NOT NULL,
    descripcion TEXT,
    id_padre TEXT,
    nivel integer,
    es_padre TEXT,
    nit TEXT NOT NULL ,
      PRIMARY KEY("id_zona") 
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
      nit TEXT NOT NULL ,
       PRIMARY KEY("id_kit")   
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
    nit TEXT  NOT NULL ,
     PRIMARY KEY("id_kit", "id_item")   
);""";

    const tableCarteraProveedores = """
CREATE TABLE IF NOT EXISTS  cartera_proveedores
(
    id_empresa TEXT NOT NULL,
    id_sucursal TEXT NOT NULL,
    id_tipo_doc TEXT NOT NULL,
    numero integer NOT NULL,
    fecha TEXT ,
    total  TEXT DEFAULT '0',
    vencimiento  TEXT,
    letras TEXT,
    id_moneda TEXT,
    id_tercero TEXT,
    id_sucursal_tercero INTEGER DEFAULT 1,
    id_recaudador TEXT,
    fecha_trm TEXT,
    trm TEXT DEFAULT '0',
    observaciones TEXT,
    usuario TEXT,
    flag_enviado TEXT DEFAULT 'NO',
    nit TEXT NOT NULL ,
    PRIMARY KEY("id_empresa","id_sucursal","id_tipo_doc","numero")
);""";

    const tableCarteraProveedoresDet = """
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
    nit TEXT  NOT NULL ,
     PRIMARY KEY("id_empresa","id_sucursal","id_tipo_doc","numero","consecutivo") 
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

    const tableCarrito = """ CREATE TABLE carrito (
	id_tercero	TEXT,
  nombre_sucursal TEXT,
	id_empresa	TEXT,
	id_tipo_doc	TEXT,
	numero	INTEGER,
	id_vendedor	TEXT,
	id_suc_vendedor	TEXT,
	fecha	TEXT,
	id_forma_pago	TEXT,
	id_precio_item	TEXT,
	id_direccion	TEXT,
	subtotal	TEXT,
	total_costo	TEXT,
	total_dcto	TEXT,
	total	TEXT,
	orden_compra	TEXT,
	observacion	TEXT,
	letras	TEXT,
	id_direccion_factura	TEXT,
	usuario	TEXT,
  nit TEXT,
  PRIMARY KEY( "id_tercero","numero")
) ;""";

    const tableCarritoDet = """ CREATE TABLE carrito_detalle (
      id_tercero	TEXT,
    	numero	INTEGER,
      descripcion	TEXT,
      id_item	TEXT,
      precio	TEXT,
      cantidad	TEXT,
      total_dcto	TEXT,
      dcto	TEXT,
      id_precio_item	TEXT,
      nit TEXT,
      PRIMARY KEY("id_item","id_tercero","numero")
    );""";

    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute(tableUsuario);
      await db.execute(tableCuotaVenta);
      await db.execute(tableBanco);
      await db.execute(tableBarrio);
      await db.execute(tableCiudad);
      await db.execute(tableclasificacion_item);
      await db.execute(tableConceptos);
      await db.execute(tableAuxiliar);
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
      await db.execute(tablePedidoKit);
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
      await db.execute(tableCarteraProveedoresDet);
      await db.execute(viewCartera);
      await db.execute(tableCarrito);
      await db.execute(tableCarritoDet);

      print("crearon tablas");
    }, version: 1);
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
  static Future getLogin(String usuario ) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM usuario WHERE usuario = '$usuario' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }
  /// Simple query with sqflite helper
  static Future getLoginPassw(String usuario, String password) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM usuario WHERE usuario = '$usuario' and password = '$password'");
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> deleteDataUsuario() async {
    Database database = await _openDB();
    await database.rawDelete('DELETE FROM usuario');
  }

  //seccion de tercero cliente
  static Future getClient(String nit, String search) async {
    Database database = await _openDB();
    var sql =
        " SELECT tercero.id_tercero,tercero.id_sucursal_tercero, usuario,id_tipo_identificacion,tercero.dv,tercero.telefono,ciudad.nombre AS ciudad,tercero.direccion,"
        " tercero.primer_nombre || ' ' || primer_apellido AS nombre_completo ,"
        " nombre_sucursal,e_mail,tercero.nit,limite_credito,tercero.id_forma_pago, "
        " id_suc_vendedor,id_empresa, tercero_cliente.id_precio_item as lista_precio "
        " FROM tercero JOIN tercero_cliente ON tercero_cliente.id_tercero=tercero.id_tercero AND tercero.nit=tercero_cliente.nit "
        " JOIN ciudad ON tercero.id_ciudad=ciudad.id_ciudad AND tercero.nit=ciudad.nit"
        " JOIN empresa ON empresa.nit=tercero.nit"
        " WHERE tercero.nit ='$nit' AND vendedor='NO'";

    if (search.isNotEmpty && search != "@" && search != '') {
      sql += ' AND nombre_sucursal LIKE "%$search%" ';
    }
    sql += ' ORDER BY 1 ASC ';

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //vendedor
  static Future getVendedor(String nit, String user) async {
    Database database = await _openDB();

    var sql = " select tercero.id_tercero , tercero.id_sucursal_tercero, tercero.id_forma_pago,"
    " id_precio_item, id_lista_precio,id_suc_vendedor from tercero INNER JOIN  tercero_cliente"
    " ON tercero.id_tercero=tercero_cliente.id_tercero"
    " where usuario='$user' and tercero.nit='$nit'   AND cliente ='NO' limit 1 ";
    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future<bool> insertCliente(Cliente cliente) async {
    Database database = await _openDB();
    var flag = await validaInsertCliente(cliente.id_tercero);
    if (flag) {
      final res = await database.rawQuery(
          " select id_tipo_empresa from empresa where  nit ='${cliente.nit}'  ");
      var id_tipo_empresa = res[0]['id_tipo_empresa'].toString();

      await database.rawInsert("INSERT INTO tercero("
          " id_tercero,id_sucursal_tercero,id_tipo_identificacion, dv, nombre, direccion, id_pais, id_depto,id_forma_pago,id_lista_precio,"
          " id_ciudad, id_barrio, telefono,id_actividad,fecha_creacion,nombre_sucursal,"
          " primer_apellido, segundo_apellido, primer_nombre, segundo_nombre,flag_persona_nat,estado_tercero,e_mail,nit,id_tipo_empresa)"
          " VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},${cliente.id_tipo_identificacion}, ${cliente.dv},'${cliente.nombre}','${cliente.direccion}',${cliente.id_pais}, ${cliente.id_depto},'${cliente.id_forma_pago}','${cliente.id_lista_precio}',"
          " ${cliente.id_ciudad}, ${cliente.id_barrio}, ${cliente.telefono}, '${cliente.id_actividad}','${cliente.fecha_creacion}', '${cliente.nombre_sucursal}',"
          " '${cliente.primer_apellido}', '${cliente.segundo_apellido}', '${cliente.primer_nombre}','${cliente.segundo_nombre}', '${cliente.flag_persona_nat}', 'ACTIVO','${cliente.e_mail}',${cliente.nit},'${id_tipo_empresa}')");

      await database.rawInsert("INSERT INTO tercero_cliente("
          " id_tercero, id_sucursal_tercero,id_forma_pago,id_precio_item ,id_vendedor,id_suc_vendedor,id_medio_contacto, id_zona,nit,limite_credito )"
          "  VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'${cliente.id_forma_pago}', ${cliente.id_precio_item},${cliente.id_vendedor}, ${cliente.id_suc_vendedor},"
          "  ${cliente.id_medio_contacto},'${cliente.id_zona}', '${cliente.nit}', '0')");

      await database.rawInsert("INSERT INTO tercero_direccion("
          " id_tercero, id_sucursal_tercero, id_direccion, direccion, telefono, id_pais, id_ciudad, id_depto, tipo_direccion, nit)"
          " VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'1', '${cliente.direccion}',${cliente.telefono}, ${cliente.id_pais},${cliente.id_ciudad}, ${cliente.id_depto},"
          " 'Factura', ${cliente.nit})");
      await database.rawInsert("INSERT INTO tercero_direccion("
          "id_tercero, id_sucursal_tercero, id_direccion, direccion, telefono, id_pais, id_ciudad, id_depto, tipo_direccion, nit)"
          "   VALUES (${cliente.id_tercero},${cliente.id_sucursal_tercero},'2', '${cliente.direccion}',${cliente.telefono}, ${cliente.id_pais},${cliente.id_ciudad}, ${cliente.id_depto},"
          "   'Mercancia', ${cliente.nit})");
    } else {
      return false;
    }
    return flag;
  }

  //insertar los tercero que viene de la api
  static Future<bool> validaInsertCliente(String tercero) async {
    var flag = false;
    Database database = await _openDB();
    final res = await database
        .rawQuery("SELECT * FROM tercero WHERE id_tercero = '$tercero' ");
    if (res.isEmpty) {
      flag = true;
    }
    final res1 = await database.rawQuery(
        "SELECT * FROM tercero_cliente WHERE id_tercero = '$tercero' ");
    if (res1.isEmpty) {
      flag = true;
    }
    final res2 = await database.rawQuery(
        "SELECT * FROM tercero_direccion WHERE id_tercero = '$tercero' ");
    if (res2.isEmpty) {
      flag = true;
    }
    return flag;
  }

  //insertar los tercero que viene de la api
  static Future<bool> updateCliente(String tercero, String nit) async {
    var flag = false;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "UPDATE tercero SET  flag_enviado='SI' WHERE  id_tercero = '$tercero' AND nit = '$nit'");
    if (res.isEmpty) {
      flag = true;
    }
    return flag;
  }

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
  static Future getFacturaId(String id_tercero) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select numero, fecha, total_fac ,id_item , descripcion_item , precio, cantidad,  total  from factura"
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
    if (res.length == 0) {
      await database.insert('tercero', tercero.toMap());
    }
    return true;
  }

  //insertar los tercero que viene de la api
  static Future<bool> insertTerceroCliente(
      TerceroCliente tercerocliente) async {
    var idTercero = tercerocliente.id_tercero;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM tercero_cliente WHERE id_tercero = '$idTercero' ");
    if (res.length == 0) {
      await database.insert('tercero_cliente', tercerocliente.toMap());
    } else {
      await database.update(
        'tercero_cliente',
        tercerocliente.toMap(),
        where: "id_tercero = ?",
        whereArgs: [idTercero],
      );
    }
    return true;
  }

  //insertar los tercero que viene de la api
  static Future<bool> insertTerceroDireccion(
      TerceroDireccion tercerodireccion) async {
    var idTercero = tercerodireccion.id_tercero;
    var id_direccion = tercerodireccion.id_direccion;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM tercero_direccion WHERE id_tercero = '$idTercero' and id_direccion = '$id_direccion' ");
    if (res.isEmpty) {
      await database.insert('tercero_direccion', tercerodireccion.toMap());
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future getTercero() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*)  FROM tercero ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  /// Simple query with sqflite helper
  static Future getTerceroCliente() async {
    Database database = await _openDB();
    final res =
        await database.rawQuery("SELECT count(*) FROM tercero_cliente ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  /// Simple query with sqflite helper
  static Future getTerceroDireccion() async {
    Database database = await _openDB();
    final res =
        await database.rawQuery("SELECT count(*)  FROM tercero_direccion");
    if (res.isNotEmpty) {
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
    final res = await database.rawQuery(
        "SELECT * FROM tipo_pago WHERE id_tipo_pago = '$id_tipo_pago' ");
    if (res.isEmpty) {
      await database.insert('tipo_pago', tipopago.toMap());
    } else {
      await database.update(
        'tipo_pago',
        tipopago.toMap(),
        where: "id_tipo_pago = ?",
        whereArgs: [id_tipo_pago],
      );
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future getTipoPago() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM tipo_pago ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  //insertar las empresa que viene de la api
  static Future<bool> insertEmpresa(Empresa empresa) async {
    var nit = empresa.nit;
    Database database = await _openDB();
    final res =
        await database.rawQuery("SELECT * FROM empresa WHERE nit = '$nit' ");
    if (res.isEmpty) {
      await database.insert('empresa', empresa.toMap());
      return true;
    } else {
      return false;
    }
  }

  /// Simple query with sqflite helper
  static Future getEmpresa() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM empresa ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }
    //insertar los paises que viene de la api
  static Future<bool> insertPais(Pais pais) async {
    var id_pais = pais.id_pais;
     var nit = pais.nit;
    Database database = await _openDB();
    final res = await database
        .rawQuery("SELECT * FROM pais WHERE id_pais = '$id_pais' and nit='$nit' ");
    if (res.isEmpty) {
      await database.insert('pais', pais.toMap());
      return true;
    } else {
      return false;
    }
  }

  //insertar las ciudad que viene de la api
  static Future<bool> insertCiudad(Ciudad ciudad) async {
    var id_ciudad = ciudad.id_ciudad;
    var nit = ciudad.nit;
    Database database = await _openDB();
    final res = await database
        .rawQuery("SELECT * FROM ciudad WHERE id_ciudad = '$id_ciudad' and nit = '$nit'");
    if (res.length == 0) {
      await database.insert('ciudad', ciudad.toMap());
      return true;
    } else {
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

  static Future getCiudadList(String nit, String id_depto) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT id_ciudad as value, nombre as label from ciudad WHERE nit = '$nit' and  id_depto ='$id_depto' ");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  static Future getBancoList(String nit) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT id_banco as value, descripcion as label from banco WHERE nit = '$nit'");
    if (res.isNotEmpty) {
      return res;
    } else {
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
    } else {
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

  static Future getZonaList(String nit) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select id_zona as value, descripcion as label  FROM zona WHERE nit = $nit ");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  //insertar las zona> que viene de la api
  static Future<bool> insertMedioContacto(MedioContacto medio_contacto) async {
    var id_medio_contacto = medio_contacto.id_medio_contacto;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM medio_contacto WHERE id_medio_contacto = '$id_medio_contacto' ");
    if (res.length == 0) {
      await database.insert('medio_contacto', medio_contacto.toMap());
      return true;
    } else {
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

  static Future getMedioContactoList(String nit) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select id_medio_contacto as value, descripcion as label from medio_contacto WHERE nit = $nit ");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  static Future<bool> insertTipoIdentificacion(
      TipoIdentificacion tipoident) async {
    var id_tipo_identificacion = tipoident.id_tipo_identificacion;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM tipo_identificacion WHERE id_tipo_identificacion = '$id_tipo_identificacion' ");
    if (res.length == 0) {
      await database.insert('tipo_identificacion', tipoident.toMap());
      return true;
    } else {
      return false;
    }
  }

  /// Simple query with sqflite helper
  static Future getTipoIdentificacion() async {
    Database database = await _openDB();
    final res =
        await database.rawQuery("SELECT count(*) FROM tipo_identificacion");
    if (res.length > 0) {
      return res;
    } else {
      return null;
    }
  }

  static Future getTipoIdentificacionList() async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select id_tipo_identificacion as value, descripcion as label from tipo_identificacion  ORDER BY descripcion ASC ");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  static Future<bool> insertTipoEmpresa(TipoEmpresa tipoempresa) async {
    var id_tipo_empresa = tipoempresa.id_tipo_empresa;
    var nit = tipoempresa.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM tipo_empresa WHERE id_tipo_empresa = '$id_tipo_empresa' and nit = '$nit'");
    if (res.length == 0) {
      await database.insert('tipo_empresa', tipoempresa.toMap());
      return true;
    } else {
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

  static Future getTipoEmpresaList(String nit) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select id_tipo_empresa value, descripcion as label from tipo_empresa  where nit='$nit'");
    if (res.length > 0) {
      return res;
    } else {
      return false;
    }
  }

  static Future<bool> insertBarrio(Barrio barrio) async {
    var id_barrio = barrio.id_barrio;
    var nit = barrio.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM barrio WHERE id_barrio = '$id_barrio' and nit = '$nit'");
    if (res.length == 0) {
      await database.insert('barrio', barrio.toMap());
      return true;
    } else {
      return false;
    }
  }

  /// Simple query with sqflite helper
  static Future getBarrio() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM barrio");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future getBarrioList(String nit, String ciudad) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select id_barrio as value, nombre as label FROM barrio  where nit='$nit'  and id_ciudad = $ciudad");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future<bool> insertDepto(Depto depto) async {
    var idDepto = depto.id_depto;
    var nit = depto.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM depto WHERE id_depto = '$idDepto' and nit = '$nit'");
    if (res.isEmpty) {
      await database.insert('depto', depto.toMap());
      return true;
    } else {
      return false;
    }
  }

  /// Simple query with sqflite helper
  static Future getDepto() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM depto");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future getDeptoList(String nit) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " select id_depto as value, nombre as label from depto where nit='$nit'");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //insertar las ciudad que viene de la api
  static Future<bool> insertTipoDoc(TipoDoc tipodoc) async {
    var empresa = tipodoc.id_empresa;
    var idTipoDoc = tipodoc.id_tipo_doc;
    var nit = tipodoc.nit;
    var consecutivoNew = tipodoc.consecutivo;

    Database database = await _openDB();
    List<Map> res = await database.rawQuery(
        "SELECT * FROM tipo_doc WHERE id_empresa = '$empresa'  and id_tipo_doc = '$idTipoDoc' and nit = '$nit'");
    if (res.isEmpty) {
      await database.insert('tipo_doc', tipodoc.toMap());
    } else {
      if (consecutivoNew > res[0]['consecutivo']) {
        await database.rawQuery(
            "UPDATE tipo_doc SET  consecutivo='$consecutivoNew' WHERE id_empresa = '$empresa'  and id_tipo_doc = '$idTipoDoc' and nit = '$nit'");
      }
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future getTipoDoc() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM tipo_doc ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  //pantalla de pedido
  //insertar getConsecutivoTipoDoc
  static Future getConsecutivoTipoDoc(
      String nit, String id_tipo_doc, String id_empresa) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT max(consecutivo) as consecutivo  from tipo_doc WHERE  nit = '$nit' and id_tipo_doc = '$id_tipo_doc' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getDireccion(String nit, String id_tercero) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT  0  as value,'Seleccione' as label "
        " UNION "
        " SELECT  id_direccion  as value,direccion as label FROM tercero_direccion WHERE id_tercero= '$id_tercero' and  nit ='$nit' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //insertar las factura que viene de la api
  static Future<bool> insertFactura(Factura factura) async {
    var numero = factura.numero;
    var idItem = factura.id_item;
    var idTercero = factura.id_tercero;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM factura WHERE numero = '$numero' and id_item = '$idItem' and id_tercero = '$idTercero'");
    if (res.isEmpty) {
      await database.insert('factura', factura.toMap());
    } else {
      await database.update('factura', factura.toMap(),
          where: "numero = ? AND id_tercero = ? ",
          whereArgs: [numero, idTercero]);
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future getFactura() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM factura ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future<bool> insertClasificacionItem(ClasificacionItems clasi) async {
    var idClasificacion = clasi.id_clasificacion;
    var nit = clasi.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM clasificacion_item WHERE id_clasificacion = '$idClasificacion' and nit = '$nit' ");
    if (res.isEmpty) {
      await database.insert('clasificacion_item', clasi.toMap());
    } else {
      await database.update(
        'clasificacion_item',
        clasi.toMap(),
        where: "id_clasificacion = ? AND nit= ? ",
        whereArgs: [idClasificacion, nit],
      );
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future getClasificacionItem() async {
    Database database = await _openDB();
    final res =
        await database.rawQuery("SELECT count(*) FROM clasificacion_item ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  //insertar las factura que viene de la api
  static Future<bool> insertPrecioItem(PrecioItems precio) async {
    var idPrecioItem = precio.id_precio_item;
    var nit = precio.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM precio_item WHERE id_precio_item = '$idPrecioItem' and nit = '$nit' ");
    if (res.isEmpty) {
      await database.insert('precio_item', precio.toMap());
    } else {
      await database.update(
        'precio_item',
        precio.toMap(),
        where: "id_precio_item = ? AND nit= ? ",
        whereArgs: [idPrecioItem, nit],
      );
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future getPrecioItem() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM precio_item ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  //insertar las factura que viene de la api
  static Future<bool> insertPrecioItemDet(PrecioItemsDet precio) async {
    var idPrecioItem = precio.id_precio_item;
    var nit = precio.nit;
    var idItem = precio.id_item;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM precio_item_det WHERE id_precio_item = '$idPrecioItem' and nit = '$nit'  and id_item = '$idItem'");
    if (res.isEmpty) {
      await database.insert('precio_item_det', precio.toMap());
    } else {
      await database.update(
        'precio_item_det',
        precio.toMap(),
        where: "id_item = ? AND id_precio_item= ? ",
        whereArgs: [idItem, idPrecioItem],
      );
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future getPrecioItemDet() async {
    Database database = await _openDB();
    final res =
        await database.rawQuery("SELECT count(*) FROM precio_item_det ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  //insertar las factura que viene de la api
  static Future<bool> inserItem(Items item) async {
    var nit = item.nit;
    var idItem = item.id_item;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM item WHERE id_item = '$idItem' and nit = '$nit' ");
    if (res.isEmpty) {
      await database.insert('item', item.toMap());
    } else {
      await database.update(
        'item',
        item.toMap(),
        where: "id_item = ?",
        whereArgs: [idItem],
      );
    }
    return true;
  }

  /// Simple query with sqflite helper
  static Future deleteItem() async {
    Database database = await _openDB();
    final res = await database.rawQuery("DELETE FROM item ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  /// Simple query with sqflite helper
  static Future getItem() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM item ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future<bool> insertPedido(Pedido pedido,bool origen) async {
    var numero = pedido.numero;
    var nit = pedido.nit;
    var id_tipo_doc = pedido.id_tipo_doc;
    var id_tercero = pedido.id_tercero;

    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT * FROM pedido WHERE  id_tipo_doc ='$id_tipo_doc' and numero='$numero' and nit= '$nit'");
    final resTercero = await database.rawQuery(
        " SELECT * FROM tercero WHERE id_tercero='$id_tercero' AND nit='$nit'");
    if (res.isEmpty && resTercero.isNotEmpty) {
      await database.insert('pedido', pedido.toMap());
    } else {
      if(origen) {
        await database.update('pedido', pedido.toMap(),
          where: "numero = ?", whereArgs: [numero]);
      }
    }
    return true;
  }

  static Future getPedido() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM pedido");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future updateConsecutivo(
      int numero, String nit, String id_tipo_doc, String id_empresa) async {
    var nuevo_conse = numero + 1;
    Database database = await _openDB();

    final res = await database.rawQuery(
        "UPDATE tipo_doc SET consecutivo='$nuevo_conse'  WHERE id_tipo_doc='$id_tipo_doc' AND nit='$nit' and id_empresa='$id_empresa' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future<bool> insertPedidoDet(PedidoDet pedidodet) async {
    var numero = pedidodet.numero;
    var idItem = pedidodet.id_item;
    var nit = pedidodet.nit;

    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT * FROM pedido_det WHERE id_item='$idItem' and  numero='$numero' and nit= '$nit'");
    final resPedido = await database.rawQuery(
        " SELECT * FROM pedido WHERE numero='$numero' AND nit='$nit'");
    if (res.isEmpty && resPedido.isNotEmpty) {
       await database.insert('pedido_det', pedidodet.toMap());
    } else {
      await database.update('pedido_det', pedidodet.toMap(),
          where: "numero = ? and id_item = ?", whereArgs: [numero, idItem]);
    }
    return true;
  }

  static Future getPedidoDetNum(numero) async {
    Database database = await _openDB();
    final res = await database
        .rawQuery("SELECT count(*) FROM pedido_det where numero = '$numero' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future getPedidoDet() async {
    Database database = await _openDB();
    final res = await database.rawQuery("SELECT count(*) FROM pedido_det");
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  static Future<bool> updatePedidoFlag(String numero, String nit) async {
    var flag = false;
    Database database = await _openDB();
    final res = await database.rawQuery(
        " UPDATE pedido SET  flag_enviado='SI' 	WHERE  numero = '$numero' and nit = '$nit'");
    if (res.isEmpty) {
      flag = true;
    }
    return flag;
  }

  static Future<bool> editarPedido(numero) async {
    Database database = await _openDB();
    await database
        .delete('pedido_det', where: 'numero = ?', whereArgs: [numero]);
    return true;
  }

  static Future<bool> editarPedidoDet(PedidoDet pedidodet) async {
    var numero = pedidodet.numero;
    var id_item = pedidodet.id_item;
    var nit = pedidodet.nit;
    var id_tipo_doc = pedidodet.id_tipo_doc;
    var consecutivo = pedidodet.consecutivo;
    var descripcion_item = pedidodet.descripcion_item;
    var cantidad = pedidodet.cantidad;
    var precio = pedidodet.precio;
    var precio_lista = pedidodet.precio_lista;
    var total_dcto = pedidodet.total_dcto;
    var costo = pedidodet.costo;
    var subtotal = pedidodet.subtotal;
    var total = pedidodet.total;
    var id_precio_item = pedidodet.id_precio_item;
    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT * FROM pedido_det WHERE id_item='$id_item' and  id_tipo_doc ='$id_tipo_doc' and numero='$numero' and nit= '$nit' and consecutivo = '$consecutivo'");
    if (res.isEmpty) {
      await database.insert('pedido_det', pedidodet.toMap());
    } else {
      var sql = " UPDATE pedido_det "
          " SET  consecutivo=$consecutivo, id_item='$id_item', descripcion_item='$descripcion_item',  "
          " cantidad='$cantidad, precio='$precio', precio_lista='$precio_lista', "
          " total_dcto='$total_dcto, costo='$costo', subtotal='$subtotal', total='$total,  id_precio_item='$id_precio_item' "
          " WHERE id_item='$id_item' and  id_tipo_doc ='$id_tipo_doc' and numero='$numero' and nit= '$nit'";

      await database.rawQuery(sql);
    }
    return true;
  }

  static Future getHistorialPedidos(idVendedor, fecha1, fecha2, search) async {
    Database database = await _openDB();

    /*var sql =
        "SELECT T.NOMBRE  as nombre , T.nombre_sucursal as nombre_sucursal ,P.ID_EMPRESA,P.ID_SUCURSAL,"
        "P.ID_TIPO_DOC,P.NUMERO,  STRFTIME('%d/%m/%Y ', P.FECHA)  AS fecha, orden_compra, P.id_precio_item,  "
        "P.TOTAL,P.ESTADO,TD.DIRECCION,P.ID_TERCERO,T.id_sucursal_tercero, TC.limite_credito, P.id_direccion_factura,P.id_direccion   FROM PEDIDO P "
        "LEFT JOIN TERCERO_DIRECCION TD ON (TD.ID_TERCERO = P.ID_TERCERO "
        "AND TD.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO "
        "AND TD.ID_DIRECCION = P.ID_DIRECCION) INNER JOIN TERCERO T ON (T.ID_TERCERO = P.ID_TERCERO "
        "AND T.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO)  INNER JOIN "
        "tercero_cliente TC ON (TC.ID_TERCERO = P.ID_TERCERO AND TC.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO)  WHERE P.ID_VENDEDOR ='$idVendedor' "
        "AND  date(FECHA)  >= '$fecha1'  AND  date(FECHA)  <=  '$fecha2' ";

        */

    var sql =
        "SELECT T.NOMBRE  as nombre , T.nombre_sucursal as nombre_sucursal ,P.ID_EMPRESA,P.ID_SUCURSAL,P.ID_TIPO_DOC,P.NUMERO,"
        " STRFTIME('%d/%m/%Y ', P.FECHA)  AS fecha, P.orden_compra, P.id_precio_item,P.id_forma_pago, P.TOTAL,P.ESTADO,TD.DIRECCION,P.ID_TERCERO,T.id_sucursal_tercero, "
        "  TC.limite_credito, P.id_direccion_factura,P.id_direccion   FROM PEDIDO P"
        " LEFT JOIN TERCERO_DIRECCION TD ON (TD.ID_TERCERO = P.ID_TERCERO  AND TD.ID_DIRECCION = P.ID_DIRECCION)"
        "  INNER JOIN TERCERO T ON (T.ID_TERCERO = P.ID_TERCERO )"
        " INNER JOIN tercero_cliente TC ON (TC.ID_TERCERO = P.ID_TERCERO )    WHERE P.ID_VENDEDOR ='$idVendedor' "
        " AND  date(FECHA)  >= '$fecha1'  AND  date(FECHA)  <=  '$fecha2' ";

    if (search != '@') {
      sql +=
          ' AND T.ID_TERCERO = "$search"   OR P.NUMERO = "$search" OR T.NOMBRE LIKE   "%$search%"  OR  T.NOMBRE_SUCURSAL LIKE  "%$search%" ';
    }
print("*-*-*-*-* $sql");
    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getHistorialPedidosDetalle(numero, nit) async {
    Database database = await _openDB();

    var sql =
        " select pedido_det.id_empresa,pedido_det.id_sucursal,pedido_det.id_tipo_doc,pedido_det.numero,consecutivo,"
        " id_item,descripcion_item,id_sucursal_tercero,id_bodega,cast(cantidad as int) as cantidad, precio,pedido_det.precio_lista ,"
        " pedido_det.total_dcto,pedido_det.subtotal,pedido_det.total, pedido_det.id_precio_item  from pedido_det "
        " INNER JOIN pedido on pedido.numero= pedido_det.numero  WHERE pedido.nit ='$nit' and pedido.numero = '$numero' ";

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getHistorialPedidosClienteBasico(idTercero, nit) async {
    Database database = await _openDB();

    var sql =
        " select total,numero ,  STRFTIME('%d/%m/%Y ', FECHA)  AS fecha  from  pedido where "
        " id_tercero=  '$idTercero'  and nit='$nit' order by 3 desc limit 1";

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getHistorialPedidosClienteDetalle(
      idTercero, nit, numero) async {
    Database database = await _openDB();

    var sql =
        " select   id_item,descripcion_item, cast(cantidad as int) as cantidad, precio, "
        "  pedido_det.total_dcto ,pedido_det.total  from pedido_det  "
        "  INNER JOIN pedido on pedido.numero= pedido_det.numero and pedido_det.numero= '$numero' "
        " WHERE pedido.nit ='$nit' and pedido.id_tercero = '$idTercero' ";

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getHistorialReciboClienteBasico(idTercero, nit) async {
    Database database = await _openDB();

    var sql =
        " SELECT numero,STRFTIME('%d/%m/%Y ', fecha) as fecha, strftime('%d', fecha) - strftime('%d', vencimiento) AS dias,total"
        " from cartera_proveedores WHERE id_tercero=  '$idTercero'  and nit='$nit' order by 1 desc limit 1";

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getHistorialReciboClienteDetalle(idTercero, nit, numero) async {
    Database database = await _openDB();

    var sql =
        "  select id_tipo_doc_cruce,numero_cruce,debito,credito from cartera_proveedores_det "
        "   where  id_tercero=  '$idTercero'  and nit='$nit' and numero='$numero'";

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getVisitados(idVendedor, fecha, orden) async {
    Database database = await _openDB();
    var sql =
        "SELECT T.nombre_sucursal as nombre_sucursal ,T.direccion ,T.telefono, max(P.numero) as numero "
        "FROM PEDIDO P INNER JOIN TERCERO_DIRECCION TD ON (TD.ID_TERCERO =P.ID_TERCERO "
        "AND TD.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO AND TD.ID_DIRECCION = P.ID_DIRECCION) "
        "INNER JOIN TERCERO T ON (T.ID_TERCERO = P.ID_TERCERO AND  T.ID_SUCURSAL_TERCERO = P.ID_SUCURSAL_TERCERO) "
        "WHERE P.ID_VENDEDOR = '$idVendedor' AND date(FECHA)  = '$fecha'  "
        "GROUP BY T.NOMBRE , T.nombre_sucursal ,T.direccion ,T.telefono,P.numero";
    sql += " ORDER BY P.NUMERO $orden";

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //seccion de tercero cliente
  static Future getSaldoCartera(
      String id_tercero, String id_sucursal_tercero) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT SUM(CT.DEBITO - CT.CREDITO)  AS DEBITO   FROM SALDO_CARTERA AS CT "
        "  WHERE CT.ID_TERCERO = '$id_tercero'   AND CT.ID_SUCURSAL_TERCERO = '$id_sucursal_tercero' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //seccion de tercero cliente
  static Future getFormPago(String id_tercero, String nit) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT id_tipo_pago,descripcion FROM TERCERO "
        " INNER JOIN  tipo_pago ON tipo_pago.id_tipo_pago=tercero.id_forma_pago AND tercero.nit=tipo_pago.nit"
        " AND id_tercero= '$id_tercero' and tercero.nit ='$nit' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //seccion de tercero pedido
  static Future getClasificacionProductos(
      String nit, String nivel, String idPadre, bool pedido, String search) async {
    Database database = await _openDB();
    var sql = '';
      if (pedido) {
        sql = " SELECT * FROM clasificacion_item  WHERE  nit = '$nit' AND nivel=$nivel AND id_padre='$idPadre' ";
      } else {
        sql = "SELECT * FROM clasificacion_item  WHERE  nit ='$nit' AND nivel=$nivel  ";
      }

      if (search != '@') {
        sql += ' AND descripcion LIKE  "%$search%" ';
      }
      sql += ' ORDER BY descripcion ASC  ';
print(sql);
    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //seccion de tercero pedido
  static Future getItems(String nit, String id_clasificacion,search) async {
    Database database = await _openDB();

    var sql = " SELECT * from item i LEFT JOIN precio_item_det pd  ON pd.id_item = i.id_item "
    "  WHERE i.nit= '$nit' and id_clasificacion='$id_clasificacion'   ";

    if (search != '@') {
      sql += ' AND descripcion LIKE  "%$search%" ';
    }
     sql += ' ORDER BY descripcion ASC  ';
  print(sql);
    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //seccion de tercero pedidonit
  static Future getPrecioProducto(
      String nit, String idItem, String _itemsListPrecio) async {
    Database database = await _openDB();
    final res = await database.rawQuery(
        " SELECT precio, descuento_maximo,id_item FROM precio_item_det "
        " WHERE id_item='$idItem' AND id_precio_item = '$_itemsListPrecio' AND nit='$nit' ");
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future<bool> insertCuentaTercero(CuentaTercero cuentatercero) async {
    var numero = cuentatercero.numero;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM cuentas_por_tercero WHERE numero = '$numero' ");
    if (res.isEmpty) {
      await database.insert('cuentas_por_tercero', cuentatercero.toMap());
    } else {
      await database.update('cuentas_por_tercero', cuentatercero.toMap(),
          where: "numero = ?", whereArgs: [numero]);
    }
    return true;
  }

  static Future<bool> insertCarteraProveedores(
      CarteraProveedores cartera_proveedores) async {
    var numero = cartera_proveedores.numero;
    var nit = cartera_proveedores.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM cartera_proveedores WHERE numero = '$numero' and nit = '$nit'");
    if (res.isEmpty) {
      await database.insert('cartera_proveedores', cartera_proveedores.toMap());
    } else {
      await database.update('cartera_proveedores', cartera_proveedores.toMap(),
          where: "numero = ?", whereArgs: [numero]);
    }
    return true;
  }


  static Future<bool> insertAuxiliar(Auxiliar auxiliar) async {
    var id_auxiliar = auxiliar.id_auxiliar;
    var nit = auxiliar.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM auxiliar WHERE id_auxiliar = '$id_auxiliar' and nit = '$nit'");
    if (res.isEmpty) {
      await database.insert('auxiliar', auxiliar.toMap());
    }
    return true;
  }

  static Future<bool> insertConcepto(Concepto conceptos) async {
    var id_concepto = conceptos.id_concepto;
    var nit = conceptos.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM conceptos WHERE id_concepto = '$id_concepto' and nit = '$nit'");
    if (res.isEmpty) {
      await database.insert('conceptos', conceptos.toMap());
    } else {
      await database.update('conceptos', conceptos.toMap(),
          where: "id_concepto = ?", whereArgs: [id_concepto]);
    }
    return true;
  }

  static Future<bool> insertBanco(Banco banco) async {
    var id_banco = banco.id_banco;
    var nit = banco.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM banco WHERE id_banco = '$id_banco' and nit = '$nit'");
    if (res.isEmpty) {
      await database.insert('banco', banco.toMap());
    }
    return true;
  }

  static Future<bool> insertFormaPago(FormaPago formapago) async {
    var id_forma_pago = formapago.id_forma_pago;
    var nit = formapago.nit;
    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM forma_pago WHERE id_forma_pago = '$id_forma_pago' AND nit = '$nit'");
    if (res.isEmpty) {
      await database.insert('forma_pago', formapago.toMap());
    } else {
      await database.update('forma_pago', formapago.toMap(),
          where: "id_forma_pago = ?", whereArgs: [id_forma_pago]);
    }
    return true;
  }

  static Future<bool> insertCarteraProveedoresDet(
      CarteraProveedoresDet cartera_proveedores_det) async {
    var id_empresa = cartera_proveedores_det.id_empresa;
    var id_sucursal = cartera_proveedores_det.id_sucursal;
    var id_empresa_cruce = cartera_proveedores_det.id_empresa_cruce;
    var id_sucursal_cruce = cartera_proveedores_det.id_sucursal_cruce;
    var id_tipo_doc_cruce = cartera_proveedores_det.id_tipo_doc_cruce;
    var numero_cruce = cartera_proveedores_det.numero_cruce;
    var numero = cartera_proveedores_det.numero;
    var nit = cartera_proveedores_det.nit;
    var consecutivo = cartera_proveedores_det.consecutivo;
    var id_tipo_doc = cartera_proveedores_det.id_tipo_doc;
    var fecha = cartera_proveedores_det.fecha;
    var vencimiento = cartera_proveedores_det.vencimiento;
    var debito = cartera_proveedores_det.debito;
    var credito = cartera_proveedores_det.credito;
    var id_sucursal_tercero = cartera_proveedores_det.id_sucursal_tercero;
    var id_tercero = cartera_proveedores_det.id_tercero;
    var cuota = cartera_proveedores_det.cuota;
    var distribucion = cartera_proveedores_det.distribucion;
    var descripcion = cartera_proveedores_det.descripcion;
    var total_factura = cartera_proveedores_det.total_factura;
    var id_concepto = cartera_proveedores_det.id_concepto;
    var cuota_cruce = cartera_proveedores_det.cuota_cruce;
    var id_banco = cartera_proveedores_det.id_banco;

    Database database = await _openDB();
    var sql =
        "SELECT * FROM cartera_proveedores_det WHERE numero = $numero AND nit = '$nit' AND id_tipo_doc = '$id_tipo_doc' AND consecutivo = $consecutivo ";
    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      var sql = "UPDATE cartera_proveedores_det"
          " SET id_empresa=' $id_empresa', id_sucursal='$id_sucursal', id_empresa_cruce='$id_empresa_cruce', "
          " id_sucursal_cruce='$id_sucursal_cruce', id_tipo_doc_cruce='$id_tipo_doc_cruce', numero_cruce='$numero_cruce', "
          " fecha='$fecha', vencimiento='$vencimiento', debito='$debito', credito='$credito',"
          " id_sucursal_tercero='$id_sucursal_tercero', id_tercero='$id_tercero', cuota='$cuota',"
          " distribucion='$distribucion', descripcion='$descripcion', total_factura='$total_factura',"
          " id_concepto='$id_concepto', cuota_cruce='$cuota_cruce', id_banco='$id_banco' "
          " WHERE  numero = $numero AND nit = '$nit' AND id_tipo_doc = '$id_tipo_doc' AND consecutivo = $consecutivo ";

      await database.rawQuery(sql);
    } else {
      await database.insert(
          'cartera_proveedores_det', cartera_proveedores_det.toMap());
    }
    return true;
  }

  //seccion recibo
  static Future getHistorialRecibo(
      String id_tipo_doc, fecha1, fecha2, search) async {
    Database database = await _openDB();

    var sql = " SELECT T.nombre_sucursal AS nombre ,T.TELEFONO,C.NUMERO, "
        " STRFTIME('%d/%m/%Y ', C.FECHA)  AS fecha,   C.TOTAL,  C.FLAG_ENVIADO "
        " FROM CARTERA_PROVEEDORES C "
        " INNER JOIN TERCERO T ON (T.ID_TERCERO = C.ID_TERCERO "
        " AND T.ID_SUCURSAL_TERCERO =C.ID_SUCURSAL_TERCERO) "
        " WHERE C.ID_TIPO_DOC ='${id_tipo_doc}' "
        " AND  date(FECHA) >= '$fecha1'  AND  date(FECHA)  <= '$fecha2' ";

    if (search != '@') {
      sql +=
          ' AND T.ID_TERCERO = "$search"   OR C.NUMERO = "$search" OR T.NOMBRE LIKE   "%$search%"  OR  T.NOMBRE_SUCURSAL LIKE  "%$search%" ';
    }

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  static Future getItemsAll(
      String nit, String idClasificacion, String search) async {
    Database database = await _openDB();

    var sql =
        " SELECT id_item, descripcion, id_unidad_compra,saldo_inventario from item  WHERE nit= '$nit' ";
    if (search == '@') {
      sql += " and id_clasificacion='$idClasificacion' ";
    } else {
      sql += ' AND  descripcion LIKE  "%$search%" ';
    }
    sql += ' ORDER BY descripcion ASC ';

    final res = await database.rawQuery(sql);
    if (res.isNotEmpty) {
      return res;
    } else {
      return false;
    }
  }

  //INSERTAR CARRITO  CARRITO
  static Future<bool> insertCarrito(
      Carrito carrito, CarritoDet carritodet) async {
    var nit = carrito.nit;
    var numero = carrito.numero;

    Database database = await _openDB();
    final res = await database.rawQuery(
        "SELECT * FROM carrito ");
    if (res.isEmpty) {
      print("INSERTA CARRITO  CARRITO $carrito");
      await database.insert('carrito', carrito.toMap());
    } else {
      print("ACTUALUIZA CARRITO  CARRITO  $carrito");
      await database.update('carrito', carrito.toMap(),
          where: " numero = ? and nit = ? ", whereArgs: [numero, nit]);
    }

    //insertar el detalle
    var idItem = carritodet.id_item;

    final resdet = await database.rawQuery(
        "SELECT * FROM carrito_detalle WHERE  numero = $numero AND nit = '$nit' AND id_item = '$idItem'");
    if (resdet.isEmpty) {
      print("INSERTA  CARRITO detalle  CARRITO detalle $numero $idItem");
      await database.insert('carrito_detalle', carritodet.toMap());
    } else {
      print("ACTUALUIZA CARRITO detalle  CARRITO detalle $numero $idItem");
      await database.update('carrito_detalle', carritodet.toMap(),
          where: " numero = ? and nit = ? and id_item = ?",
          whereArgs: [numero, nit, idItem]);
    }
    return true;
  }

  static Future<void> deleteProductoCarrito(String idItem) async {
    Database database = await _openDB();
    await database
        .delete("carrito_detalle", where: "id_item = ?", whereArgs: [idItem]);
  }

  /// Simple query with sqflite helper
  static Future<void> deleteCarrito() async {
    Database database = await _openDB();
    await database.rawQuery("DELETE FROM carrito ");
    await database.rawQuery("DELETE FROM carrito_detalle ");
  }

  /// Simple query with sqflite helper
  static Future getCarrito(nit, idtercero, numero, origen) async {
    Database database = await _openDB();

    var sql =
        "  SELECT nombre_sucursal, id_empresa, id_tipo_doc, id_suc_vendedor, "
        "  fecha,id_forma_pago,carrito.id_precio_item,id_direccion,orden_compra,id_direccion_factura,"
        "  carrito.id_tercero,carrito.numero,descripcion, id_item,precio, cast(cantidad as int) as cantidad,"
        "  carrito_detalle.total_dcto, dcto, carrito_detalle.id_precio_item, (precio * cantidad ) as total"
        "  FROM carrito_detalle ,carrito  where carrito.nit =  '$nit'  AND carrito.numero = $numero  ";
    if (!origen) {
      sql += " AND carrito.id_tercero ='$idtercero'  AND carrito.numero = $numero ";
    }
    final resdet = await database.rawQuery(sql);
    if (resdet.isNotEmpty) {
      return resdet;
    } else {
      return false;
    }
  }

  static Future<void> updateCantidad(String idItem, numero, bool incre) async {
    print("updateCantidad updateCantidad $incre");
    Database database = await _openDB();
    var sql = '';
    if (incre) {
      sql =
          "UPDATE carrito_detalle SET cantidad = cantidad +1  WHERE numero = $numero and id_item ='$idItem' ";
    } else {
      sql =
          "UPDATE carrito_detalle SET cantidad = cantidad -1  WHERE numero = $numero and id_item ='$idItem' ";
    }
    await database.rawQuery(sql);
  }

  static Future<void> updateCarritoG(numero, totalDcto, total, letras) async {
    Database database = await _openDB();
    final totalCosto = double.parse(total) + double.parse(totalDcto);
    var sql =
        "UPDATE carrito SET  total_costo='$totalCosto' ,  total_dcto = '$totalDcto',"
        "total= '$total',letras = '$letras'  WHERE numero = $numero ";
    await database.rawQuery(sql);
  }

  static Future<void> closeDB() async {
    Database database = await _openDB();
    await database.close();
  }
  
}
