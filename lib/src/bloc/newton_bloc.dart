import 'package:bloc/bloc.dart';
import 'package:newton_2/src/bloc/newton_event.dart';
import 'package:newton_2/src/bloc/newton_state.dart';
import 'package:newton_2/src/models/polynom.dart';
import '../scripts/scripts.dart';
import 'package:newton_2/src/storage/field_storage.dart';
import 'package:rxdart/rxdart.dart';

class NewtonBloc extends Bloc<NewtonEvent, NewtonState> {
  final _storageMap = <String, FieldStorage>{};

  FieldStorage getField(String name) => _storageMap[name];

  Stream<bool> get buildButton =>
      CombineLatestStream(_getStreams(), (values) => true);

  Iterable<Stream<dynamic>> _getStreams() {
    final list = <Stream<dynamic>>[];
    _storageMap.forEach((_, s) => list.add(s.valueStream));
    return list;
  }

  Polynomial polynomial;

  @override
  NewtonState get initialState => InitialState();

  @override
  Stream<NewtonState> mapEventToState(NewtonEvent event) async* {
    if (event is InitBlocEvent) {
      _initStorage();
    }

    if (event is BuildGraphicEvent) {
      yield CalculatingState();
      polynomial = Polynomial(
        _storageMap['A'].value,
        _storageMap['B'].value,
        _storageMap['C'].value,
        _storageMap['D'].value,
        _storageMap['alpha'].value,
        _storageMap['betta'].value,
        _storageMap['delta'].value,
        _storageMap['epsilon'].value,
        _storageMap['mu'].value,
        _storageMap['n'].value,
        _storageMap['h'].value,
      );
      yield BuildState(polynomial);
    }
  }

  void _initStorage() {
    _storageMap['A'] =
        FieldStorage<double>('A', validate1000range, doubleParser, -10);
    _storageMap['B'] =
        FieldStorage<double>('B', validate1000range, doubleParser, 10);
    _storageMap['C'] =
        FieldStorage<double>('C', validate1000range, doubleParser, -10);
    _storageMap['D'] =
        FieldStorage<double>('D', validate1000range, doubleParser, 10);

    _storageMap['alpha'] =
        FieldStorage<double>('alpha', validate100range, doubleParser, 1);
    _storageMap['betta'] =
        FieldStorage<double>('betta', validate100range, doubleParser, 1);
    _storageMap['delta'] =
        FieldStorage<double>('delta', validate100range, doubleParser, 1);
    _storageMap['epsilon'] =
        FieldStorage<double>('epsilon', validate100range, doubleParser, 1);
    _storageMap['mu'] =
        FieldStorage<double>('mu', validate100range, doubleParser, 1);

    _storageMap['n'] = FieldStorage<int>('n', validate0to100, intParser, 10);
    _storageMap['h'] = FieldStorage<double>('h', null, doubleParser, 0.1);
  }

  void dispose() {
    _storageMap.forEach((key, value) => value.dispose());
    super.close();
  }
}
