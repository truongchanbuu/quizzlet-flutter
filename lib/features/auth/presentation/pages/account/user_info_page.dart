import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_state.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/detail_info_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/streak_section.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar();
  }

  _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance.get<AuthenticationBloc>(),
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state.user == null ||
              state.status == AuthenticationStatus.unauthenticated) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
        builder: (context, state) {
          var user = state.user;

          if (user == null) {
            return const LoadingIndicator();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.photoURL ?? '',
                          placeholder: (context, url) => const CircleAvatar(
                            radius: 40,
                            child: LoadingIndicator(),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blue,
                            child: Text(
                              (user.displayName ?? 'User')[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.displayName ?? 'User',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {},
                      contentPadding: const EdgeInsets.all(10),
                      tileColor: Colors.white,
                      title: const Text('Thêm khóa học'),
                      leading: const Icon(Icons.book),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () => _navigateToDetailInfo(context, user),
                      contentPadding: const EdgeInsets.all(10),
                      tileColor: Colors.white,
                      title: const Text('Cài đặt của bạn'),
                      leading: const Icon(Icons.settings),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const StreakDaySection(streakDays: 2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Navigation
  _navigateToDetailInfo(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailInfoPage(
          user: user,
        ),
        settings: const RouteSettings(name: 'account/detail-page'),
      ),
    );
  }
}
