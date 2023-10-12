
# Attendance Tracker

This Project is used to track Attendance of participant in hacktoberfest and amFOSS workshops. A qr code will be scan which will be verify in the database that it exist or not, if it exist, App provide a green signal and attendance to particiapants else it will deny the entry of other who doesnt have valid QR code.


## Screenshots

<table border="0">
  <tr>
    <td>
<img src="https://user-images.githubusercontent.com/85174423/227800498-0ef047ce-fdc1-49a5-ac7e-08223827c7b4.jpg" height="20%" width="300"/>
    </td>
    <td>
<img src="https://user-images.githubusercontent.com/85174423/227800528-03cdbc22-60af-40df-b138-260476e56541.jpg" height="20%" width="300"/>
    </td>
    <td>
<img src="https://user-images.githubusercontent.com/85174423/227800625-42bd2d8f-2364-4ba6-9ffd-527ec8ec3e78.jpg" height="20%" width="300"/>
    </td>
  </tr>
  </table>

## Deployment

To deploy this project,  

```bash
  Clone the repo
```
Go to the firebase,

```bash
  create a project -> android app
```

```bash
  Genrate google-service.json
```
```bash
  Create firestor database Collection "hacktoberfest-2023"
```
```bash
  put json in android->app directory
```

In the Terminal of root folder of project, give command
```bash
  flutter pub get
```

```bash
  flutter run
```

## Used By

This project is used by the Organization:

- [amFOSS](https://gitlab.com/amfoss)


