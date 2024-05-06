import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/reset-password/remote/bloc/remote_reset_password_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signin/remote/remote_signin_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/common.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final UserRepository userRepository;

  late final GlobalKey<FormState> _formKey;
  late final FlutterSecureStorage storage;
  late final GlobalKey<FormState> _resetFormKey;

  // State
  bool _isHiddenPassword = true;

  // Info
  String? accessToken;
  String? email;
  String? password;

  // Error messages
  String? passwordErrorMessage;
  String? emailErrorMessage;

  @override
  void initState() {
    super.initState();
    userRepository = GetIt.instance.get<UserRepository>();
    _formKey = GlobalKey();
    _resetFormKey = GlobalKey();
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
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.user != null || accessToken != null) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
          },
        ),
        BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state.status == SignInStatus.success) {
              setState(() {
                emailErrorMessage = null;
                passwordErrorMessage = null;
              });
              signInSuccess(context);
            } else if (state.status == SignInStatus.wrongPassword) {
              setState(() {
                emailErrorMessage = null;
                passwordErrorMessage = state.error!.toUpperCase();
              });
            } else if (state.status == SignInStatus.emailNotFound ||
                state.status == SignInStatus.disabled) {
              setState(() {
                passwordErrorMessage = null;
                emailErrorMessage = state.error!.toUpperCase();
              });
            } else {
              SchedulerBinding.instance
                  .addPostFrameCallback((_) => AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.leftSlide,
                        headerAnimationLoop: false,
                        title: 'ĐĂNG NHẬP KHÔNG THÀNH CÔNG',
                        dismissOnTouchOutside: false,
                        desc:
                            'Đã có lỗi xảy ra trong quá trình đăng nhập: ${state.error}',
                        btnCancelOnPress: () {},
                        btnCancelText: 'OK',
                      ).show());
            }
          },
        ),
        BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state.status == ResetPasswordStatus.success) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                headerAnimationLoop: false,
                title: 'Đường link đã được gửi vào email của bạn',
                btnOkOnPress: () {
                  Navigator.pop(context);
                },
              ).show();
            } else if (state.status == ResetPasswordStatus.failed) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                headerAnimationLoop: false,
                btnCancelOnPress: () {},
                title: state.error,
              ).show();
            }
          },
        )
      ],
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar();
  }

  _buildBody(BuildContext context) {
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
              buildSignInMethodsWidget(userRepository),
              const SizedBox(height: 20),
              const Text('HOẶC ĐĂNG NHẬP BẰNG EMAIL'),
              const SizedBox(height: 10),
              TextFormField(
                validator: _validateEmail,
                onSaved: (newValue) => email = newValue,
                onChanged: (value) => email = value,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: 'ĐỊA CHỈ EMAIL',
                  hintText: 'abc@example.com',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(),
                  errorText: emailErrorMessage,
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
                  errorText: passwordErrorMessage,
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
                child: InkWell(
                  onTap: () => _showResetPasswordDialog(context),
                  child: Material(
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: buildPolicyAlertText(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showResetPasswordDialog(BuildContext context) {
    String? failedMessage;
    String? emailToReset;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đặt lại mật khẩu'),
        semanticLabel: 'Đặt lại mật khẩu',
        content: SingleChildScrollView(
          child: Form(
            key: _resetFormKey,
            child: Column(
              children: [
                const Text(
                    'Nhập email bạn dùng để đăng nhập vào Quizzlet. Chúng tôi sẽ gửi cho bạn một đường link để lấy lại mật khẩu của mình.'),
                const SizedBox(height: 10),
                TextFormField(
                  validator: _validateEmail,
                  onSaved: (newValue) => emailToReset = newValue,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'abc@example.com',
                    errorText: failedMessage,
                  ),
                  textInputAction: TextInputAction.send,
                )
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
              if (_resetFormKey.currentState?.validate() ?? false) {
                _resetFormKey.currentState?.save();
                context
                    .read<ResetPasswordBloc>()
                    .add(ResetPasswordRequired(emailToReset!));
              }
            },
            child: const Text('Reset'),
          )
        ],
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
  _submitSignInForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<SignInBloc>().add(
            SignInRequired(email: email!, password: password!),
          );
    }
  }
}
