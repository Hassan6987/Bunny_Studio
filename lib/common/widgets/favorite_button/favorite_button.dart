import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';

import '../favorite_button/bloc/favourite_button_bloc.dart';


class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;
  final Function? function;

  const FavoriteButton({
    required this.songEntity,
    this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteButtonBloc(),
      child: BlocBuilder<FavoriteButtonBloc, FavoriteButtonState>(
        builder: (context, state) {
          final isFavorite = state is FavoriteButtonUpdated
              ? state.isFavorite
              : songEntity.isFavorite;

          return IconButton(
            onPressed: () {
              context.read<FavoriteButtonBloc>().add(
                ToggleFavoriteStatus(songId: songEntity.songId),
              );
              if (function != null) {
                function!();
              }
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
              size: 25,
              color: Colors.red,
            ),
          );
        },
      ),
    );
  }
}
