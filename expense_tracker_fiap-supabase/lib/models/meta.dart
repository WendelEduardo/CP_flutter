import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Meta {
  int id;
  String userId;
  String descricao;
  double valor;
  DateTime data;
  String detalhes = '';
  // IconData icone;

  Meta({
    required this.id,
    required this.userId,
    required this.descricao,
    required this.valor,
    required this.data,
    this.detalhes = '',
    // required this.icone,
  });

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      id: map['id'],
      userId: map['user_id'],
      descricao: map['descricao'],
      valor: map['valor'],
      data: DateTime.parse(map['data_meta']),
      detalhes: map['detalhes'] ?? '',
      // icone: IoniconsData(map['icone']),
    );
  }
}
