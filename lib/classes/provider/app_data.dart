import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slahly/classes/firebase/roadsideassistance/roadsideassistance.dart';
import 'package:slahly/utils/constants.dart';

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

  @override
  String toString() {
    String strAppState =
        (_appState != null) ? appStateToString(_appState!) : "no app state";
    String strRequestType = (_requestType != null)
        ? RSA.requestTypeToString(_requestType!)
        : "no request";
    String strRequestID =
        (_requestID != null) ? (_requestID).toString() : "no request ID";
    return "App State:$strAppState\nRequest Type:$strRequestType\nRequest ID:$strRequestID";
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

  deAssignRequest() async {
    state = SalahlyClient(appState: AppState.normal);
    final prefs = await SharedPreferences.getInstance();

    prefs.remove("requestID");
    prefs.remove("requestType");
    prefs.setString(
        "appState", SalahlyClient.appStateToString(AppState.normal));
    prefs.remove("mechanic");
    prefs.remove("towProvider");
    print("SHARED PREF SHOUD BE DELETED");
  }

  getSavedData() async {
    print("GET SAVED DATA FROM SHARED PREF");
    final prefs = await SharedPreferences.getInstance();
    bool alive = false;
    if (prefs.getString('requestID') != null &&
        prefs.getString('requestID') != null) {
      alive = await isAlive(prefs.getString('requestID')!,
          RSA.stringToRequestType(prefs.getString('requestType') ?? "null")!);
    }
    if (!alive) {
      return state;
    }
    state = state.copyWith(
        appState: SalahlyClient.stringToAppState(prefs.getString('appState')),
        requestType:
            RSA.stringToRequestType(prefs.getString('requestType') ?? "null"),
        requestID: prefs.getString('requestID'));
    state.toString();
    print(state.appState);
    print(state.requestType);
    print(state.requestID);
  }

  Future<bool> isAlive(String id, RequestType requestType) async {
    DatabaseReference localRef = state.requestType == RequestType.WSA
        ? wsaRef
        : (state.requestType == RequestType.RSA)
            ? rsaRef
            : ttaRef;

    DataSnapshot ds = await localRef.child(id).get();
    if (ds.value != null &&
        ds.value.toString() != "" &&
        ds.value.toString() != "null") {
      print("is alive alive alive alive ${ds.value.toString()}");
      return true;
    }
    return false;
  }
}
