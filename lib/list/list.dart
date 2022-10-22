import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hactoberfest_tracker/list/model.dart';
import 'package:flutter/material.dart';

List<Attendence> parcel = [Attendence("Name", "Email", "Morning", "Afternoon")];
var time;
Package_list(String batch) {
  if (batch == "Morning") {
    parcel.clear();
    time = "Morning-Session";
    parcel = [Attendence("Name", "Email", "Morning", "Afternoon")];
  } else if (batch == "Afternoon") {
    parcel.clear();
    time = "Afternoon-Session";
    parcel = [Attendence("Name", "Email", "Morning", "Afternoon")];
  } else {
    parcel.clear();
  }
  return
      StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hacktober-2022').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          try {
            print(snapshot.data!.docs.length);
            for (var element in snapshot.data!.docs) {
              if (element[time] == "Attended") {
                print("data");
                parcel.add(Attendence(element['Name'], element['Email'],
                    element['Morning-Session'], element['Afternoon-Session']));
              }
            }

          } catch (e) {
            print(e);
          }
          print(parcel);
        } else if (snapshot.data == null) {
          print("Empty");
        }
        if (snapshot.hasError) {
          print(snapshot.hasError);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: (parcel.length <= 11) ? parcel.length : 11,
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
