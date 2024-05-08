import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/update-info/remote/bloc/remote_update_info_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
                dialogType: DialogType.info,
                title:
                    'Vui lòng hãy kiểm tra hộp thư để xác nhận trước khi cập nhật email',
                btnOkText: 'OK',
                btnOkColor: Colors.blue,
                btnOkOnPress: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );

                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: '',
                  );

                  if (!await launchUrl(emailLaunchUri)) {
                    throw Exception('Could not launch $emailLaunchUri');
                  }
                },
                headerAnimationLoop: false,
              ).show();
            }
          },
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                context.read<UpdateInfoBloc>().add(UpdateEmail(email!));
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
                validator: (email) {
                  if (email?.isEmpty ?? true) {
                    return 'HÃY NHẬP EMAIL MỚI';
                  }

                  if (!EmailValidator.validate(email!)) {
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
      ),
    );
  }
}
