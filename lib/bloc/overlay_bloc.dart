import 'dart:async';
import 'package:rxdart/rxdart.dart';

class OverlayBloc {
  bool value = true;

  // output
  final overlay = StreamController<bool>.broadcast();
  Stream<bool> get overlayStream => overlay.stream;

  // input
  final getValue = StreamController<bool>();

  Sink<bool> get inputValue => getValue.sink;
  Stream<bool> get result => getValue.stream;

  OverlayBloc(){
    result.listen((data){
      overlay.add(data);
    });
  }

}
final overlayBloc = OverlayBloc();