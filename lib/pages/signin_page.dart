import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_note/providers/auth_provider.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                SizedBox.square(dimension: 32),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Input Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                SizedBox.square(dimension: 16),
                TextField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Input Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox.square(dimension: 16),
                ElevatedButton(
                  onPressed: () async {
                    _signInWithEmail();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Sign In'),
                    ),
                  ),
                ),
                SizedBox.square(dimension: 16),
                Text('or'),
                SizedBox.square(dimension: 16),
                ElevatedButton(
                  onPressed: () async {
                    _signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('Sign In with Google'),
                    ),
                  ),
                ),
                SizedBox.square(dimension: 32),
                Row(
                  children: [
                    Text('Don\'t have an account?'),
                    SizedBox.square(dimension: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _signInWithEmail() async {
    try {
      final auth = ref.read(authActionProvider.notifier);
      final result = await auth.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (mounted) {
        _showSnackbar('Sign In success as ${result.user?.email}');
        Navigator.pushNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      _showSnackbar('Sign In fail: ${e.message}');
    } catch (e) {
      _showSnackbar('Sign In fail');
    }

    emailController.clear();
    passwordController.clear();
  }

  Future _signInWithGoogle() async {
    try {
      final auth = ref.read(authActionProvider.notifier);
      final result = await auth.signInWithGoogle();

      if (result == null) {
        _showSnackbar('Sign In cancelled');
        return;
      }

      if (mounted) {
        _showSnackbar('Sign In success as ${result.user?.email}');
        Navigator.pushNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      _showSnackbar('Sign In fail: ${e.message}');
    } on PlatformException catch (e) {
      _showSnackbar('Sign In fail: ${e.message}');
    } catch (e) {
      _showSnackbar('Sign In fail: $e');
    }
  }

  _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
