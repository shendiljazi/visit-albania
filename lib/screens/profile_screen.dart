import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:visit_albania/providers/auth_provider.dart';
import 'package:visit_albania/screens/welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  String? selectedCountry;
  String? selectedCountryFlag;
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController();
    passwordController = TextEditingController(text: '******');
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      surnameController.text = data['surname'] ?? '';
      phoneController.text = data['phone'] ?? '';
      selectedCountry = data['country'] ?? '';
      selectedCountryFlag = data['countryFlag'] ?? '';
    } else {
      nameController.text = '';
      surnameController.text = '';
      phoneController.text = '';
      selectedCountry = '';
      selectedCountryFlag = '';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      isSaving = true;
    });
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return;
    try {
      await user.updateDisplayName(nameController.text);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'surname': surnameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'country': selectedCountry,
        'flag': selectedCountryFlag,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          backgroundColor: Colors.greenAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            'Profile updated!',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Text(
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            'Failed to update profile $e',
          ),
        ),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isGuest = authProvider.isGuest;

    if (isGuest) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 240),
            Text(
              'You need to an account to view and edit your profile!',
              style: GoogleFonts.urbanist(
                color: Colors.deepPurple,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 23),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Text(
                'Click here to log in with an account',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (isLoading) {
      return CircularProgressIndicator(color: Colors.deepPurpleAccent);
    }
    return Padding(
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            TextField(
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              controller: nameController,
              decoration: InputDecoration(
                fillColor: Colors.deepPurpleAccent.withOpacity(0.6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Name',
                hintStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 14),
            TextField(
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              controller: surnameController,
              decoration: InputDecoration(
                fillColor: Colors.deepPurpleAccent.withOpacity(0.6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              controller: emailController,
              decoration: InputDecoration(
                fillColor: Colors.deepPurpleAccent.withOpacity(0.6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Email',
                hintStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextField(
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              controller: passwordController,
              decoration: InputDecoration(
                fillColor: Colors.deepPurpleAccent.withOpacity(0.6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Password',
                hintStyle: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              readOnly: true,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            SizedBox(height: 14),
            TextField(
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                fillColor: Colors.deepPurpleAccent.withOpacity(0.6),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Phone',
                hintStyle: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country.name;
                        selectedCountryFlag = country.flagEmoji;
                      });
                    },
                  );
                },
                child: Row(
                  children: [
                    if (selectedCountryFlag != null &&
                        selectedCountryFlag!.isNotEmpty)
                      Text(
                        selectedCountryFlag!,
                        style: TextStyle(fontSize: 24),
                      ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedCountry ?? 'Select Country',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Icon(Icons.arrow_circle_down_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
            SizedBox(height: 23),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: isSaving ? null : _saveProfile,
              child:
                  isSaving
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        'Save changes',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
