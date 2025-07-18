import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() {
    return _ContactScreenState();
  }
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _userInput = TextEditingController();
  bool _isLoading = false;

  Future<void> sendMessage() async {
    final text = _userInput.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final messageData = {
        'text': text,
        'user': user?.email ?? 'Guest',
        'sentAt': FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance
          .collection('User Feedback')
          .add(messageData);

      _userInput.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            'Message sent succesfully',
          ),
        ),
      );
    } catch (e) {
      print('Error sending feedback$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            style: GoogleFonts.quicksand(color: Colors.white),
            'Failed to send. Please try again $e',
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/contact.jpg', fit: BoxFit.cover),
        Container(
          color: const Color.fromARGB(255, 186, 179, 179).withOpacity(0.2),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Contact us',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 14),
                TextField(
                  controller: _userInput,
                  maxLines: 5,
                  style: GoogleFonts.urbanist(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.deepPurpleAccent.withOpacity(0.4),
                    hintText: 'Write your suggestions,and questions here...',
                    hintStyle: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _isLoading ? null : sendMessage,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Send',
                            style: GoogleFonts.urbanist(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
