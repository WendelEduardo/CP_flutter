import 'package:expense_tracker/components/categoria_select.dart';
import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/models/transacao.dart';
import 'package:expense_tracker/pages/categorias_select_page.dart';
import 'package:expense_tracker/pages/contas_select_page.dart';
import 'package:expense_tracker/repository/metas_repository.dart';
import 'package:expense_tracker/repository/transacoes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/conta_select.dart';
import '../models/conta.dart';





class MetaCadastroPage extends StatefulWidget {
  final Meta? metaParaEdicao;

  const MetaCadastroPage({super.key, this.metaParaEdicao});

  @override
  State<MetaCadastroPage> createState() => _TransacaoCadastroPageState();
}

class _TransacaoCadastroPageState extends State<MetaCadastroPage> {
  
  User? user;
  final metasRepo = MetasReepository();

  final descricaoController = TextEditingController();
  final valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final dataController = TextEditingController();

  final detalhesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


@override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final meta = widget.metaParaEdicao;

    if (meta != null) {
      descricaoController.text = meta.descricao;
      valorController.text = NumberFormat.simpleCurrency(locale: 'pt_BR').format(meta.valor);
      dataController.text = DateFormat('MM/dd/yyyy').format(meta.data);
      detalhesController.text = meta.detalhes;
      // iconeSelecionado = meta.icone;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de metas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescricao(),
                const SizedBox(height: 30),
                _buildValor(),
                const SizedBox(height: 30),
                _buildData(),
                const SizedBox(height: 30),
                _buildDetalhes(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição de sua meta',
        labelText: 'Descrição',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 5 || value.length > 30) {
          return 'A Descrição deve entre 5 e 30 caracteres';
        }
        return null;
      },
    );
  }



  TextFormField _buildValor() {
    return TextFormField(
      controller: valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor que deseja alcançar',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
      },
    );
  }


TextFormField _buildData() {
    return TextFormField(
      controller: dataController,
      keyboardType: TextInputType.none,
      decoration: const InputDecoration(
        hintText: 'Informe uma Data para alcançar sua meta',
        labelText: 'Data',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.calendar_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Data';
        }

        try {
          DateFormat('dd/MM/yyyy').parse(value);
        } on FormatException {
          return 'Formato de data inválida';
        }

        return null;
      },
      onTap: () async {
        //FocusScope.of(context).requestFocus(FocusNode());

        DateTime? dataSelecionada = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime(2100),
        );

        if (dataSelecionada != null) {
          dataController.text =
              DateFormat('dd/MM/yyyy').format(dataSelecionada);
        }
      },
    );
  }

   TextFormField _buildDetalhes() {
    return TextFormField(
      controller: detalhesController,
      decoration: const InputDecoration(
        hintText: 'Detalhes da meta',
        labelText: 'Detalhes',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            // Data
            final data = DateFormat('dd/MM/yyyy').parse(dataController.text);
            // Descricao
            final descricao = descricaoController.text;
            // Valor
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorController.text.replaceAll('R\$', ''));
            // Detalhes
            final detalhes = detalhesController.text;

            final userId = user?.id ?? '';

            final meta = Meta(
              id: 0,
              userId: userId,
              descricao: descricao,
              valor: valor.toDouble(),
              data: data,
              detalhes: detalhes,
            );

            if (widget.metaParaEdicao == null) {
              await _cadastrarMeta(meta);
            } else {
              meta.id = widget.metaParaEdicao!.id;
              await _alterarMeta(meta);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }


  Future<void> _cadastrarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metasRepo.cadastrarMeta(meta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Meta cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao cadastrar meta',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarMeta(Meta meta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await metasRepo.alterarMeta(meta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Meta alterada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar meta',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}