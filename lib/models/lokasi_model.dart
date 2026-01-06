class LokasiMotor {
  final double latitude;
  final double longitude;
  final bool engineOn;
  final bool moving;
  final double speed;

  LokasiMotor({
    required this.latitude,
    required this.longitude,
    required this.engineOn,
    required this.moving,
    required this.speed,
  });

  factory LokasiMotor.fromJson(Map<String, dynamic> json) {
    return LokasiMotor(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),

      /// 🔑 FIX DI SINI
      engineOn: json['engine'].toString().toUpperCase() == "ON",

      moving: json['moving'] ?? false,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
