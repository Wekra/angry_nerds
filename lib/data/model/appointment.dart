class Appointment {
  final int id;
  final String description;
  final DateTime scheduledStartTime;
  final DateTime scheduledEndTime;
  final DateTime creationTime;
  final List<AppointmentInterval> intervals;

  const Appointment(
      this.id, this.description, this.scheduledStartTime, this.scheduledEndTime, this.creationTime, this.intervals);
}

class AppointmentInterval {
  final int id;
  final DateTime startTime;
  final DateTime endTime;

  const AppointmentInterval(this.id, this.startTime, this.endTime);
}
