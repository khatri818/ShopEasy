import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopeasy/features/auth/presentation/screens/login_screen.dart'; // Import the LoginPage
import 'package:cloud_firestore/cloud_firestore.dart';

class OTPVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  bool _showErrorMessage = false;
  final List<String> _otp = List.filled(6, ''); // Initialize with 6 empty strings
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Fluttertoast.showToast(
          msg: "Registration Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _navigateToLoginPage();
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(
          msg: "Error: ${e.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        Fluttertoast.showToast(
          msg: "OTP Sent",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      String smsCode = _otp.join('');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);

      // Upon successful sign-in, save user data to Firestore
      await _saveUserDataToFirestore(widget.phoneNumber); // Use phone number as document ID

      Fluttertoast.showToast(
        msg: "Registration Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      _navigateToLoginPage();
    } catch (e) {
      setState(() {
        _showErrorMessage = true;
      });
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _saveUserDataToFirestore(String phoneNumber) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Define the collection path where user data is stored
      String collectionPath = 'users';

      // Store the user data in Firestore with phone number as document ID
      await firestore.collection(collectionPath).doc(phoneNumber).set({
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      // Handle any errors
    }
  }


  void _resendOTP() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(
            msg: "Error: ${e.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          Fluttertoast.showToast(
            msg: "New OTP Sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/auth_images/auth2.png', // Replace with your image path
              width: 280,
              height: 280,
            ),
            const SizedBox(height: 10),
            const Text(
              'OTP Verification',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Enter the OTP sent to ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                    (index) => SizedBox(
                  width: 50.0,
                  child: TextField(
                    maxLength: 1,
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.all(10.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _otp[index] = value;
                        _focusNodes[index].unfocus();
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      } else if (value.isNotEmpty) {
                        _otp[index] = value;
                        _focusNodes[index].unfocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _signInWithPhoneNumber();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF705AFE), // #705AFE
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              child: const Text(
                'VERIFY & PROCEED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Center(
              child: InkWell(
                onTap: () {
                  _resendOTP();
                },
                child: const Text(
                  "Didn't receive OTP? Resend",
                  style: TextStyle(
                    color: Color(0xFF705AFE),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_showErrorMessage)
              _buildErrorMessage(),
          ],
        ),
      ),
    ),
    );
  }


  Widget _buildErrorMessage() {
    return const Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        'Incorrect OTP, please try again.',
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
