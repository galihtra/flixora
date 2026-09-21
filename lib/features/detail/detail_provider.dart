import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/models.dart';
import '../../data/api.dart';

class DetailProvider extends ChangeNotifier {
  DetailProvider(this._repository, this.type, this.id);
  final MediaRepository _repository;
  final MediaType type;
  final int id;
  MediaDetail? detail;
  bool loading = false;
  AppException? error;
  CancelToken? _cancelToken;
  bool _disposed = false;

  Future<void> load() async {
    if (loading) return;
    loading = true;
    error = null;
    _cancelToken = CancelToken();
    notifyListeners();
    try {
      detail = await _repository.detail(type, id, cancelToken: _cancelToken);
    } catch (caught) {
      if (caught is DioException && CancelToken.isCancel(caught)) return;
      error = ApiErrorMapper.map(caught);
    } finally {
      loading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelToken?.cancel();
    super.dispose();
  }
}
