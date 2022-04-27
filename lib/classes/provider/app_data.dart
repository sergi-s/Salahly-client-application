import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';

enum AppState {
  initialState,
  loggedIn,
  normal,
  requestingAssistance,
}

class SalahlyClient {
  AppState? _appState = AppState.initialState;
  late  RequestType? _requestType;
  late String? _requestID;

  AppState? get appState => _appState;

  RequestType? get requestType => _requestType;

  String? get requestID => _requestID;

  SalahlyClient(
      {AppState? appState, RequestType? requestType, String? requestID}) {
    _appState = appState ?? AppState.initialState;
    _requestType = requestType;
    _requestID = requestID;
  }

  SalahlyClient copyWith(
          {AppState? appState, RequestType? requestType, String? requestID}) =>
      SalahlyClient(
          appState: appState ?? _appState,
          requestType: requestType ?? _requestType,
          requestID: requestID ?? _requestID);

  static String appStateToString(AppState appState) {
    return (appState.toString()).isNotEmpty
        ? (appState.toString().substring(9))
        : "";
  }

  static AppState? stringToAppState(String? id) {
    if (id == SalahlyClient.appStateToString(AppState.normal)) {
      return AppState.normal;
    } else if (id == SalahlyClient.appStateToString(AppState.initialState)) {
      return AppState.initialState;
    } else if (id == SalahlyClient.appStateToString(AppState.loggedIn)) {
      return AppState.loggedIn;
    } else if (id ==
        SalahlyClient.appStateToString(AppState.requestingAssistance)) {
      return AppState.requestingAssistance;
    }
    return null;
  }
}

final salahlyClientProvider =
    StateNotifierProvider<SalahlyClientNotifier, SalahlyClient>((ref) {
  return SalahlyClientNotifier();
});

class SalahlyClientNotifier extends StateNotifier<SalahlyClient> {
  SalahlyClientNotifier() : super(SalahlyClient());

  assignRequest(RequestType requestType, String requestID) async {
    state = state.copyWith(
        requestID: requestID,
        requestType: requestType,
        appState: AppState.requestingAssistance);
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("requestID", requestID);
    prefs.setString("requestType", RSA.requestTypeToString(requestType));
    prefs.setString("appState",
        SalahlyClient.appStateToString(AppState.requestingAssistance));
  }

  deAssignRequest() {
    state = SalahlyClient(appState: AppState.normal);
  }

  getSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    state = state.copyWith(
        appState: SalahlyClient.stringToAppState(prefs.getString('appState')),
        requestType:
            RSA.stringToRequestType(prefs.getString('requestType') ?? "null"),
        requestID: prefs.getString('requestID'));
  }
}
