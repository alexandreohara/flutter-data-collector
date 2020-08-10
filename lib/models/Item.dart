import 'package:flutter/material.dart';

class Item extends ChangeNotifier {
  int id;
  String user; // usuário que está preenchendo os dados
  String cnpj; // cnpj da empresa do cliente
  String serialNumber; // número de série do produto (caso exista)
  String name; // placa antiga
  int number; // número novo
  String supplier; // fornecedor
  String model; // modelo
  String type; // categoria do produto
  String description; // descrição do produto
  String incidentState; // estado de uso
  String location; // localização
  String observations; // observações

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
