import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/core/util/shared_preference_util.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_event.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/remote_signout_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/remote_signout_event.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/remote_signout_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/update-info/remote/remote_update_info_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/change_email_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/change_password_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/change_username_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/welcome_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/re-auth_form.dart';
import 'package:sign_in_button/sign_in_button.dart';

class DetailInfoPage extends StatefulWidget {
  final User user;
  const DetailInfoPage({super.key, required this.user});

  @override
  State<DetailInfoPage> createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance.get<SignOutBloc>(),
      child: BlocConsumer<SignOutBloc, SignOutState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            deleteToken();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomePage(),
              ),
              (route) => false,
            );
          } else if (state is SignOutFailed) {
            AwesomeDialog(
              context: context,
              padding: const EdgeInsets.all(10),
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
              onTap: () => _showReAuthenticateModal(context, 'username'),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              highlightColor: Colors.grey.withOpacity(0.5),
              child: ListTile(
                title: const Text('Tên người dùng'),
                subtitle: Text(widget.user.displayName ?? 'User'),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          const Divider(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showReAuthenticateModal(context, 'email'),
              highlightColor: Colors.grey.withOpacity(0.5),
              child: ListTile(
                title: const Text('Email'),
                subtitle: Text(widget.user.email!),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          const Divider(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showReAuthenticateModal(context, 'password'),
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

  _showReAuthenticateModal(BuildContext context, String infoType) {
    var providerId = widget.user.providerData[0].providerId;
    String title;
    if (infoType == 'username') {
      title = 'Đổi tên người dùng';
    } else if (infoType == 'email') {
      title = 'Cập nhật email';
    } else if (infoType == 'password') {
      title = 'Đặt lại mật khẩu';
    } else {
      title = 'Invalid Type';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => BlocProvider(
        create: (context) => GetIt.instance.get<AuthenticationBloc>(),
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.status == AuthenticationStatus.reAuthSuccess) {
              switch (infoType) {
                case 'username':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) =>
                                  GetIt.instance.get<UpdateInfoBloc>(),
                              child: const ChangeUserNamePage(),
                            ),
                        settings:
                            const RouteSettings(name: '/change_username')),
                  );
                  break;
                case 'email':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            GetIt.instance.get<UpdateInfoBloc>(),
                        child: const ChangeEmailPage(),
                      ),
                    ),
                  );
                  break;
                case 'password':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) =>
                            GetIt.instance.get<UpdateInfoBloc>(),
                        child: const ChangePasswordPage(),
                      ),
                    ),
                  );
                  break;
              }
            } else if (state.status == AuthenticationStatus.reAuthFailed) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                padding: const EdgeInsets.all(10),
                headerAnimationLoop: false,
                title: 'Xác thực không thành công',
                desc: 'Người dùng không có quyền thực hiện hành động này',
                btnCancelText: 'OK',
                btnCancelOnPress: () {},
              ).show();
            }
          },
          builder: (context, state) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
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
                        const SizedBox(height: 10),
                        const Text(
                            'Để chắc rằng đây là bạn, vui lòng xác thực một lần nữa'),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: _buildReAuthButton(context, providerId),
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
                              ),
                            ),
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
      ),
    );
  }

  _buildReAuthButton(BuildContext ctx, String providerId) {
    return SignInButton(
      providerId == 'google.com'
          ? Buttons.google
          : (providerId == 'facebook.com' ? Buttons.facebook : Buttons.email),
      onPressed: () {
        switch (providerId) {
          case 'google.com':
            ctx
                .read<AuthenticationBloc>()
                .add(const ReAuthenticateGoogleUser());
            break;
          case 'facebook.com':
            ctx
                .read<AuthenticationBloc>()
                .add(const ReAuthenticateFacebookUser());
            break;
          default:
            showDialog(
              context: context,
              builder: (context) => ReAuthEmailPasswordDialog(
                onSubmit: (String email, String password) {
                  ctx
                      .read<AuthenticationBloc>()
                      .add(ReAuthenticatePasswordUser(email, password));
                },
              ),
            );

            break;
        }
      },
      text: providerId == 'google.com'
          ? 'Tiếp tục với Google'
          : (providerId == 'facebook.com'
              ? 'Tiếp tục với Facebook'
              : 'Xác thực lại tài khoản'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(20),
    );
  }
}
