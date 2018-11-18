class Appointment {
  final String description;
  final DateTime scheduledStartTime;
  final DateTime scheduledEndTime;
  final DateTime creationTime;
  final DateTime startTime;
  final DateTime endTime;

  const Appointment(
      this.description,
      this.scheduledStartTime,
      this.scheduledEndTime,
      this.creationTime,
      this.startTime,
      this.endTime);
}
