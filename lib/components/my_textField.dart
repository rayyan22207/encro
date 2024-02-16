import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    Key? key, // Add a key here
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(30), // Adjust the radius as needed
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(30),
            ),
            fillColor: Color.fromARGB(255, 255, 255, 255),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}

class MyPasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  MyPasswordTextfield({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  State<MyPasswordTextfield> createState() => _MyPasswordTextfieldState();
}

class _MyPasswordTextfieldState extends State<MyPasswordTextfield> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: obscurePassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(30), // Adjust the radius as needed
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(30),
          ),
          fillColor: Color.fromARGB(255, 255, 255, 255),
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          ),
        ),
      ),
    );
  }
}
