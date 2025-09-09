import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final MovieBloc movieBloc;

  ConnectivityService({required this.movieBloc});

  void startMonitoring() {
    _subscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;

      if (result != ConnectivityResult.none) {
        movieBloc.add(FetchTrendingMovies());
        movieBloc.add(FetchNowPlayingMovies());
      }
    });
  }

  void stopMonitoring() {
    _subscription?.cancel();
  }
}
