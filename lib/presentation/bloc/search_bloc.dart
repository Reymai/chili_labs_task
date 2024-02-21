import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chili_labs_task/data/models/gif.dart';
import 'package:chili_labs_task/data/repository/gif_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GifRepository gifRepository;
  Timer? _timer;

  SearchBloc({required this.gifRepository}) : super(SearchInitial()) {
    on<SearchTextChanged>(_mapSearchTextChangedToState);
    on<LoadMore>(_mapLoadMoreToState);
  }

  void _mapSearchTextChangedToState(
      SearchTextChanged event, Emitter<SearchState> emit) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () {
      add(LoadMore(text: event.text, offset: 0));
    });
  }

  void _mapLoadMoreToState(LoadMore event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final gifs = await gifRepository.searchGifs(
        event.text,
        event.offset, // Use the current number of gifs as the new offset
      );
      if (state is SearchSuccess) {
        emit(SearchSuccess(
            gifs: (state as SearchSuccess).gifs +
                gifs)); // Append the new gifs to the existing ones
      } else {
        emit(SearchSuccess(
            gifs:
                gifs)); // If the current state is not SearchSuccess, just emit the new gifs
      }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
