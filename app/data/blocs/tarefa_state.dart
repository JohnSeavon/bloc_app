import '../models/tarefa_model.dart';

abstract class TarefaState {
  // é criado todos os estados que a aplicação pode ter
  final List<TarefaModel> tarefas;

  TarefaState({required this.tarefas});
}

class TarefaInitialState extends TarefaState {
  TarefaInitialState() : super(tarefas: []);
}

class TarefaLoadingState extends TarefaState {
  TarefaLoadingState() : super(tarefas: []);
}

class TarefaLoadedState extends TarefaState {
  TarefaLoadedState({required List<TarefaModel> tarefas})
      : super(tarefas: tarefas);
}

class TarefaErrorState extends TarefaState {
  final String message;
  TarefaErrorState({required this.message}) : super(tarefas: []);
}
