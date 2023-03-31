import 'package:bloc_app/app/data/blocs/tarefa_event.dart';
import 'package:bloc_app/app/data/blocs/tarefa_state.dart';
import 'package:bloc_app/app/data/models/tarefa_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/blocs/tarefa_bloc.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  late final TarefaBloc _tarefaBloc;

  @override
  void initState() {
    super.initState();
    _tarefaBloc = TarefaBloc();
    _tarefaBloc.add(GetTarefas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bloc Pattern'),
      ),
      body: BlocBuilder<TarefaBloc, TarefaState>(
          bloc: _tarefaBloc,
          builder: (context, state) {
            if (state is TarefaLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TarefaLoadedState) {
              final list = state.tarefas;
              return Center(
                child: SizedBox(
                  width: 500,
                  child: Card(
                    child: ListView.separated(
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Center(
                              child: Text(
                                list[index].nome[0],
                              ),
                            ),
                          ),
                          title: Text(list[index].nome),
                          trailing: IconButton(
                            onPressed: () {
                              _tarefaBloc.add(
                                DeleteTarefa(
                                  tarefa: list[index],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _tarefaBloc.add(
            PostTarefas(
              tarefa:
                  TarefaModel(nome: 'Nova tarefa ${UniqueKey().toString()}'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _tarefaBloc.close();
    super.dispose();
  }
}

// WITHOUT BLOC AND BLOC_FLUTTER
// class _TarefasPageState extends State<TarefasPage> {
//   late final TarefaBloc _tarefaBloc;

//   @override
//   void initState() {
//     super.initState();
//     _tarefaBloc = TarefaBloc();
//     _tarefaBloc.inputTarefa.add(GetTarefas());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Bloc Pattern'),
//       ),
//       body: StreamBuilder<TarefaState>(
//           stream: _tarefaBloc.outputTarefa,
//           builder: (context, state) {
//             if (state.data is TarefaLoadingState) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (state.data is TarefaLoadedState) {
//               final list = state.data?.tarefas ?? [];
//               return ListView.separated(
//                 separatorBuilder: (_, __) => const Divider(),
//                 itemCount: list.length,
//                 itemBuilder: (_, index) {
//                   return ListTile(
//                     leading: CircleAvatar(
//                       child: Center(
//                         child: Text(
//                           list[index].nome[0],
//                         ),
//                       ),
//                     ),
//                     title: Text(list[index].nome),
//                     trailing: IconButton(
//                       onPressed: () {
//                         _tarefaBloc.inputTarefa.add(
//                           DeleteTarefa(
//                             tarefa: list[index],
//                           ),
//                         );
//                       },
//                       icon: Icon(
//                         Icons.delete,
//                         color: Theme.of(context).colorScheme.error,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const Center(
//                 child: Text('Error'),
//               );
//             }
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _tarefaBloc.inputTarefa.add(
//             PostTarefas(
//               tarefa: TarefaModel(nome: 'Fazer caminhada'),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tarefaBloc.inputTarefa.close();
//     super.dispose();
//   }
// }
