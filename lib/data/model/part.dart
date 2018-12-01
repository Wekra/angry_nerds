import 'package:service_app/util/id_generator.dart';
import 'package:service_app/util/identifiable.dart';

class Part implements Identifiable {
  @override
  final String id;

  final String name;
  final String description;

  /// Price is stored in smallest unit, e.g. cents for Euro (no decimal values).
  final int price;

  final Currency currency;

  const Part._private(
      this.id, this.name, this.description, this.price, this.currency);

  Part(this.name, this.description, this.price, this.currency)
      : id = IdGenerator.generatePushChildName();

  static Part fromJsonMap(String id, Map<dynamic, dynamic> map) {
    return Part._private(
      id,
      map["name"],
      map["description"],
      map["price"],
      Currency.values.firstWhere((v) => v.toString() == map["currency"]),
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "currency": currency.toString(),
    };
  }
}

enum Currency { eur, usd }
