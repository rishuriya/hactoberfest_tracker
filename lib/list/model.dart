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
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FutureBuilder(
              builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left:3,
                    right:3,
                    top: 10,
                    bottom: 10
                  ),
                  child: ListTile(
                    isThreeLine: false,
                    title: Text(student!),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Padding(padding: EdgeInsets.only(top: 0),
                          child: Text(""),),
                          Padding(padding: EdgeInsets.only(top: 0),
                            child: Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(top: 0, right: 12),
                                      child: Text(email!)
                                  ),
                                ]), )
                        ]),


                  ),
                );
              }
          ),
        )
    ); }

}