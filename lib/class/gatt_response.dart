class GattResponse {
  String? command;
  String? status;
  var payload;

  GattResponse({this.command, this.status, this.payload});

  factory GattResponse.fromJson(Map<String, dynamic> json) {
    return GattResponse(
      command: json['command'],
      status: json['status'],
      payload: json['payload'],
    );
  }
}
