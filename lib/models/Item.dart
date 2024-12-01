import 'package:flutter/material.dart';

class Item extends ChangeNotifier {
  String? id;
  String? user; // usuário que está preenchendo os dados
  String? cnpj; // cnpj da empresa do cliente
  int? number; // número novo
  String? supplier; // fornecedor
  String? model; // modelo
  String? type; // categoria do produto
  String? description; // descrição do produto
  String? incidentState; // estado de uso
  String? location; // localização
  String? observations; // observações

  Item({
    this.id,
    this.user,
    this.cnpj,
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

  static List<String> getFields() => [
        'ID',
        'Número',
        'Fornecedor',
        'Modelo',
        'Tipo',
        'Descrição',
        'Estado',
        'Localização',
        'Observações',
        'Usuário',
      ];

  void setUserAndCNPJ(String user, String cnpj) {
    this.user = user;
    this.cnpj = cnpj;
    notifyListeners();
  }
}
