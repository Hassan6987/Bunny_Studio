part of 'favourite_button_bloc.dart';

sealed class FavoriteButtonState extends Equatable {
  const FavoriteButtonState();
}

final class FavoriteButtonInitial extends FavoriteButtonState {
  @override
  List<Object> get props => [];
}

class FavoriteButtonUpdated extends FavoriteButtonState {
  final bool isFavorite;

  const FavoriteButtonUpdated({required this.isFavorite});

  @override
  List<Object?> get props => [isFavorite];
}
