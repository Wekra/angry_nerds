
import 'package:service_app/data/model/appointment.dart';
import 'package:firebase_database/firebase_database.dart';


/// Creates a new Appointment in firebase
class FirebaseAppointment {

  static Future<void> createAppointment(DatabaseReference ref, Appointment newAppointment) {
    var creation = new DateTime.now().millisecondsSinceEpoch.toString();

    /// TODO: Add parse passed Appointment as JSON using JSON serializer

      var dummyAppointment = {
        "created": creation,
        "description": "Fix the printer",
        "scheduled-start": "timestamp",
        "scheduled-end": "tiimestamp",
        "service-start": "null",
        "service-end": "null",
        "customer": "nike",
        "target": "should be target ID",
        "parts": [
          {"part-id-1": "part-id-1"}
        ]
      };
      return ref.push().set(dummyAppointment);
  }
}
