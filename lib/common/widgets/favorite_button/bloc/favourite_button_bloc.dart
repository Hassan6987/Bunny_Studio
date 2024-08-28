import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favourite_button_event.dart';
part 'favorite_button_state.dart';

class FavoriteButtonBloc extends Bloc<FavoriteButtonEvent, FavoriteButtonState> {
  final Map<String, bool> _favorites = {};

  FavoriteButtonBloc() : super(FavoriteButtonInitial()) {
    on<ToggleFavoriteStatus>(_onToggleFavoriteStatus);
  }

  void _onToggleFavoriteStatus(
      ToggleFavoriteStatus event,
      Emitter<FavoriteButtonState> emit,
      ) {
    // Simulate toggling favorite status
    final isFavorite = _favorites[event.songId] ?? false;
    _favorites[event.songId] = !isFavorite;

    emit(FavoriteButtonUpdated(isFavorite: !isFavorite));
  }
}