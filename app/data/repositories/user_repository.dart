import 'package:bloc_app/app/data/models/tarefa_model.dart';

class TarefaRepository {
  final List<TarefaModel> _tarefas = [];

  Future<List<TarefaModel>> getTarefas() async {
    _tarefas.addAll([
      TarefaModel(nome: 'Tarefa inicial 1'),
      TarefaModel(nome: 'Tarefa inicial 2'),
      TarefaModel(nome: 'Tarefa inicial 3'),
      TarefaModel(nome: 'Tarefa inicial 4'),
    ]);

    return Future(
      () => _tarefas,
    );
  }

  Future<List<TarefaModel>> postTarefa({required TarefaModel tarefa}) async {
    _tarefas.add(tarefa);

    return Future(
      () => _tarefas,
    );
  }

  Future<List<TarefaModel>> deleteTarefa({required TarefaModel tarefa}) async {
    _tarefas.remove(tarefa);

    return Future(
      () => _tarefas,
    );
  }
}
