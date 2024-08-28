import 'package:dartz/dartz.dart';

abstract class SongsRepository {

  Future<Either> getNewSongs();
  Future<Either> getPlayList();
  Future<bool> isFavoriteSong(String songId);
}