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
  SearchBloc({required this.gifRepository}) : super(SearchInitial()) {
    on<SearchEvent>(_mapSearchTextChangedToState);
  }

  void _mapSearchTextChangedToState(
      SearchTextChanged event, Emitter<SearchState> emit) async {
    try {
      emit(SearchLoading());
      final List<Gif> gifs = await gifRepository.searchGifs(event.text);
      emit(SearchSuccess(gifs: gifs));
    } catch (e) {
      emit(SearchError(message: 'Failed to load gifs'));
    }
  }
}
