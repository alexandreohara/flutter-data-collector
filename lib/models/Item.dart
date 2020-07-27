import 'package:data_collector/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class Item {
  final int id;
  final String user;
  final String cnpj;
  final String serialNumber;
  final String name;
  final int number;
  final String supplier;
  final String model;
  final String type;
  final String description;
  final String incidentState;
  final String location;
  final String observations;

  Item({
    this.id,
    this.user,
    this.cnpj,
    this.serialNumber,
    this.name,
    this.number,
    this.supplier,
    this.model,
    this.type,
    this.description,
    this.incidentState,
    this.location,
    this.observations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'cnpj': cnpj,
      'serialNumber': serialNumber,
      'name': name,
      'number': number,
      'supplier': supplier,
      'model': model,
      'type': type,
      'description': description,
      'incidentState': incidentState,
      'location': location,
      'observations': observations, 
    };
  }
}
