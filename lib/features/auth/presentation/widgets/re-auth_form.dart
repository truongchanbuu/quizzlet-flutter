import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class ReAuthEmailPasswordDialog extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  const ReAuthEmailPasswordDialog({super.key, required this.onSubmit});

  @override
  State<ReAuthEmailPasswordDialog> createState() =>
      _ReAuthEmailPasswordDialogState();
}

class _ReAuthEmailPasswordDialogState extends State<ReAuthEmailPasswordDialog> {
  late final GlobalKey<FormState> _formKey;

  bool _isHidden = true;

  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác thực lại danh tính'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (email) {
                  if (email?.isEmpty ?? true) {
                    return 'EMAIL KHÔNG ĐƯỢC ĐỂ TRỐNG';
                  }

                  if (!EmailValidator.validate(email!)) {
                    return 'EMAIL KHÔNG HỢP LỆ';
                  }

                  return null;
                },
                onSaved: (email) => this.email = email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (password) {
                  RegExp passwordRegex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$');

                  if (!passwordRegex.hasMatch(password ?? '')) {
                    return "MẬT KHẨU PHẢI CÓ ÍT NHẤT 1 CHỮ IN HOA, 1 CHỮ 1 THƯỜNG, 1 KÝ TỰ ĐẶC BIỆT VÀ DÀI ÍT NHẤT 8 KÝ TỰ";
                  }

                  return null;
                },
                onSaved: (password) => this.password = password,
                obscureText: _isHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _isHidden = !_isHidden),
                    icon: _isHidden
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              widget.onSubmit(email!, password!);
              Navigator.pop(context);
            }
          },
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
