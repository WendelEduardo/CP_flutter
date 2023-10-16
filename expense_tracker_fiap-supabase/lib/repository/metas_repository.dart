


import 'dart:io';
import 'dart:math';

import 'package:expense_tracker/models/meta.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetasReepository {

  Future<List<Meta>> listarMetas() async{

      final supabase = Supabase.instance.client;
      final data = await supabase.from('metas').select<List<Map<String, dynamic>>>();

      print(data);

      final listaDeMetas = data.map((e) => Meta.fromMap(e)).toList();

      return listaDeMetas;
  }

  Future cadastrarMeta(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('metas').insert({
      'descricao': meta.descricao,
      'user_id': meta.userId,
      'valor': meta.valor,
      'data_meta': meta.data.toIso8601String(),
      'detalhes': meta.detalhes,
    });
  }


  Future alterarMeta(Meta meta) async {
    final supabase = Supabase.instance.client;

    await supabase.from('transacoes').update({
      'descricao': meta.descricao,
      'user_id': meta.userId,
      'valor': meta.valor,
      'data_meta': meta.data.toIso8601String(),
      'detalhes': meta.detalhes,
    }).match({'id': meta.id});
  }

  Future excluirMeta(int id) async {
    final supabase = Supabase.instance.client;

    await supabase.from('metas').delete().match({'id': id});
  }
  
}