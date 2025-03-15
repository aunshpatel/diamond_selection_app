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

class SortDiamonds extends DiamondEvent {
  final String sortBy;
  final bool? ascending;

  SortDiamonds({required this.sortBy, this.ascending});
}

abstract class DiamondState {}

class DiamondLoading extends DiamondState {}

class DiamondLoaded extends DiamondState {
  final List<Diamond> diamonds;
  final List<Diamond> originalDiamonds;

  DiamondLoaded(this.diamonds, this.originalDiamonds);
}

class DiamondBloc extends Bloc<DiamondEvent, DiamondState> {
  DiamondBloc() : super(DiamondLoaded(diamondList, diamondList)) {
    on<FilterDiamonds>((event, emit) {
      emit(DiamondLoading());

      List<Diamond> filteredDiamonds = diamondList.where((d) {
        return (event.minCarat == null || d.carat >= event.minCarat!) &&
            (event.maxCarat == null || d.carat <= event.maxCarat!) &&
            (event.shape == null || event.shape == "All" || d.shape == event.shape) &&
            (event.lab == null || event.lab == "All" || d.lab == event.lab) &&
            (event.color == null || event.color == "All" || d.color == event.color) &&
            (event.clarity == null || event.clarity == "All" || d.clarity == event.clarity);
      }).toList();

      emit(DiamondLoaded(filteredDiamonds, List.from(filteredDiamonds)));
    });

    on<SortDiamonds>((event, emit) {
      if (state is DiamondLoaded) {
        List<Diamond> sortedDiamonds = List.from((state as DiamondLoaded).originalDiamonds);

        if (event.ascending != null) {
          if (event.sortBy == "price") {
            sortedDiamonds.sort((a, b) => event.ascending! ? a.finalAmount.compareTo(b.finalAmount) : b.finalAmount.compareTo(a.finalAmount));
          } else if (event.sortBy == "carat") {
            sortedDiamonds.sort((a, b) => event.ascending! ? a.carat.compareTo(b.carat) : b.carat.compareTo(a.carat));
          }
        }

        emit(DiamondLoaded(sortedDiamonds, (state as DiamondLoaded).originalDiamonds));
      }
    });
  }
}