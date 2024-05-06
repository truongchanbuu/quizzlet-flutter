import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/core/util/shared_preference_util.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/bloc/remote_signout_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/bloc/remote_signout_event.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/bloc/remote_signout_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/update-info/remote/bloc/remote_update_info_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:sign_in_button/sign_in_button.dart';

class DetailInfoPage extends StatelessWidget {
  final User user;
  const DetailInfoPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.instance.get<SignOutBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.instance.get<UpdateInfoBloc>(),
        )
      ],
      child: BlocConsumer<SignOutBloc, SignOutState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            deleteAccessToken();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          } else if (state is SignOutFailed) {
            AwesomeDialog(
              context: context,
              title: 'Đăng xuất thất bại',
              headerAnimationLoop: false,
              dialogType: DialogType.error,
              btnCancelOnPress: () {},
            ).show();
          }
        },
        builder: (BuildContext context, SignOutState state) {
          if (state is SignOutLoading) {
            return const LoadingIndicator();
          }

          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _buildAppBar(),
            body: _buildBody(context),
          );
        },
      ),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Cài đặt',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  _buildBody(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thông tin cá nhân'),
            const SizedBox(height: 10),
            _buildInfoSection(context),
            const SizedBox(height: 30),
            _buildLogOutButton(context),
          ],
        ),
      ),
    );
  }

  _buildInfoSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () =>
                  _showReAuthenticateModal(context, 'Đổi tên người dùng'),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              highlightColor: Colors.grey.withOpacity(0.5),
              child: ListTile(
                title: const Text('Tên người dùng'),
                subtitle: Text(user.displayName ?? 'User'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          const Divider(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showReAuthenticateModal(context, 'Đặt lại email'),
              highlightColor: Colors.grey.withOpacity(0.5),
              child: ListTile(
                title: const Text('Email'),
                subtitle: Text(user.email!),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          const Divider(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () =>
                  _showReAuthenticateModal(context, 'Đặt lại mật khẩu'),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              highlightColor: Colors.grey.withOpacity(0.5),
              child: const ListTile(
                title: Text('Đặt lại mật khẩu'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildLogOutButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<SignOutBloc>().add(SignOutRequired());
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: const BorderSide(
            color: Colors.black,
            // width: 1,
          ),
        ),
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text(
        'Đăng xuất',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  _showReAuthenticateModal(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => BlocConsumer<UpdateInfoBloc, UpdateInfoState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(context);
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                          'Để xác thực đây là bạn, vui lòng xác thực một lần nữa bằng tài khoản Google'),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: SignInButton(
                          Buttons.google,
                          onPressed: () {
                            print(context);
                          },
                          text: 'Tiếp tục với Google',
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
