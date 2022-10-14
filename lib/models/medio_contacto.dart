import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart'; 

//Clase del modelo de mediocontacto

class MedioContacto { 
 
  final String id_medio_contacto;
  final String descripcion; 
  final String nit; 

  const MedioContacto(
      {required this.id_medio_contacto,
      required this.descripcion, 
      required this.nit
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_medio_contacto': id_medio_contacto,
      'descripcion': descripcion, 
      'nit': nit
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'MedioContacto {id_medio_contacto: $id_medio_contacto, descripcion: $descripcion, nit: $nit }';
  }
}


class TipoIdentificacion { 
 
  final String id_tipo_identificacion;
  final String descripcion;  

  const TipoIdentificacion(
      {required this.id_tipo_identificacion,
      required this.descripcion
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_tipo_identificacion': id_tipo_identificacion,
      'descripcion': descripcion 
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'TipoIdentificacion {id_tipo_identificacion: $id_tipo_identificacion, descripcion: $descripcion  }';
  }
}



class TipoEmpresa { 
 
  final String id_tipo_empresa;
  final String descripcion;  
  final String nit;  

  const TipoEmpresa(
      {required this.id_tipo_empresa,
       required this.descripcion,
       required this.nit
       });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id_tipo_empresa': id_tipo_empresa,
      'descripcion': descripcion,
       'nit': nit 
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'TipoEmpresa {id_tipo_empresa: $id_tipo_empresa, descripcion: $descripcion ,nit: $nit  }';
  }
}
