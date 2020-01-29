class Station {
  final String name, region;
  final int regionCode;
  final double lat, lon;
  Station({this.name, this.region, this.regionCode, this.lat, this.lon});

  factory Station.fromJson(Map<String, dynamic> json) {
    return new Station(
        name: json['name'] as String,
        region: json['region'] as String,
        regionCode: json['region_code'] as int,
        lat: json['lat'] as double,
        lon: json['lon'] as double);
  }
}
