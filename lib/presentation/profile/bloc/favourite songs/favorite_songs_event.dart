part of 'favorite_songs_bloc.dart';

abstract class FavoriteSongsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavoriteSongs extends FavoriteSongsEvent {}

class RemoveFavoriteSong extends FavoriteSongsEvent {
  final String songId;

  RemoveFavoriteSong({required this.songId});

  @override
  List<Object?> get props => [songId];
}
