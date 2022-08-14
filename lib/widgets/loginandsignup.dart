import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_kec/screens/forgetpassscreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginandSignup extends StatefulWidget {
  VoidCallback func;
  LoginandSignup({Key? key, required this.func}) : super(key: key);

  @override
  State<LoginandSignup> createState() => _LoginandSignupState();
}

class _LoginandSignupState extends State<LoginandSignup> {
  final _fkey = GlobalKey<FormState>();
  final pc = TextEditingController();
  bool isvisible = true;
  bool isLogin = true;
  bool isLoading = false;
  String email = '';
  String pass = '';
  String name = '';
  String staffid = '';
  String dept = '';
  String year = '';
  String stuyear = '';
  String section = '';
  String type = '';
  String sem = '';
  List<String> students = [];

  List<DropdownMenuItem<String>> department = const [
    DropdownMenuItem(value: "CIVIL", child: Text("Civil Engineering")),
    DropdownMenuItem(value: "MECH", child: Text("Mechanical Engineering")),
    DropdownMenuItem(value: "MTA", child: Text("Mechatronics Engineering")),
    DropdownMenuItem(value: "AU", child: Text("Automobile Engineering")),
    DropdownMenuItem(value: "CE", child: Text("Chemical Engineering")),
    DropdownMenuItem(value: "FT", child: Text("Food Technology")),
    DropdownMenuItem(value: "EEE", child: Text("Electrical and Electronis ")),
    DropdownMenuItem(
        value: "EIE", child: Text("Electronics and Instrumentation")),
    DropdownMenuItem(
        value: "ECE", child: Text("Electronics and Communication")),
    DropdownMenuItem(
        value: "CSE", child: Text("Computer Science and Engineering")),
    DropdownMenuItem(value: "IT", child: Text("Information Technology")),
    DropdownMenuItem(value: "CSD", child: Text("Computer Science and Design")),
    DropdownMenuItem(value: "AIML", child: Text("AI and ML")),
    DropdownMenuItem(value: "AIDS", child: Text("AI and Data Science")),
  ];

  List<DropdownMenuItem<String>> y = const [
    DropdownMenuItem(value: "1", child: Text("I")),
    DropdownMenuItem(value: "2", child: Text("II")),
    DropdownMenuItem(value: "3", child: Text("III")),
    DropdownMenuItem(value: "4", child: Text("IV"))
  ];
  List<DropdownMenuItem<String>> sec = const [
    DropdownMenuItem(value: "A", child: Text("A")),
    DropdownMenuItem(value: "B", child: Text("B")),
    DropdownMenuItem(value: "C", child: Text("C")),
    DropdownMenuItem(value: "D", child: Text("D")),
  ];
  List<DropdownMenuItem<String>> types = const [
    DropdownMenuItem(value: "1", child: Text("Class Advisor")),
    DropdownMenuItem(value: "3", child: Text("Teaching Staff")),
    DropdownMenuItem(value: "2", child: Text("Non-Teaching Staff")),
    DropdownMenuItem(value: "4", child: Text("Head of Department")),
  ];

  // ignore: non_constant_identifier_names
  void savePreferences(StaffEmail, passcode, staffName, designation, section,
      currentSemester, currentYear, studentBatch, department,staffid) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('email', StaffEmail);
    pref.setString('password', passcode);
    pref.setBool('islogin', true);
    pref.setString('name', staffName);
    pref.setString('designation', designation);
    pref.setString('staffId', staffid);
    if (designation == "1") {
      final response = await http.post(
          Uri.https(
              "mykecerode.000webhostapp.com", "AppApi/Staff/assignstos.php"),
          body: {
            'department': department,
            'currentYear': currentYear,
            'studentBatch': studentBatch,
            'section': section
          });
      var stu = jsonDecode(response.body);
      List<String> studentList = [];
      for (var i in stu) {
        studentList.add(i['rollNumber']);
      }
      pref.setString('section', section);
      pref.setString('semester', currentSemester);
      pref.setString('currentYear', currentYear);
      pref.setString('studentBatch', studentBatch);
      pref.setStringList('students', studentList);
      pref.setString('department', department);
    }
    widget.func();
  }

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text(
                'An Error has occured',
                style: TextStyle(color: Colors.orange),
              ),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ],
            ));
  }

  void submit() async {
    if (!_fkey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _fkey.currentState!.save();
    if (isLogin) {
      try {
        final response = await http.post(
            Uri.https(
                "mykecerode.000webhostapp.com", "AppApi/Staff/stafflogin.php"),
            body: {'email': email, 'pass': pass});
        var data = jsonDecode(response.body);
        if (data == 'Wrong password') {
          _showErrorDialog('Wrong Password');
        } else if (data == 'Account not found') {
          _showErrorDialog('Account doesn\'t exist');
        } else {
          savePreferences(
              email,
              pass,
              data[0]['staffName'],
              data[0]['designation'],
              data[0]['section'],
              data[0]['currentSemester'],
              data[0]['currentYear'],
              data[0]['studentBatch'],
              data[0]['department'],
              data[0]['staffId']);
        }
      } catch (e) {
        _showErrorDialog('Something went Wrong');
      }
    } else {
      try {
        final response = await http.post(
            Uri.https(
                "mykecerode.000webhostapp.com", "AppApi/Staff/staffsignup.php"),
            body: {
              'staffName': name,
              'staffEmail': email,
              'staffId': staffid,
              'department': dept,
              'section': section,
              'currentYear': year,
              'studentBatch': stuyear,
              'designation': type,
              'passcode': pass,
              'currentSemester': sem,
            });
        if (response.body == 'Something went Wrong') {
          _showErrorDialog('Something went Wrong');
        } else {
          savePreferences(
              email, pass, name, type, section, sem, year, stuyear, dept,staffid);
        }
      } catch (e) {
        _showErrorDialog('Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: isLogin ? 300 : 500,
        padding:
            const EdgeInsets.only(top: 55, left: 10, right: 10, bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 2,
              color: Colors.black,
            ),
            color: Colors.white),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 150),
        child: SingleChildScrollView(
          child: Form(
              key: _fkey,
              child: isLogin
                  ? Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Email'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter the mail address';
                            } else if (!RegExp(r'^[a-zA-Z0-9.]+@kongu.ac.in$')
                                .hasMatch(val)) {
                              return 'Enter the valid mail Id';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            email = val!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text('Password'),
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  isvisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  setState(() {
                                    isvisible = !isvisible;
                                  });
                                },
                              )),
                          obscureText: isvisible,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter the password';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            pass = val!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: submit,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : const Text('Login')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    isLogin = false;
                                  });
                                },
                                child: const Text('Create an Account')),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) =>
                                              ForgetPassScreen()));
                                },
                                child: const Text('Forget Password')),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Category'),
                          ),
                          items: types,
                          onChanged: (val) {
                            setState(() {
                              type = val as String;
                            });
                          },
                          onSaved: (val) {
                            type = val as String;
                          },
                          validator: (value) =>
                              value == null ? "Select type" : null,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Name'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter the name';
                            } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(val)) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            name = val!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Faculty Id'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter the Faculty Id';
                            } else if (!RegExp(r'^KEC[0-9]{4}$')
                                .hasMatch(val)) {
                              return 'Enter a valid Faculty No';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            staffid = val!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Department'),
                          ),
                          items: department,
                          onChanged: (val) {
                            setState(() {
                              dept = val as String;
                            });
                          },
                          validator: (value) =>
                              value == null ? "Select Department" : null,
                          onSaved: (val) {
                            dept = val as String;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        type == '1'
                            ? SizedBox(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('Students addmission year'),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Enter the addmission year';
                                        } else if (!RegExp(r'^[0-9]{4}')
                                            .hasMatch(val)) {
                                          return 'Enter a valid year';
                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        stuyear = val!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('Year'),
                                      ),
                                      items: y,
                                      onChanged: (val) {
                                        setState(() {
                                          year = val as String;
                                        });
                                      },
                                      onSaved: (val) {
                                        year = val as String;
                                      },
                                      validator: (value) =>
                                          value == null ? "Select year" : null,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('Section'),
                                      ),
                                      items: sec,
                                      onChanged: (val) {
                                        setState(() {
                                          section = val as String;
                                        });
                                      },
                                      onSaved: (val) {
                                        section = val as String;
                                      },
                                      validator: (value) => value == null
                                          ? "Select Section"
                                          : null,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('Semester'),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Enter semester';
                                        } else if (!RegExp(r'^[1-8]{1}')
                                            .hasMatch(val)) {
                                          return 'Enter a valid semester';
                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        sem = val!;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Email'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter the mail address';
                            } else if (!RegExp(r'^[a-zA-Z0-9.]+@kongu.ac.in$')
                                .hasMatch(val)) {
                              return 'Enter a Kongu.ac.in mail Id';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            email = val!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: pc,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              label: const Text('Password'),
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  isvisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  setState(() {
                                    isvisible = !isvisible;
                                  });
                                },
                              )),
                          obscureText: isvisible,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter the password';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            pass = val!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Confirm Password'),
                          ),
                          obscureText: isvisible,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter the password';
                            } else if (!(val == pc.text)) {
                              return 'Password doesn\'t match';
                            }
                            return null;
                          },
                          onSaved: (val) {
                            pass = val!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                              onPressed: submit,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.black,
                                    )
                                  : const Text('Sign Up')),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = true;
                              });
                            },
                            child: const Text('Login to existing account')),
                      ],
                    )),
        ));
  }
}
