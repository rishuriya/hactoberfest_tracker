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
  } else if(batch=="___Select___") {
    time="null";
    parcel.clear();
  }
  else
{
    parcel.clear();
    time="both";
    parcel = [Attendence("Name", "Email", "Morning", "Afternoon")];
  }
  return
      StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('hacktober-2022').snapshots(),
      builder: (context, snapshot) {
        if(time=="Morning-Session" || time=="Afternoon-Session") {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.active) {
            try {
              print(snapshot.data!.docs.length);
              for (var element in snapshot.data!.docs) {
                if (element[time] == "Attended") {
                  parcel.add(Attendence(element['Name'], element['Email'],
                      element['Morning-Session'],
                      element['Afternoon-Session']));
                }
              }
            } catch (e) {
              print(e);
            }
            print(parcel);
          }
        }else if (time=="both" && snapshot.data != null && snapshot.connectionState==ConnectionState.active) {
          try {
            print(snapshot.data!.docs.length);
            for (var element in snapshot.data!.docs) {
              if (element["Morning-Session"] == "Attended" && element["Afternoon-Session"]=="Attended") {
                parcel.add(Attendence(element['Name'], element['Email'],
                    element['Morning-Session'], element['Afternoon-Session']));
              }
            }

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
              horizontal: 30,
            ),
            child: Column(
              children: [
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
