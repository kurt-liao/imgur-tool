class FormData {
  final String access_token;

  FormData(this.access_token);

  FormData.fromJson(Map<String, dynamic> json)
      : access_token = json['access_token'];

  Map<String, dynamic> toJson() => {'access_token': access_token};
}
