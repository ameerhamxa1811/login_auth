import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_bloc/auth_bloc.dart';
import 'auth_bloc/auth_event.dart';
import 'auth_bloc/auth_state.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Authentication')),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthFaceLock) {
              context.read<AuthBloc>().add(FingerprintFailed());
            } else if (state is AuthPinLock) {
              // Trigger PIN Lock
            } else if (state is AuthLoginScreen) {
              context.read<AuthBloc>().add(ValidatePassword());
            }
          },
          builder: (context, state) {
            if (state is AuthInitial) {
              return ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(StartAuthentication());
                },
                child: Text("Authenticate"),
              );
            } else if (state is AuthFingerprint) {
              return Text("Fingerprint authentication in progress...");
            } else if (state is AuthFaceLock) {
              return Text("Face authentication in progress...");
            } else if (state is AuthPinLock) {
              return Text("PIN authentication in progress...");
            } else if (state is AuthSuccess) {
              return Text(state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
