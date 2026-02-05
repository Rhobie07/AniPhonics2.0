import 'package:flutter/material.dart';

import 'app.dart';
import 'core/progress/progress_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressStore.init();
  runApp(const AniPhonicsApp());
}
