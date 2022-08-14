import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ForgetPassScreen extends StatelessWidget {
  final _fkey = GlobalKey<FormState>();
  String email = '';
  ForgetPassScreen({Key? key}) : super(key: key);

  void submit(BuildContext context) async {
    if (!_fkey.currentState!.validate()) {
      return;
    }
    _fkey.currentState!.save();
    try {
      // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset mail sent')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Form(
        key: _fkey,
        child: Column(
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
            ElevatedButton(
                onPressed: () => submit(context),
                child: const Text('ResetPassword')),
          ],
        ),
      )),
    );
  }
}
