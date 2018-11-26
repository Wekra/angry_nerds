import 'package:service_app/data/model/part.dart';
import 'package:test/test.dart';

void main() {
  String name = "Cable";
  String description = "Some specified cable";
  int price = 353;

  test("Constructor returns an object", () {
    var part = new Part(name, description, price, Currency.eur);
    expect(part, isNotNull);
  });

  test("Getters work as expected", () {
    var part = new Part(name, description, price, Currency.eur);

    expect(part.name, equals(name));
    expect(part.description, equals(description));
    expect(part.price, equals(price));
    expect(part.currency, Currency.eur);
    expect(part.id, isNotNull);
    expect(part.id, isNotEmpty);
  });
}
