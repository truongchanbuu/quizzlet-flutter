import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signup/remote/remote_signup_bloc.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignUpPage extends StatefulWidget {
  final UserRepository userRepository;
  const SignUpPage({super.key, required this.userRepository});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;
  String? email;
  String? userName;
  String? password;
  String? confirmedPassword;
  DateTime? userBirthday;
  late final TextEditingController dateController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    dateController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar();
  }

  _buildBody() {
    return BlocProvider(
      create: (context) => SignUpBloc(widget.userRepository),
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ĐĂNG NHẬP NHANH BẰNG'),
                    const SizedBox(height: 10),
                    _buildSignInMethodsWidget(),
                    const SizedBox(height: 20),
                    const Text('HOẶC ĐĂNG KÝ BẰNG EMAIL'),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: _validateEmail,
                      onSaved: (newValue) => email = newValue,
                      onChanged: (value) => email = value,
                      decoration: const InputDecoration(
                        labelText: 'ĐỊA CHỈ EMAIL',
                        hintText: 'abc@example.com',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: _validateName,
                      onSaved: (newValue) => userName = newValue,
                      onChanged: (value) => userName = value,
                      decoration: const InputDecoration(
                        labelText: 'TÊN NGƯỜI DÙNG',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: _validatePassword,
                      onSaved: (newValue) => password = newValue,
                      onChanged: (value) => password = value,
                      obscureText: _isHiddenPassword,
                      decoration: InputDecoration(
                        labelText: 'MẬT KHẨU',
                        border: const OutlineInputBorder(),
                        suffixIcon: _isHiddenPassword
                            ? IconButton(
                                onPressed: _changeIsHiddenPasswordState,
                                icon: const Icon(Icons.visibility))
                            : IconButton(
                                onPressed: _changeIsHiddenPasswordState,
                                icon: const Icon(Icons.visibility_off)),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: _validateConfirmedPassword,
                      onSaved: (newValue) => confirmedPassword = newValue,
                      onChanged: (value) => confirmedPassword = value,
                      obscureText: _isHiddenConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'XÁC NHẬN MẬT KHẨU',
                        border: const OutlineInputBorder(),
                        suffixIcon: _isHiddenConfirmPassword
                            ? IconButton(
                                onPressed: _changeIsHiddenConfirmPasswordState,
                                icon: const Icon(Icons.visibility))
                            : IconButton(
                                onPressed: _changeIsHiddenConfirmPasswordState,
                                icon: const Icon(Icons.visibility_off)),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: dateController,
                      validator: _validateBirthday,
                      onTap: () async {
                        userBirthday = await _showDatePicker();

                        if (userBirthday != null) {
                          dateController.text =
                              DateFormat('dd-MM-yyyy').format(userBirthday!);
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'NGÀY THÁNG NĂM SINH',
                        hintText: 'DD-MM-YYYY',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: _submitSignUpForm,
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: Colors.indigo,
                      ),
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPolicyAlertText(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildSignInMethodsWidget() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SignInButton(
            Buttons.google,
            onPressed: () {},
            elevation: 0,
            text: 'Google',
            padding: const EdgeInsets.all(20),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 1,
          child: SignInButton(
            Buttons.facebook,
            onPressed: () {},
            elevation: 0,
            text: 'Facebook',
            padding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }

  _buildPolicyAlertText() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Bằng việc đăng ký, tôi chấp thuận ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'Điều khoản dịch vụ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: ' và ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'Chính sách quyền riêng tư',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: ' của Quizzlet',
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Future<DateTime?> _showDatePicker() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now(),
    );
  }

  // State methods
  _changeIsHiddenPasswordState() {
    setState(() => _isHiddenPassword = !_isHiddenPassword);
  }

  _changeIsHiddenConfirmPasswordState() {
    setState(() => _isHiddenConfirmPassword = !_isHiddenConfirmPassword);
  }

  // Handle data
  String? _validateEmail(String? email) {
    if (email?.isEmpty ?? true) {
      return 'EMAIL KHÔNG ĐƯỢC ĐỂ TRỐNG';
    }

    if (!EmailValidator.validate(email!)) {
      return 'EMAIL NÀY KHÔNG HỢP LỆ';
    }

    return null;
  }

  String? _validatePassword(String? password) {
    RegExp passwordRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$');

    if (!passwordRegex.hasMatch(password ?? '')) {
      return "MẬT KHẨU PHẢI CÓ ÍT NHẤT 1 CHỮ IN HOA, 1 CHỮ 1 THƯỜNG, 1 KÝ TỰ ĐẶC BIỆT VÀ DÀI ÍT NHẤT 8 KÝ TỰ";
    }

    return null;
  }

  String? _validateName(String? name) {
    if (name?.isEmpty ?? true) {
      return 'HÃY NHẬP TÊN CỦA BẠN';
    }

    return null;
  }

  String? _validateConfirmedPassword(String? confirmed) {
    if (confirmed?.isEmpty ?? true) {
      return "HÃY XÁC NHẬN LẠI MÂT KHẨU";
    }

    if (confirmed != password) {
      return 'MẬT KHẨU XÁC NHẬN KHÔNG KHỚP';
    }

    return null;
  }

  String? _validateBirthday(String? birthday) {
    if (birthday?.isEmpty ?? true) {
      return 'HÃY CHỌN NGÀY THÁNG NĂM SINH';
    }

    return null;
  }

  _submitSignUpForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
    }
  }
}
