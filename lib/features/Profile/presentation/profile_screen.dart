import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopeasy/core/theme/app_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _phoneNumber = '';
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    _prefs = await SharedPreferences.getInstance();
    _phoneNumber = _prefs?.getString('phoneNumber') ?? '';
    log(_phoneNumber);

    if (_phoneNumber.isNotEmpty) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        String collectionPath = 'users';

        DocumentSnapshot userDocument = await firestore.collection(collectionPath).doc(_phoneNumber).get();

        if (userDocument.exists) {
          setState(() {
            Map<String, dynamic>? userData = userDocument.data() as Map<String, dynamic>?;
            if (userData != null) {
              _nameController.text = userData['name'] ?? '';
              _addressController.text = userData['address'] ?? '';
              String? imagePath = userData['imagePath'];
              if (imagePath != null && imagePath.isNotEmpty) {
                _image = File(imagePath);
              }
            }
          });
        }
        else {
          Fluttertoast.showToast(msg: 'User data not found');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error loading profile data: $e');
      }
    } else {
      Fluttertoast.showToast(msg: 'Phone number not found');
    }
  }


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _prefs?.setString('imagePath', pickedFile.path);
    }
  }

  Future<void> _saveUserDataToFirestore(String name, String address, String imagePath) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String collectionPath = 'users';

      DocumentSnapshot userDocument = await firestore.collection(collectionPath).doc(_phoneNumber).get();

      if (userDocument.exists) {
        await firestore.collection(collectionPath).doc(_phoneNumber).update({
          'name': name,
          'address': address,
          'imagePath': imagePath,
        });
        Fluttertoast.showToast(msg: 'Profile updated successfully');
      } else {
        // If the user data does not exist, create a new document
        await firestore.collection(collectionPath).doc(_phoneNumber).set({
          'name': name,
          'address': address,
          'imagePath': imagePath,
        });
        Fluttertoast.showToast(msg: 'Profile created successfully');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error saving profile data: $e');
    }
  }

  void _saveUserData() {
    String name = _nameController.text;
    String address = _addressController.text;
    if (name.isNotEmpty && address.isNotEmpty && _image != null) {
      _saveUserDataToFirestore(name, address, _image!.path);
    } else {
      Fluttertoast.showToast(msg: 'Please fill in all fields and select an image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.appBarGradient,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? const Icon(Icons.add_a_photo, size: 50) : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Phone Number: $_phoneNumber',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
