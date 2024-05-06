import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signup/remote/remote_signup_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/common.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final UserRepository userRepository;

  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  // Info
  String? email;
  String? userName;
  String? password;
  String? confirmedPassword;
  DateTime? userBirthday;

  // Controllers
  late final TextEditingController dateController;

  // Key
  late final GlobalKey<FormState> _formKey;

  // Error message
  String? emailErrorMessage;

  @override
  void initState() {
    super.initState();
    userRepository = GetIt.instance.get<UserRepository>();
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
      create: (context) => GetIt.instance.get<SignUpBloc>(),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        builder: (context, state) {
          if (state.status == SignUpStatus.loading) {
            return const LoadingIndicator();
          }

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
                    const Text('HOẶC ĐĂNG KÝ BẰNG EMAIL'),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (email) => _validateEmail(context, email),
                      onSaved: (newValue) => email = newValue,
                      onChanged: (value) => email = value,
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
                      onTap: _handleUserBirthday,
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
                      onPressed: () => _submitSignUpForm(context),
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
                    Center(
                      child: buildPolicyAlertText(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, SignUpState state) {
          if (state.status == SignUpStatus.emailExisted) {
            emailErrorMessage = 'EMAIL NÀY ĐÃ ĐƯỢC SỬ DỤNG';
          } else if (state.status == SignUpStatus.emailNotExisted) {
            emailErrorMessage = null;
          } else if (state.status == SignUpStatus.failed) {
            SchedulerBinding.instance.addPostFrameCallback((_) => AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.leftSlide,
                  headerAnimationLoop: false,
                  title: 'ĐĂNG KÝ KHÔNG THÀNH CÔNG',
                  dismissOnTouchOutside: false,
                  desc: 'Đã có lỗi xảy ra trong quá trình đăng ký...',
                  btnCancelOnPress: () {},
                  btnCancelText: 'OK',
                ).show());
          } else if (state.status == SignUpStatus.success) {
            SchedulerBinding.instance.addPostFrameCallback((_) => AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.leftSlide,
                  headerAnimationLoop: false,
                  dismissOnTouchOutside: false,
                  title: 'ĐĂNG KÝ THÀNH CÔNG',
                  desc: 'Chúc mừng bạn đã đăng ký thành công',
                  btnOkOnPress: () => signInSuccess(context),
                  btnOkText: 'ĐI ĐẾN MÀN HÌNH CHÍNH',
                ).show());
          }
        },
      ),
    );
  }

  Future<void> _handleUserBirthday() async {
    userBirthday = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now(),
    );

    if (userBirthday != null) {
      dateController.text = DateFormat('dd-MM-yyyy').format(userBirthday!);
    }
  }

  // State methods
  _changeIsHiddenPasswordState() {
    setState(() => _isHiddenPassword = !_isHiddenPassword);
  }

  _changeIsHiddenConfirmPasswordState() {
    setState(() => _isHiddenConfirmPassword = !_isHiddenConfirmPassword);
  }

  // Validation methods
  String? _validateEmail(BuildContext context, String? email) {
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

  // Handle data
  _submitSignUpForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      UserModel user = UserModel(
        email: email!,
        password: password!,
        dateOfBirth: userBirthday,
        username: userName,
      );
      context.read<SignUpBloc>().add(SubmitSignUp(user));
    }
  }
}
