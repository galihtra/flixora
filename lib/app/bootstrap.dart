import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flixora/app/flixora_app.dart';
import 'package:flixora/data/repositories/tmdb_repository.dart';
import 'package:flixora/data/services/api_client.dart';
import 'package:flixora/resources/values_app.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = TmdbRepository(ApiClient(token: AppValues.tmdbToken));
  unawaited(repository.loadImageConfiguration());
  runApp(FlixoraApp(repository: repository));
}
