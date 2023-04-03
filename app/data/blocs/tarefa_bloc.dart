import 'package:bloc/bloc.dart';
import 'package:bloc_app/app/data/blocs/tarefa_event.dart';
import 'package:bloc_app/app/data/blocs/tarefa_state.dart';
import 'package:bloc_app/app/data/repositories/user_repository.dart';

import '../models/tarefa_model.dart';

class TarefaBloc extends Bloc<TarefaEvent, TarefaState> {
  final _repository = TarefaRepository();

  TarefaBloc() : super(TarefaInitialState()) {
    on(_mapEventToState);
  }
  void _mapEventToState(TarefaEvent event, Emitter emit) async {
    List<TarefaModel> tarefas = [];

    emit(TarefaLoadingState());

    if (event is GetTarefas) {
      tarefas = _repository.tarefas;
    } else if (event is PostTarefas) {
      if (event.tarefa.nome.isNotEmpty) {
        tarefas = await _repository.postTarefa(tarefa: event.tarefa);
      } else {
        tarefas = _repository.tarefas;
        emit(TarefaErrorState(message: 'Empty text field'));
      }
    } else if (event is DeleteTarefa) {
      tarefas = await _repository.deleteTarefa(tarefa: event.tarefa);
    }

    emit(TarefaLoadedState(tarefas: tarefas));
  }
}

// WITHOUT THE BLOC PACKAGE
// class TarefaBloc {
//   final _repository = TarefaRepository();

//   final StreamController<TarefaEvent> _inputTarefaController =
//       StreamController<TarefaEvent>();

//   final StreamController<TarefaState> _outputTarefaController =
//       StreamController<TarefaState>();

//   Sink<TarefaEvent> get inputTarefa => _inputTarefaController.sink;
//   Stream<TarefaState> get outputTarefa => _outputTarefaController.stream;

//   TarefaBloc() {
//     _inputTarefaController.stream.listen(_mapEventToState);
//   }
//   void _mapEventToState(TarefaEvent event) async {
//     List<TarefaModel> tarefas = [];

//     _outputTarefaController.add(TarefaLoadingState());

//     if (event is GetTarefas) {
//       tarefas = await _repository.getTarefas();
//     } else if (event is PostTarefas) {
//       tarefas = await _repository.postTarefa(tarefa: event.tarefa);
//     } else if (event is DeleteTarefa) {
//       tarefas = await _repository.deleteTarefa(tarefa: event.tarefa);
//     }

//     _outputTarefaController.add(TarefaLoadedState(tarefas: tarefas));
//   }
// }
