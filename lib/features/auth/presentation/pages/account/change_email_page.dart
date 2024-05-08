import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  String? email;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Cập nhật email',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
            }
          },
          child: const Text(
            'Lưu',
            style: TextStyle(color: Colors.indigo),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (email) {
                if (email?.isEmpty ?? true) {
                  return 'HÃY NHẬP EMAIL MỚI';
                }

                if (EmailValidator.validate(email!)) {
                  return 'EMAIL KHÔNG HỢP LỆ';
                }

                return null;
              },
              onSaved: (newValue) => email = newValue,
              decoration: InputDecoration(
                hintText: 'Email mới',
                focusedBorder: const UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            )
          ],
        ),
      ),
    );
  }
}
