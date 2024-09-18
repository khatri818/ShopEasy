import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shopeasy/features/auth/presentation/screens/otpverification.dart';
import 'package:shopeasy/features/auth/presentation/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();

  String _phoneNumber = '';
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Removed _checkStoredPhoneNumber as we no longer use SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/auth_images/auth1.jpeg', // Replace this with the path to your image
                width: 350, // Adjust the width as needed
                height: 350, // Adjust the height as needed
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your phone number to Register',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We will send you the 6 digit verification code',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IntlPhoneField(
                      focusNode: _phoneFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        errorText: _errorText,
                      ),
                      onChanged: (phone) {
                        setState(() {
                          _phoneNumber = phone.completeNumber;
                          _errorText = null;
                        });
                      },
                      initialCountryCode: 'IN',
                      validator: (value) {
                        if (value == null || value.number.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.number.length < 10) {
                          return 'Phone number must be at least 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF705AFE), // #705AFE
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'CONTINUE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text(
                          'Already Registered? Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if the phone number has at least 10 digits
      if (_phoneNumber.length < 10) {
        setState(() {
          _errorText = 'Phone number must be at least 10 digits';
        });
      } else {
        setState(() {
          _errorText = null; // Reset error text
        });

        // Check if the phone number exists in Firestore
        bool exists = await _checkPhoneNumberInFirestore(_phoneNumber);
        if (exists) {
          setState(() {
            _errorText = 'Phone number already registered';
          });
        } else {
          // Navigate to OTPVerificationPage and pass the phone number as an argument
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(phoneNumber: _phoneNumber),
            ),
          );
        }
      }
    }
  }

  Future<bool> _checkPhoneNumberInFirestore(String phoneNumber) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(phoneNumber).get();
      return doc.exists;
    } catch (e) {
      setState(() {
        _errorText = 'Error checking phone number: $e';
      });
      return false;
    }
  }
}
