// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_app/app/data/models/tarefa_model.dart';

abstract class TarefaEvent {}

class GetTarefas extends TarefaEvent {}

class PostTarefas extends TarefaEvent {
  final TarefaModel tarefa;

  PostTarefas({required this.tarefa});
}

class DeleteTarefa extends TarefaEvent {
  final TarefaModel tarefa;

  DeleteTarefa({required this.tarefa});
}
