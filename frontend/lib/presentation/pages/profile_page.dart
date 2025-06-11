import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/application/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authState.failure != null) {
      return Center(child: Text(authState.failure.toString()));
    }

    final user = authState.user;
    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${user.firstName} ${user.lastName}'),
            Text(user.email),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement edit functionality
              },
              child: const Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement delete account functionality
              },
              child: const Text('Delete Account'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
} 