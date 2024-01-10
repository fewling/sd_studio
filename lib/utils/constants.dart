enum Month {
  jan('January', 'Jan'),
  feb('February', 'Feb'),
  mar('March', 'Mar'),
  apr('April', 'Apr'),
  may('May', 'May'),
  jun('June', 'Jun'),
  jul('July', 'Jul'),
  aug('August', 'Aug'),
  sep('September', 'Sep'),
  oct('October', 'Oct'),
  nov('November', 'Nov'),
  dec('December', 'Dec');

  const Month(this.full, this.short);
  final String full;
  final String short;
}

enum TimeOption {
  morning('Morning'),
  afternoon('Afternoon'),
  evening('Evening'),
  allDay('All day'),
  overnight('Overnight'),
  toBeDecided('To be decided');

  const TimeOption(this.label);

  final String label;
}

enum RunPodResponseStatus {
  inQueue('IN_QUEUE'),
  inProgress('IN_PROGRESS'),
  failed('FAILED'),
  cancelled('CANCELLED'),
  timedOut('TIMED_OUT'),
  completed('COMPLETED');

  const RunPodResponseStatus(this.value);
  final String value;
}

RunPodResponseStatus statusFromJson(String value) {
  for (final v in RunPodResponseStatus.values) {
    if (v.value == value) return v;
  }

  throw ArgumentError.value(value, 'value', 'Invalid RunPodResponseStatus');
}

String statusToJson(RunPodResponseStatus instance) => instance.value;
