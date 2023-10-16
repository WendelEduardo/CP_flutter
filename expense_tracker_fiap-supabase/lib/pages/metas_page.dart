

import 'package:expense_tracker/components/meta_item.dart';
import 'package:expense_tracker/models/meta.dart';
import 'package:expense_tracker/pages/meta_cadastro_page.dart';
import 'package:expense_tracker/repository/metas_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MetasPage extends StatefulWidget {
  const MetasPage({super.key});

  @override
  State<MetasPage> createState() => _MetasPageState();
}

class _MetasPageState extends State<MetasPage> {

  final metasRepo = MetasReepository();
  late Future<List<Meta>> futureMetas;
  User? user;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;
    // futureMetas = metasRepo.listarMetas(userId: user?.id ?? '');
    futureMetas = metasRepo.listarMetas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas'),
      ),

      body: FutureBuilder<List<Meta>>(
        future: futureMetas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar as metas"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhuma meta cadastrada"),
            );
          } else {
            final metas = snapshot.data!;
            return ListView.separated(
              itemCount: metas.length,
              itemBuilder: (context, index) {
                final meta = metas[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MetaCadastroPage(
                                metaParaEdicao: meta,
                              ),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              futureMetas = metasRepo.listarMetas();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await metasRepo.excluirMeta(meta.id);

                          setState(() {
                            metas.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                    ],
                  ),
                  child: MetaItem(
                    meta: meta,
                    onTap: () {
                      Navigator.pushNamed(context, '/meta-detalhes',
                          arguments: meta);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "meta-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/meta-cadastro')
                  as bool?;

          if (result == true) {
            setState(() {
              futureMetas = metasRepo.listarMetas(
                
              );
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}