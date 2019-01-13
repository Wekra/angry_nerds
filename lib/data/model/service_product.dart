import 'package:service_app/data/model/customer.dart';
import 'package:service_app/util/base_entity.dart';
import 'package:service_app/util/id_generator.dart';

class ServiceProduct implements BaseEntity {
  @override
  final String number;
  final String serialNumber;

  final String name;
  final String description;
  final DateTime purchaseDate;
  final Customer customer;

  const ServiceProduct._private(this.number, this.serialNumber, this.name, this.description, this.purchaseDate, this.customer);

  ServiceProduct(this.serialNumber, this.name, this.description, this.purchaseDate, this.customer) : number = IdGenerator.generatePushChildName();

  static ServiceProduct fromJsonMap(String number, Map<dynamic, dynamic> map) {
    return ServiceProduct._private(
      number,
      map["serialNumber"],
      map["name"],
      map["description"],
      DateTime.parse(map["purchaseDate"]),
      Customer.fromJsonMap("id",map["customer"])
    );
  }

  @override
  Map<String, dynamic> toJsonMap() {
    return {
      "serialNumber": serialNumber,
      "name": name,
      "description": description,
      "purchaseDate" : purchaseDate,
      "customer": customer
    };
  }
}

