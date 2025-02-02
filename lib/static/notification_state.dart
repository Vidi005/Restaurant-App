enum NotificationState {
  enable,
  disable;

  get isEnable => this == NotificationState.enable;
}

extension BoolExtension on bool {
  NotificationState get isEnable =>
      this == true ? NotificationState.enable : NotificationState.disable;
}
