import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/data.dart';
import '../models/diamondModel.dart';

abstract class DiamondEvent {}

class FilterDiamonds extends DiamondEvent {
  final double? minCarat;
  final double? maxCarat;
  final String? shape;
  final String? lab;
  final String? color;
  final String? clarity;

  FilterDiamonds({this.minCarat, this.maxCarat, this.shape, this.lab, this.color, this.clarity});
}

abstract class DiamondState {}

class DiamondLoading extends DiamondState {}

class DiamondLoaded extends DiamondState {
  final List<Diamond> diamonds;
  DiamondLoaded(this.diamonds);
}

class DiamondBloc extends Bloc<DiamondEvent, DiamondState> {
  DiamondBloc() : super(DiamondLoaded(diamondList)) {
    on<FilterDiamonds>((event, emit) {
      emit(DiamondLoading());

      List<Diamond> filteredDiamonds = diamondList.where((d) {
        return (event.minCarat == null || d.carat >= event.minCarat!) &&
            (event.maxCarat == null || d.carat <= event.maxCarat!) &&
            (event.shape == null || d.shape == event.shape) &&
            (event.lab == null || d.lab == event.lab) &&
            (event.color == null || d.color == event.color) &&
            (event.clarity == null || d.clarity == event.clarity);
      }).toList();

      emit(DiamondLoaded(filteredDiamonds));
    });
  }
}