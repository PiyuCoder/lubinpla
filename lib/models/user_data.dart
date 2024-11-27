class UserData {
  String surname;
  String name;
  String phone;
  String password;
  String email;
  String company;
  String position;
  String invitationCode;
  Map<String, bool> consents;

  UserData({
    this.surname = '',
    this.name = '',
    this.phone = '',
    this.password = '',
    this.email = '',
    this.company = '',
    this.position = '',
    this.invitationCode = '',
    Map<String, bool>? consents,
  }) : consents = consents ??
            {
              'terms_of_service': false,
              'privacy_policy': false,
              'marketing_info': false,
              'event_notifications': false,
            };
}
