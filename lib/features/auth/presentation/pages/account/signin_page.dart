import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/common/common.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.userRepository});
  final UserRepository userRepository;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final GlobalKey<FormState> _formKey;
  late final FlutterSecureStorage storage;

  // State
  bool _isHiddenPassword = false;

  // Info
  String? accessToken;
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    storage = GetIt.instance.get<FlutterSecureStorage>();
    getAccessToken();
  }

  void getAccessToken() async {
    accessToken = await storage.read(key: 'accessToken');
  }

  @override
  void dispose() {
    super.dispose();
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
      create: (context) => AuthenticationBloc(widget.userRepository),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.user != null || accessToken != null) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ĐĂNG NHẬP NHANH BẰNG'),
                  const SizedBox(height: 10),
                  buildSignInMethodsWidget(widget.userRepository),
                  const SizedBox(height: 20),
                  const Text('HOẶC ĐĂNG NHẬP BẰNG EMAIL'),
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
                  TextButton(
                    onPressed: () => _submitSignInForm(context),
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.indigo,
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: buildPolicyAlertText(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Validation methods
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

  // State methods
  _changeIsHiddenPasswordState() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  // Handle Data
  _submitSignInForm(BuildContext context) {}
}
