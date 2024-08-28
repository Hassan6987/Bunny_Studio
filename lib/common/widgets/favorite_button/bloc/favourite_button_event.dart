part of 'favourite_button_bloc.dart';

abstract class FavoriteButtonEvent extends Equatable {
  const FavoriteButtonEvent();

  @override
  List<Object?> get props => [];
}

class ToggleFavoriteStatus extends FavoriteButtonEvent {
  final String songId;

  const ToggleFavoriteStatus({required this.songId});

  @override
  List<Object?> get props => [songId];
}