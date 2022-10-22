import 'dart:typed_data';
import 'package:flutter/material.dart';


class Attendence extends StatelessWidget {
  final String? student;
  final String? email;
  final String? morning;
  final String? afternoon;

  Attendence(this.student,
      this.email,
      this.morning,
      this.afternoon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xf2C86733).withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FutureBuilder(
              builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    isThreeLine: false,
                    title: Text(student!),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Padding(padding: EdgeInsets.only(top: 0),
                          child: Text(email!),),
                          Padding(padding: EdgeInsets.only(top: 0),
                            child: Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(top: 0, right: 12),
                                      child: Text("")
                                  ),
                                ]),)
                        ]),
                    trailing: Column(
                        children: [Padding(padding: EdgeInsets.only(top: 5),
                            child: Text("")),
                          Padding(padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black38),
                            ),),
                        ]),

                  ),
                );
              }
          ),
        )
    ); }



}