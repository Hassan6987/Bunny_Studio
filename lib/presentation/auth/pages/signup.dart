import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/image_picker/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/presentation/auth/pages/signin.dart';
import 'package:spotify/data/sources/auth/add_data.dart';
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _fullName = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  Uint8List? _image;

  void selectImage()async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> saveProfile() async {
    String name = _fullName.text;
    String email = _email.text;
    String password = _password.text;

    await StoreData().saveData(name: name, email: email, password: password, file: _image!, context: context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 40
            ),
            decoration:  BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      context.isDarkMode ? AppImages.bgDark : AppImages.bgBright,
                    )
                )
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 30
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BasicAppbar(
                  title: Image.asset(
                    AppImages.logo,
                    height: 150,
                    width: 150,
                  ),
                ),
                _registerText(),
                const SizedBox(height: 20,),
                Stack(
                  children: [
                    _image !=null
                        ?CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : const CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(AppURLs.defaultImage),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo),),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                _fullNameField(context),
                const SizedBox(height: 20,),
                _emailField(context),
                const SizedBox(height: 20,),
                _passwordField(context),
                const SizedBox(height: 20,),
                BasicAppButton(
                  onPressed: saveProfile,
                  title: 'Create Account',
                  height: 50,
                ),
                _siginText(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField(BuildContext context) {
    return TextField(
      controller: _fullName,
      decoration: const InputDecoration(
        hintText: 'Full Name'
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'Enter Email'
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

   Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
        hintText: 'Password'
      ).applyDefaults(
        Theme.of(context).inputDecorationTheme
      ),
    );
  }

  Widget _siginText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Do you have an account? ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SigninPage()
                )
              );
            },
            child: const Text(
              'Sign In'
            )
          )
        ],
      ),
    );
  }
}