import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/update-info/remote/remote_update_info_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isHidden = true;
  bool _isConfirmHidden = true;

  String? password;
  String? confirmed;

  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
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
        'Đặt lại mật khẩu',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        BlocListener<UpdateInfoBloc, UpdateInfoState>(
          listener: (context, state) {
            if (state is UpdateInfoFailed) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                padding: const EdgeInsets.all(10),
                headerAnimationLoop: false,
                title: 'Có lỗi xảy ra vui lòng thử lại: ${state.message}',
                btnCancelOnPress: () {},
              ).show();
            } else if (state is UpdateInfoSuccess) {
              AwesomeDialog(
                context: context,
                padding: const EdgeInsets.all(10),
                dialogType: DialogType.success,
                title: 'Đã thay đổi mật khẩu thành công',
                btnOkText: 'OK',
                btnOkOnPress: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                headerAnimationLoop: false,
              ).show();
            }
          },
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                context.read<UpdateInfoBloc>().add(UpdatePassword(password!));
              }
            },
            child: const Text(
              'Lưu',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _passwordController,
                validator: (password) {
                  RegExp passwordRegex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#$%^&*(),.?":{}|<>]).{8,}$');

                  if (!passwordRegex.hasMatch(password ?? '')) {
                    return "MẬT KHẨU PHẢI CÓ ÍT NHẤT 1 CHỮ IN HOA, 1 CHỮ 1 THƯỜNG, 1 KÝ TỰ ĐẶC BIỆT VÀ DÀI ÍT NHẤT 8 KÝ TỰ";
                  }

                  return null;
                },
                onSaved: (newValue) => password = newValue,
                obscureText: _isHidden,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Mật khẩu mới',
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  suffixIcon: _isHidden
                      ? IconButton(
                          onPressed: () {
                            setState(() => _isHidden = !_isHidden);
                          },
                          icon: const Icon(Icons.visibility))
                      : IconButton(
                          onPressed: () {
                            setState(() => _isHidden = !_isHidden);
                          },
                          icon: const Icon(Icons.visibility_off)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (confirmed) {
                  if (confirmed?.isEmpty ?? true) {
                    return 'VUI LÒNG HÃY XÁC NHẬN MẬT KHẨU';
                  }

                  if (confirmed != _passwordController.text) {
                    return 'MẬT KHẨU XÁC NHẬN KHÔNG KHỚP';
                  }

                  return null;
                },
                onSaved: (newValue) => confirmed = newValue,
                obscureText: _isConfirmHidden,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Xác nhận lại mật khẩu',
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  suffixIcon: _isConfirmHidden
                      ? IconButton(
                          onPressed: () {
                            setState(
                                () => _isConfirmHidden = !_isConfirmHidden);
                          },
                          icon: const Icon(Icons.visibility))
                      : IconButton(
                          onPressed: () {
                            setState(
                                () => _isConfirmHidden = !_isConfirmHidden);
                          },
                          icon: const Icon(Icons.visibility_off)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
