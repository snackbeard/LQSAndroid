class ControllerEsp {
  int objectId;
  String name;

  ControllerEsp({
    required this.objectId,
    required this.name
  });

  factory ControllerEsp.fromJson(Map<String, dynamic> json) {
    return ControllerEsp(
      objectId: json['objectId'],
      name: json['name']
    );
  }

}