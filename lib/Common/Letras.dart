
class LetraN {

///////////////////////////


  static Future<String> convertirLetras(num) async {
 
    try {
      var txtEspanol = numeroALetras(num);
    
      return Future.value(txtEspanol);
    } catch (e) {
  
    }
    return '';
  }

 static numeroALetras(n){
  
    var numero = n;

    var respuesta = '';

    if (double.parse(numero) > 999) {
   
      if (numero.length > 6) {

        var residuo  =int.parse(numero)%1000000;
        var x  = int.parse(numero)/1000000;

        if (x == 1) {
          respuesta = ' UN MILLON ' + numeroALetras(residuo);
        } else {
          respuesta = numeroALetras(x) + ' MILLONES ' + numeroALetras(residuo);
        }
      }else if (numero.length > 3) {
        var residuo  = int.parse(numero)%1000;
        var x  = int.parse(numero)/1000;

        if (x == 1) {
          respuesta = ' MIL' + numeroALetras(residuo);
        } else {
          respuesta = numeroALetras(x) + ' MIL ' + numeroALetras(residuo);
        }
      }
    } else {
      if (numero == 100) {
        respuesta = 'CIEN';
      }else if (numero > 100) {
        var cen = int.parse(numero)/100;
        var dec = int.parse(numero) % 100;

        respuesta = ' ' + centenas_nal(cen) + ' ' + numeroALetras(dec);
      }else{
        var dec = int.parse(numero) % 100;

        if (dec < 20) {
          respuesta = ' ' + unidades_nal(dec);
        } else {
          var unis = dec%10;
          var ddec = dec/10;

          if (unis != 0) {
            respuesta = ' ' + decenas_nal(ddec) + ' Y ' + unidades_nal(unis);
          } else {
            respuesta = ' ' + decenas_nal(ddec);
          }
        }
      }
    }

    return respuesta;
  }

  static unidades_nal(n){
    var letra ='';
    switch (n) {
      case '1':
        letra = 'UNO';
        break; // The switch statement must be told to exit, or it will execute every case.
      case '2':
        letra = 'DOS';
        break;
      case '3':
        letra = 'TRES';
        break;
      case '4':
        letra = 'CUATRO';
        break;
      case '5':
        letra = 'CINCO';
        break;
      case '6':
        letra = 'SEIS';
        break;
      case '7':
        letra = 'SIETE';
        break;
      case '8':
        letra = 'OCHO';
        break;
      case '9':
        letra = 'NUEVE';
        break;
      case '10':
        letra = 'DIEZ';
        break;
      case '11':
        letra = 'ONCE';
        break;
      case '12':
        letra = 'DOCE';
        break;
      case '13':
        letra = 'TRECE';
        break;
      case '14':
        letra = 'CATORCE';
        break;
      case '15':
        letra = 'QUINCE';
        break;
      case '16':
        letra = 'DIECISEIS';
        break;
      case '17':
        letra = 'DIECISIETE';
        break;
      case '18':
        letra = 'DIECIOCHO';
        break;
      case '19':
        letra = 'DIECINUEVE';
        break;
    }

    return letra;
  }

  static decenas_nal(n){
    var letra ='';
    switch (n) {
      case '1':
        letra = 'DIEZ';
        break; // The switch statement must be told to exit, or it will execute every case.
      case '2':
        letra = 'VEINTE';
        break;
      case '3':
        letra = 'TREINTA';
        break;
      case '4':
        letra = 'CUARENTA';
        break;
      case '5':
        letra = 'CINCUENTA';
        break;
      case '6':
        letra = 'SESENTA';
        break;
      case '7':
        letra = 'SETENTA';
        break;
      case '8':
        letra = 'OCHENTA';
        break;
      case '9':
        letra = 'NOVENTA';
        break;
    }

    return letra;
  }

  static centenas_nal(n){
    var letra ='';
    switch (n) {
      case '1':
        letra = 'CIENTO';
        break; // The switch statement must be told to exit, or it will execute every case.
      case '2':
        letra = 'DOCIENTOS';
        break;
      case '3':
        letra = 'TRECIENTOS';
        break;
      case '4':
        letra = 'CUATROCIENTOS';
        break;
      case '5':
        letra = 'QUINIENTOS';
        break;
      case '6':
        letra = 'SEISCIENTOS';
        break;
      case '7':
        letra = 'SETECIENTOS';
        break;
      case '8':
        letra = 'OCHOCIENTOS';
        break;
      case '9':
        letra = 'NOVECIENTOS';
        break;
    }

    return letra;
  }
}