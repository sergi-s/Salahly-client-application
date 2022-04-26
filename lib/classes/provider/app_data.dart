import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

enum AppState {
  initialState,
  loggedIn,
  normal,
  requestingAssistance,
}

class SalahlyClient {
  AppState? _appState = AppState.initialState;
  late RequestType? _requestType;
  late String? _requestID;

  AppState? get appState => _appState;

  RequestType? get requestType => _requestType;

  String? get requestID => _requestID;

  SalahlyClient(
      {AppState? appState, RequestType? requestType, String? requestID}) {
    _appState = appState ?? AppState.initialState;
    _requestType = requestType;
    _requestID = requestID ?? "";
  }

  SalahlyClient copyWith(
          {AppState? appState, RequestType? requestType, String? requestID}) =>
      SalahlyClient(
          appState: appState ?? _appState,
          requestType: requestType ?? _requestType,
          requestID: requestID ?? _requestID);
}

final salahlyClientProvider =
    StateNotifierProvider<SalahlyClientNotifier, SalahlyClient>((ref) {
  return SalahlyClientNotifier();
});

class SalahlyClientNotifier extends StateNotifier<SalahlyClient> {
  SalahlyClientNotifier() : super(SalahlyClient());

  assignRequest(RequestType requestType, String requestID) =>
      state = state.copyWith(
          requestID: requestID,
          requestType: requestType,
          appState: AppState.requestingAssistance);
}
