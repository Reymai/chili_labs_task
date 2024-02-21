part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTextChanged extends SearchEvent {
  final String text;

  const SearchTextChanged({required this.text});

  @override
  List<Object> get props => [text];
}

class LoadMore extends SearchEvent {
  final String text;
  final int offset;

  const LoadMore({required this.text, required this.offset});

  @override
  List<Object> get props => [text, offset];
}
