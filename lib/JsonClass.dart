class DatabaseJson {
  double lat, long;
  bool sos;
  String key;

  toJson() {
    return
    {
    "Latitude": lat, 
    "Longitude": long, 
    "SOS": sos, 
    };
  }
}
