import 'package:flutter/material.dart';

class Item extends ChangeNotifier {
  int id;
  String user;
  String cnpj;
  String serialNumber;
  String name;
  int number;
  String supplier;
  String model;
  String type;
  String description;
  String incidentState;
  String location;
  String observations;

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
