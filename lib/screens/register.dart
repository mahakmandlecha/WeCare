import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'customDialogs.dart';
import 'homepage.dart';
//

class RegisterPage extends StatefulWidget {
  final FirebaseAuth appAuth;
  static const routeName = '/register';
  RegisterPage(this.appAuth);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _phoneNumber;
  String _address;
  String _name;
  List<String> _availability = ['Yes', 'No'];
  String _availabilitySelected = '';
  List<String> _gender = ['Male', 'Female'];
  String _genderSelected = '';

  bool _availabilityCategorySelected = false;
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String _bloodGroupSelected = '';
  bool _categorySelected = false;
  bool _genderCategorySelected = false;
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(_user) async {
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .collection('User Details')
          .doc(_user['uid'])
          .set(_user)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged In');
    }
  }

  bool validate_save() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validate_submit(BuildContext context) async {
    if (validate_save()) {
      try {
        CustomDialogs.progressDialog(
            context: context, message: 'Registration under process');
        User user = (await widget.appAuth.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        Navigator.pop(context);
        print('Registered User: ${user.uid}');
        final Map<String, dynamic> UserDetails = {
          'uid': user.uid,
          'name': _name,
          'email': _email,
          'bloodgroup': _bloodGroupSelected,
          'availability': _availabilitySelected,
          'mobile-number': _phoneNumber,
          'address': _address,
          'gender': _genderSelected,
        };
        addData(UserDetails).then((result) {
          print("User Added");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }).catchError((e) {
          print(e);
        });
      } catch (e) {
        print('Errr : $e');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Registration Failed'),
                content: Text('Error : $e'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Register",
        ),
      ),
      body: Container(
        height: 800.0,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Form(
                key: formkey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          icon: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.amberAccent[700],
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? "Name field can't be empty" : null,
                        onSaved: (value) => _name = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email ID',
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.amberAccent[700],
                          ),
                        ),
                        validator: (value) => value.isEmpty
                            ? "Email ID field can't be empty"
                            : null,
                        onSaved: (value) => _email = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          icon: Icon(
                            FontAwesomeIcons.userLock,
                            color: Colors.amberAccent[700],
                          ),
                        ),
                        obscureText: true,
                        validator: (value) => value.isEmpty
                            ? "Password field can't be empty"
                            : null,
                        onSaved: (value) => _password = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Address',
                          icon: Icon(
                            FontAwesomeIcons.addressBook,
                            color: Colors.amberAccent[700],
                          ),
                        ),
                        validator: (value) => value.isEmpty
                            ? "Address field can't be empty"
                            : null,
                        onSaved: (value) => _address = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone No.',
                          icon: Icon(
                            FontAwesomeIcons.phone,
                            color: Colors.amberAccent[700],
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? "Phone no. can't be empty" : null,
                        onSaved: (value) => _phoneNumber = value,
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: DropdownButton(
                              hint: Text(
                                'Choose Blood Group',
                                style: TextStyle(color: Colors.black),
                              ),
                              iconSize: 40.0,
                              items: _bloodGroup.map((val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _bloodGroupSelected = newValue;
                                  this._categorySelected = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            _bloodGroupSelected,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.amberAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: DropdownButton(
                              hint: Text(
                                'Are you available',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              iconSize: 40.0,
                              items: _availability.map((val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _availabilitySelected = newValue;
                                  this._availabilityCategorySelected = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            _availabilitySelected,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.amberAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: DropdownButton(
                              hint: Text(
                                'Choose gender',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              iconSize: 40.0,
                              items: _gender.map((val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _genderSelected = newValue;
                                  this._genderCategorySelected = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            _genderSelected,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.amberAccent[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      onPressed: () => validate_submit(context),
                      textColor: Colors.white,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      color: Colors.amberAccent[700],
                      child: Text("REGISTER"),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
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
}