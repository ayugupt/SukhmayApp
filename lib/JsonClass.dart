class DatabaseJson {
  double lat, long;
  String mobileNumber;
  String key;

  toJson() {
    return {
      "Latitude": lat,
      "Longitude": long,
      "MobileNumber": mobileNumber,
    };
  }

  toJsonPosition() {
    return {
      "Latitude": lat,
      "Longitude": long,
    };
  }
}
