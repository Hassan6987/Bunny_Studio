import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/upload_song_dialog.dart';
import 'package:spotify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favourite%20songs/favorite_songs_bloc.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

import '../../../core/configs/constants/app_urls.dart';
import '../../auth/pages/signin.dart';
import '../bloc/profile_info_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const BasicAppbar(
        backgroundColor: AppColors.red,
        title: Text(
          'Profile',style: TextStyle(color: AppColors.lightBackground, fontWeight: FontWeight.bold,fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _profileInfo(context),
             const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeOption(
                  context,
                  mode: ThemeMode.dark,
                  icon: AppVectors.moon,
                  label: 'Dark Mode',
                ),
                const SizedBox(width: 40),
                _buildModeOption(
                  context,
                  mode: ThemeMode.light,
                  icon: AppVectors.sun,
                  label: 'Light Mode',
                ),
              ],
            ),
            const SizedBox(height: 10),
             _favoriteSongs(context)
          ],
        ),
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3 ,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50)
          )
        ),
        child: BlocBuilder<ProfileInfoCubit,ProfileInfoState>(
        builder: (context, state) {
          if(state is ProfileInfoLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator()
            );
          } 
          if(state is ProfileInfoLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.11,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        state.userEntity.imageURL ?? AppURLs.defaultImage,
                      ),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Text(
                  state.userEntity.email ?? 'No Email',
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Text(
                  state.userEntity.fullName ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height:  MediaQuery.of(context).size.height * 0.01,),
                ElevatedButton(
                  onPressed:(){
                    _showUploadDialog(context);
                  } ,
                  child: const Text('Upload Songs',style: TextStyle(color: AppColors.lightBackground),),
                ),
                TextButton(onPressed: ()
                {
                  _signOut(context);
                }, child: const Text("Logout")
                ),


              ],
            );
          }

          if(state is ProfileInfoFailure) {
            return const Text(
              'Please try again'
            );
          }
          return Container();
        }, 
      ),

      ),
    );


  }


  Widget _favoriteSongs(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteSongsBloc()..add(LoadFavoriteSongs()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                const Center(
                  child: Text(
                    'FAVORITE SONGS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<FavoriteSongsBloc, FavoriteSongsState>(
              builder: (context, state) {
                if (state is FavoriteSongsLoading) {
                  return const Center(child:  CircularProgressIndicator());
                }
                if (state is FavoriteSongsLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => SongPlayerPage(songEntity: state.favoriteSongs[index]),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        '${AppURLs.coverFirestorage}${state.favoriteSongs[index].artist} - ${state.favoriteSongs[index].title}.jpg?${AppURLs.mediaAlt}',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.favoriteSongs[index].title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      state.favoriteSongs[index].artist,
                                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    state.favoriteSongs[index].isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    context.read<FavoriteSongsBloc>().add(
                                      RemoveFavoriteSong(songId: state.favoriteSongs[index].songId),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemCount: state.favoriteSongs.length,
                  );
                }
                if (state is FavoriteSongsFailure) {
                  return const Center(
                    child: Text('Please try again.'),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }



   _signOut(context)  async{
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => SigninPage()
        ),
            (route) => true
    );
  }

  Widget _buildModeOption(BuildContext context,
      {required ThemeMode mode, required String icon, required String label}) {
    final isSelected = context.watch<ThemeCubit>().state == mode;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.read<ThemeCubit>().updateTheme(mode);
          },
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.redAccent.withOpacity(0.5)
                      : const Color(0xff30393C).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  icon,
                  fit: BoxFit.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: isSelected ? Colors.redAccent : AppColors.grey,
          ),
        ),
      ],
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const UploadSongDialog(),
    );
  }


}