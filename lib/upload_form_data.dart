class UploadFormData {
  final String access_token;

  UploadFormData(this.access_token);

  UploadFormData.fromJson(Map<String, dynamic> json)
      : access_token = json['access_token'];

  Map<String, dynamic> toJson() => {'access_token': access_token};
}
