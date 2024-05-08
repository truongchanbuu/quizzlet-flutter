import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/update-info/remote/bloc/remote_update_info_bloc.dart';

class ChangeUserNamePage extends StatefulWidget {
  const ChangeUserNamePage({super.key});

  @override
  State<ChangeUserNamePage> createState() => _ChangeUserNamePageState();
}

class _ChangeUserNamePageState extends State<ChangeUserNamePage> {
  String? username;

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
        'Đổi tên người dùng mới',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        BlocListener<UpdateInfoBloc, UpdateInfoState>(
          listener: (context, state) {
            print(state);
          },
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                context.read<UpdateInfoBloc>().add(UpdateUserName(username!));
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
                validator: (username) {
                  if (username?.isEmpty ?? true) {
                    return 'HÃY NHẬP USERNAME MỚI';
                  }

                  return null;
                },
                onSaved: (newValue) => username = newValue,
                decoration: InputDecoration(
                  hintText: 'Tên người dùng mới',
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
