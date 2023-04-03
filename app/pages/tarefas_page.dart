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
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tarefaBloc = BlocProvider.of<TarefaBloc>(context);
    _tarefaBloc.add(GetTarefas());
    _tarefaBloc.stream.listen(
      (state) {
        if (state is TarefaErrorState) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
              width: 281,
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bloc Pattern'),
      ),
      body: Stack(
        children: [
          BlocBuilder<TarefaBloc, TarefaState>(
            bloc: _tarefaBloc,
            builder: (context, state) {
              if (state is TarefaInitialState) {
                return const Center(
                  child: Text('Empty'),
                );
              } else if (state is TarefaLoadingState) {
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
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: (width > 500) ? 490 : width - 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          offset: const Offset(0, -5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Type a text',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              //if (_nameController.text.isNotEmpty) {
                              _tarefaBloc.add(
                                PostTarefas(
                                  tarefa:
                                      TarefaModel(nome: _nameController.text),
                                ),
                              );
                              //}
                              _nameController.clear();
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tarefaBloc.close();
    _nameController.dispose();
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
