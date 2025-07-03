import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../../amplifyconfiguration.dart';

Future<void>configureAmplify() async {
  await Amplify.addPlugin(AmplifyAuthCognito());
  try {
    await Amplify.configure(amplifyconfig);
    log('Amplify configured successfully');
  } on AuthException catch (e) {
    log('Error configuring Amplify: ${e.message}');
  } catch (e) {
    log('Error configuring Amplify: $e');
  }
}


