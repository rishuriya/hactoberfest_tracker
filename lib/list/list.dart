import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hactoberfest_tracker/list/model.dart';
import 'package:flutter/material.dart';
int Total_attendee=0;
List<Attendence> parcel = [Attendence("Name", "Email", "RollNo", "WhatsappNo")];
var criteria;
Package_list(int batch,String date) {
  print(batch);
  if (batch == 0) {
    parcel.clear();
    criteria = true;
    parcel = [Attendence("Name", "Email", "RollNo", "WhatsappNo")];
  } else if (batch == 1) {
    parcel.clear();
    criteria = false;
    parcel = [Attendence("Name", "Email", "RollNo", "WhatsappNo")];
  } else if(batch==2) {
    criteria="All";
    parcel.clear();
    parcel = [Attendence("Name", "Email", "RollNo", "WhatsappNo")];
  }
  return
      StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('workshop-2022').snapshots(),
      builder: (context, snapshot) {
        if(batch<2) {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.active) {
            try {
              print(snapshot.data!.docs.length);
              for (var element in snapshot.data!.docs) {
                print(element["09-11-2022"]);
                print("sfjhhd");
                print(element["Date"]['09-11-2022']);
                if (element["date"] == criteria) {
                  parcel.add(Attendence(element['Name'], element['Email'],
                      element['RollNo'],
                      element['WhatsappNo']));
                }
              }

            } catch (e) {
              print(e);
            }
            Total_attendee=parcel.length-1;
            //print(Total_attendee);
            print(parcel);
          }
        }else if (batch==2 && snapshot.data != null && snapshot.connectionState==ConnectionState.active) {
          try {
            print(snapshot.data!.docs.length);
            for (var element in snapshot.data!.docs) {
                parcel.add(Attendence(element['Name'], element['Email'],
                    element['RollNo'], element['WhatsappNo']));
            }
            Total_attendee=parcel.length-1;

          } catch (e) {
            print(e);
          }
        }else if(snapshot.data==null)
          {
            print("No data");
          }
        if (snapshot.hasError) {
          print(snapshot.hasError);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                Container(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child:Text("Count: ${Total_attendee==null?0.toString():Total_attendee!.toString()}"),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (parcel.length <= 11) ? parcel.length : parcel.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: (snapshot.data != null)
                          ? ([
                              Attendence(
                                parcel[index].student,
                                parcel[index].email,
                                parcel[index].morning,
                                parcel[index].afternoon,
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ])
                          : ([
                              const Text(
                                "",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              CircularProgressIndicator()
                            ]),
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ));
      });
}
