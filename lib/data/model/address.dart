class Address {
  final String id;
  final String street;
  final String houseNumber;
  final String zip;
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const Address(
      this.id, this.street, this.houseNumber, this.zip, this.city, this.country, this.latitude, this.longitude);

  static Address fromJsonMap(String id, Map<String, dynamic> map) {
    return Address(
        id,
        map["street"],
        map["houseNumber"],
        map["zip"],
        map["city"],
        map["country"],
        map["latitude"],
        map["longitude"]
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "street": street,
      "houseNumber": houseNumber,
      "zip": zip,
      "city": city,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
