import 'package:app_pony_order/@presentation/components/btnSmall.dart';
import 'package:flutter/material.dart';

class ItemDocumentClient extends StatefulWidget {
  final VoidCallback callback;

  const ItemDocumentClient({required this.callback});

  @override
  State<ItemDocumentClient> createState() => _ItemDocumentClientState();
}

class _ItemDocumentClientState extends State<ItemDocumentClient> {
  bool _pay = false;
  bool _confirm = false;
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Color(0xffE8E8E8),
              borderRadius: BorderRadius.circular(6.0)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 42,
                      child: Text('Tipo:', style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(
                      width: _size.width * 0.5 - 42,
                      child: Text('F02', style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                      ),),
                    )
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 42,
                      child: Text('Número:', style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(
                      width: _size.width * 0.5 - 42,
                      child: Text('62443', style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                      ),),
                    )
                  ],
                ),
                SizedBox(height: 10.0,),
                Row(
                  children: [
                    SizedBox(
                      width: _size.width * 0.5 - 42,
                      child: Text('Saldo:', style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    SizedBox(
                      width: _size.width * 0.5 - 42,
                      child: Text('\$ 347.281', style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: 13.0,
                      ),),
                    )
                  ],
                ),
                SizedBox(height: 10.0,),
                !_pay && !_confirm ? noPay(context) : Container(),
                _pay ? pay(context) : Container(),
                _confirm ? confirm(context) : Container()
              ],
            ),
          );
  }
  
  Widget noPay(BuildContext context){
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Días:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('3', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Cuota:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('1', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Vencimiento:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('09/10/21', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 20.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: BtnSmall(text: 'Pagar', color: Color(0xff0894FD), callback: (){ setState(() {
                _pay = true;
              });})
            ),
          ],
        ),
      ],
    );
  }

  Widget pay(BuildContext context){
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Días:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('3', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Cuota:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('1', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Vencimiento:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('09/10/21', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Valor a pagar:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('\$ 347.281', 
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                decoration: TextDecoration.underline
              ),),
            )
          ],
        ),
        SizedBox(height: 20.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 62,
              child: BtnSmall(text: 'Cancelar', color: Color(0xffCB1B1B), callback: (){
                setState(() {
                  _pay = false;
                });
              })
            ),
            SizedBox(width: 40.0,),
            SizedBox(
              width: _size.width * 0.5 - 62,
              child: BtnSmall(text: 'Confirmar', color: Color(0xff0894FD), callback: (){
                setState(() {
                  _pay = false;
                  _confirm = true;
                });
              })
            ),
          ],
        ),
      ],
    );
  }

  Widget confirm(BuildContext context){
    final _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Abono:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('\$ 347.281', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Restante:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('\$ 102.351', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Días:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('3', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Cuota:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('1', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('Vencimiento:', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
                fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              width: _size.width * 0.5 - 42,
              child: Text('09/10/21', style: TextStyle(
                color: Color(0xff707070),
                fontSize: 13.0,
              ),),
            )
          ],
        ),
        SizedBox(height: 20.0,),
        Row(
          children: [
            SizedBox(
              width: _size.width * 0.5 - 62,
              child: BtnSmall(text: 'Reestablecer', color: Color(0xffCB1B1B), callback: (){
                setState(() {
                  _confirm = false;
                  _pay = true;
                });
              })
            ),
            SizedBox(width: 40.0,),
            SizedBox(
              width: _size.width * 0.5 - 62,
              child: BtnSmall(text: 'Pagar', color: Color(0xff707070), callback: (){})
            ),
          ],
        ),
      ],
    );
  }
}
