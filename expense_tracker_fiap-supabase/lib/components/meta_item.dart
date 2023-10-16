import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/meta.dart';
import '../models/transacao.dart';

class MetaItem extends StatelessWidget {
  final Meta meta;
  final void Function()? onTap;

  const MetaItem({Key? key, required this.meta, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepOrangeAccent,
        child: Icon(
          Icons.house,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(meta.descricao),
      subtitle: Text(DateFormat('MM/dd/yyyy').format(meta.data)),
      trailing: Text(
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.valor),
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.green),
      ),
      onTap: onTap,
    );
  }
}
