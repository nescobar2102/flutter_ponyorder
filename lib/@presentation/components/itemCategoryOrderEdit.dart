import 'package:flutter/material.dart';

class ItemCategoryOrderEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Color(0xffc7c7c7)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Arroz La Gran Nona Tradicional 5 kg',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
                Icon(
                  Icons.do_disturb_on,
                  color: Color(0xffCB1B1B),
                  size: 20.0,
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.label_important,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Precio unidad',
                            style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('\$ 14.250',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_box,
                            color: Color(0xff707070),
                            size: 15.0,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: _size.width * 0.5 - 60,
                            child: Text(
                              'Unidades disponibles',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text('286',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: _size.width * 0.5 - 40,
                      child: Text(
                        'Cantidad',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                        width: _size.width * 0.5 - 40,
                        child: Container(
                          width: _size.width,
                          height: 30.0,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 35.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(15.0))),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Color(0xffC7C7C7)),
                                  color: Colors.white,
                                ),
                                width: _size.width * 0.5 - 110,
                                height: 30.0,
                                child: Center(
                                    child: Text(
                                  '001',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w300),
                                )),
                              ),
                              Container(
                                width: 35.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15.0),
                                        bottomRight: Radius.circular(15.0))),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'Lista de precios',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700),
                ),
                // SizedBox(height: 5.0,),
                _itemForm(context, 'Seleccione minorista'),
                SizedBox(height: 10.0),
                Text(
                  'Descuento',
                  style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700),
                ),
                _itemForm(context, 'Ingrese descuento'),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _itemForm(BuildContext context, String hintText) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      child: TextField(
        style: TextStyle(
          color: Color(0xff707070),
          fontSize: 14.0,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color(0xff707070),
            fontSize: 14.0,
          ),
          contentPadding: EdgeInsets.only(bottom: 0, top: 0),
        ),
      ),
    );
  }
}
