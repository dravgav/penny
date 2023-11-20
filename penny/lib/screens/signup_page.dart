import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penny/screens/home_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/main_page.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Penny',
                          style: GoogleFonts.phudu(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 60),
                        Text(
                          'Sign Up',
                          style: GoogleFonts.phudu(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),
                        _buildTextField(_nameController, 'Name', (value) => value!.isEmpty ? 'Name cannot be empty' : null),
                        SizedBox(height: 20),
                        _buildEmailField(),
                        SizedBox(height: 20),
                        _buildPasswordField(context, _passwordController, 'Password'),
                        SizedBox(height: 20),
                        _buildPasswordField(context, _confirmPasswordController, 'Confirm Password', confirm: true),
                        SizedBox(height: 20),
                        _buildAddressFieldWithPin(context, _addressController),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            }
                          },
                          child: Text('Sign Up'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Rounded corners
                            ),
                          ),
                        ),
                        SizedBox(height: 20), // Increased padding under sign-up button
                        // Optionally add navigation to the login page
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(_emailController, 'Email', (value) {
      if (value == null || value.isEmpty) {
        return 'Email cannot be empty';
      } else if (!RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b').hasMatch(value)) {
        return 'Enter a valid email address';
      }
      return null;
    });
  }

  Widget _buildPasswordField(BuildContext context, TextEditingController controller, String label, {bool confirm = false}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: confirm ? !_confirmPasswordVisible : !_passwordVisible,
            validator: confirm ? (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm Password cannot be empty';
              }
              if (_passwordController.text != _confirmPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            } : (value) => _passwordValidation(value),
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: IconButton(
                icon: Icon(
                  confirm ? (_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off) :
                            (_passwordVisible ? Icons.visibility : Icons.visibility_off),
                ),
                onPressed: () {
                  setState(() {
                    if (confirm) {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    } else {
                      _passwordVisible = !_passwordVisible;
                    }
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }

  String? _passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    List<String> errors = [];
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) errors.add('one uppercase letter');
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) errors.add('one lowercase letter');
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) errors.add('one number');
    if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) errors.add('one special character');
    if (value.length < 8) errors.add('at least 8 characters');

    if (errors.isNotEmpty) {
      return 'Password must include ' + errors.join(', ');
    }
    return null;
  }

  Widget _buildTextField(TextEditingController controller, String label, String? Function(String?) validator, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFieldWithPin(BuildContext context, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) => value!.isEmpty ? 'Address cannot be empty' : null,
            ),
          ),
          SizedBox(width: 8), // Added spacing
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                // TODO: Implement address fetching logic
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(Icons.pin_drop, color: Colors.white), // Pin icon in a circle
              ),
            ),
          ),
        ],
      ),
    );
  }
}
