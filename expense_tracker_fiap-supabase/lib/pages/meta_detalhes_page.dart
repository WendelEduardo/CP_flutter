import 'package:expense_tracker/components/conta_item.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/models/transacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tipo_transacao.dart';

class MetaDetalhesPage extends StatefulWidget {
  const MetaDetalhesPage({super.key});

  @override
  State<MetaDetalhesPage> createState() => _MetaDetalhesPageState();
}

class _MetaDetalhesPageState extends State<MetaDetalhesPage> {

  @override
  Widget build(BuildContext context) {
    final meta = ModalRoute.of(context)!.settings.arguments as Meta;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(meta.descricao),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Valor'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(meta.valor)),
            ),
            ListTile(
              title: const Text('Data do Lançamento'),
              subtitle: Text(DateFormat('MM/dd/yyyy').format(meta.data)),
            ),
            ListTile(
              title: const Text('Observação'),
              subtitle:
                  Text(meta.detalhes.isEmpty ? '-' : meta.detalhes),
            ),
          ],
        ),
      ),
    );
  }
}
