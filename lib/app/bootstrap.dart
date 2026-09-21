import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flixora/app/flixora_app.dart';
import 'package:flixora/data/repositories/tmdb_repository.dart';
import 'package:flixora/data/services/api_client.dart';
import 'package:flixora/app/config_app.dart';

void bootstrap() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Keep native splash visible until our in-app splash takes over
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final repository = TmdbRepository(ApiClient(token: AppConfig.tmdbToken));
  unawaited(repository.loadImageConfiguration());
  runApp(FlixoraApp(repository: repository));
}
