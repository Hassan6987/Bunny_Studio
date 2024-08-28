
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';

class UploadSongDialog extends StatefulWidget {
  const UploadSongDialog({super.key});

  @override
  _UploadSongDialogState createState() => _UploadSongDialogState();
}

class _UploadSongDialogState extends State<UploadSongDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();

  PlatformFile? _songFile;
  XFile? _coverImage;
  DateTime? _releaseDate;

  Future<void> _pickSong() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _songFile = result.files.first;
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _coverImage = image;
      });
    }
  }

  Future<void> _selectReleaseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _releaseDate) {
      setState(() {
        _releaseDate = picked;
      });
    }
  }

  Future<void> _uploadSong() async {
    if (_titleController.text.isEmpty ||
        _artistController.text.isEmpty ||
        _releaseDate == null ||
        _songFile == null ||
        _coverImage == null) {

      // Show error message
      return;
    }

    try{


      Timestamp releaseDateTimestamp = Timestamp.fromDate(_releaseDate!);


      // Upload song file to Firebase Storage
      final songPath = 'songs/${_artistController.text} - ${_titleController.text}.mp3';
      final songRef = FirebaseStorage.instance.ref().child(songPath);
      await songRef.putFile(File(_songFile!.path!));

      // Upload cover image to Firebase Storage
      final coverPath = 'covers/${_artistController.text} - ${_titleController.text}.jpg';
      final coverRef = FirebaseStorage.instance.ref().child(coverPath);
      await coverRef.putFile(File(_coverImage!.path));

      // Add song details to Firestore
      await FirebaseFirestore.instance.collection('songs').add({
        'title': _titleController.text,
        'artist': _artistController.text,
        'releaseDate': releaseDateTimestamp,
      });

      Navigator.of(context).pop();// Close the dialog

    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())),);
    }

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Song'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5,),
            _textField(context, _titleController, 'Song Title'),
            const SizedBox(height: 5,),
            _textField(context, _artistController, 'Artist Name'),
            const SizedBox(height: 5,),
            BasicAppButton(
              onPressed: () => _selectReleaseDate(context),
              title:  _releaseDate == null
                  ? 'Pick Release Date'
                  : 'Change Release Date',
              height: 40,
            ),
            BasicAppButton(
              onPressed: _pickSong,
              title: _songFile == null ? 'Pick Song' : 'Change Song',
              height: 40,
            ),
            BasicAppButton(
              onPressed: _pickCoverImage,
              title: _coverImage == null ? 'Pick Cover Image' : 'Change Cover Image',
              height: 40,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _uploadSong,
          child: const Text('Done'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _textField(BuildContext context, TextEditingController controller, String labelText) {
    return SizedBox(
      width: 250,
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.symmetric(horizontal:  48),
          border: const OutlineInputBorder(),
        ).applyDefaults(
            Theme.of(context).inputDecorationTheme
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}