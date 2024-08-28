import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:equatable/equatable.dart';
part 'favorite_songs_event.dart';
part 'favorite_songs_state.dart';

class FavoriteSongsBloc extends Bloc<FavoriteSongsEvent, FavoriteSongsState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FavoriteSongsBloc() : super(FavoriteSongsLoading()) {
    on<LoadFavoriteSongs>(_onLoadFavoriteSongs);
    on<RemoveFavoriteSong>(_onRemoveFavoriteSong);
  }

  Future<void> _onLoadFavoriteSongs(
      LoadFavoriteSongs event,
      Emitter<FavoriteSongsState> emit,
      ) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        print("no user found");
        emit(FavoriteSongsFailure());
        return;
      }
      final userId = user.uid;
      final favoritesSnapshot = await _firebaseFirestore
          .collection('Users')
          .doc(userId)
          .collection('Favorites')
          .get();



      final favoriteSongs = <SongEntity>[];
      for (var doc in favoritesSnapshot.docs) {
        final songId = doc['songId'];
        print('song id:'+ songId);
        final songDoc = await _firebaseFirestore.collection('songs').doc(songId).get();
        print('song doc:');
        print(songDoc);
        final songData = songDoc.data()!;
        print('song data:');
        print(songData);
        final song = SongEntity(
          title: songData['title'],
          artist: songData['artist'],
          releaseDate: songData['releaseDate'],
          isFavorite: true,
          songId: songId,
        );
        favoriteSongs.add(song);
      }

      emit(FavoriteSongsLoaded(favoriteSongs: favoriteSongs));
    } catch (e) {
      print('mapping error');
      print(e);
      emit(FavoriteSongsFailure());
    }
  }

  Future<void> _onRemoveFavoriteSong(
      RemoveFavoriteSong event,
      Emitter<FavoriteSongsState> emit,
      ) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        emit(FavoriteSongsFailure());
        return;
      }
      final userId = user.uid;
      final songId = event.songId;

      final favoriteSongs = await _firebaseFirestore
          .collection('Users')
          .doc(userId)
          .collection('Favorites')
          .where('songId', isEqualTo: songId)
          .get();

      if (favoriteSongs.docs.isNotEmpty) {
        await favoriteSongs.docs.first.reference.delete();
      }

      // Optionally reload the list of favorite songs after removal
      add(LoadFavoriteSongs());
    } catch (e) {
      print(e);
      emit(FavoriteSongsFailure());
    }
  }
}
