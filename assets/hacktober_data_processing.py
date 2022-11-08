from dataclasses import field
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import csv
# Use a service account.
cred = credentials.Certificate('hacktober-attendence-firebase-adminsdk-yoj89-edc5ab0a98.json')

app = firebase_admin.initialize_app(cred)
fieldnames = [ "id", "Name", "Email","Morning-Session","Morning-checkin","Afternoon-Session","Afternoon-checkin"]
db = firestore.client()
users_ref = db.collection(u'hacktober-2022')
docs = users_ref.stream()
lis=[]
for doc in docs:
    dict=doc.to_dict()
    try:
        lis.append(dict)
    except:
        print(doc.id)
print(lis[3])

with open('Attendence.csv', 'w', encoding='UTF8', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(lis)