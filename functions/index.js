const admin = require("firebase-admin");
const {getMessaging} = require("firebase-admin/messaging");
const {user} = require("firebase-functions/v1/auth");


// var admin = require("firebase-admin");

// const serviceAccount = require("./salahny-6bfea-firebase-adminsdk-h27mh-9c1e802abc.json");

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
//   databaseURL: "https://salahny-6bfea-default-rtdb.firebaseio.com",
// });

const functions = require("firebase-functions");

// functions.database.extractInstanceAndPath('salahny-6bfea-default-rtdb');

// exports.addMessage = functions.https.onRequest(async (req, res) => {
//   // Grab the text parameter.
//   const original = req.query.text;
//   const writeResult = await admin.firestore().collection('messages').add({original: original});
//   // Send back a message that we've successfully written the message
//   res.json({result: `Message with ID: ${writeResult.id} added.`});
// });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
// deploy command:
/*
cd "C:\projects\flutter\slahly"
firebase deploy --only functions
firebase deploy --only functions:functionname

 */

admin.initializeApp();
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

async function sendNotificationSingleClient({token, title, body, data}) {
  const payload = {
    notification: {
      title: title, body: body,
    }, android: {
      priority: "high",
    }, data: data, token: token,
  };
  return await admin.messaging().send(payload).then((response) => {
    console.log("Successfully sent message:", response);
    return {success: true};
  }).catch((error) => {
    console.log("couldn't send:", error);
    return {error: error.code};
  });
}

async function getFCMTokenOfSingleUser(id) {
  let tokenRef = (await admin.database().ref("/FCMTokens/" + id).get());
  if (tokenRef != null) {
    return tokenRef.val();
  }
  return null;
}

async function getFCMTokensOfMultiUsers(ids) {

}

async function sendNotificationMultiClients(tokens) {

}

const RSAStates = {
  canceled: "canceled",

  requestingRSA: "requestingRSA",
  failedToRequestRSA: "failedToRequestRSA",
  created: "created", // created RSA on DB

  waitingForMechanicResponse: "waitingForMechanicResponse", //
  mechanicConfirmed: "mechanicConfirmed",
  waitingForProviderResponse: "waitingForProviderResponse",
  providerConfirmed: "providerConfirmed",
  waitingForArrival: "waitingForArrival",
  confirmedArrival: "confirmedArrival",
  done: "done",
};
Object.freeze(RSAStates);


// TODO
// Listener when user chooses certain mechanic or provider in a wsa or tta request update the state of this request in the receiverRequests table
exports.onChoosingCertainMechanicOrProviderForRequest = functions.database.ref("/{requestType}/{requestID}/{receiverResponse}/{receiverID}")
  .onUpdate(async (change, context) => {
    console.log("First line in function");
    let receiverResponse = context.params.receiverResponse;
    let receiverType = "";
    let receiverID = context.params.receiverID;
    let requestID = context.params.requestID;
    let requestType = context.params.requestType;
    let chosenWord = (await admin.database().ref(`/${requestType}/${requestID}/${receiverResponse}/${receiverID}`).get()).val();

    // Handling the case when we receive wrong data
    if (requestType !== "rsa" && requestType !== "tta" && requestType !== "wsa") {
      console.log("wrong receiver type");
      return;
    }

    if (chosenWord === "chosen" || (chosenWord === "accepted" && requestType === "rsa")) {
      console.log("Someone accepted the request");
    } else {
      return;
    }
    let mechanicAccepted = false;
    if (receiverResponse === "providersResponses") {
      receiverType = "provider";
    } else if (receiverResponse === "mechanicsResponses") {
      receiverType = "mechanic";
      mechanicAccepted = true;
    } else {
      return;
    }
    console.log("Receiver response: " + receiverResponse);
    if (requestType !== "rsa") {
      // Put this request in mechanic's requests as chosen
      await updateStateReceiversRequests({
        requestType: requestType,
        requestID: requestID,
        receiverID: receiverID,
        receiverType: receiverType,
        state: "chosen",
      });

      // Send mechanic notification that he was chosen if request is TTA or WSA
      let requestTypeFull = "Request type: " + requestType;
      let receiverIDToken = await getFCMTokenOfSingleUser(receiverID);
      let notificationPayload = {
        token: receiverIDToken,
        title: "You were chosen in a request",
        body: requestTypeFull,
        data: {"type": requestType},
      };
      // console.log(await sendNotificationSingleClient(notificationPayload));
      // console.log("Sent notification to receiver that he was chosen");
    }

  // console.log('before updating providers');

    // if accepter is mechanic, notify providers
    if (mechanicAccepted) {
      // console.log('inside if');
      // get all providers in this request
      await admin.database().ref(`/${requestType}/${requestID}/providersResponses`).once('value').then(async snapshot => {
        if(!snapshot.exists()){
          return;
        }
        // console.log('length of snapshot is: ' + snapshot.numChildren());
        snapshot.forEach( (providerSnapshot) =>  {
          // console.log('inside if 2');
          let providerID = providerSnapshot.key;
          // console.log('providerID: ' + providerID);

          // Put this request in mechanic's requests
           updateStateReceiversRequests({
            requestType: requestType,
            requestID: requestID,
            receiverID: providerID,
            receiverType: 'provider',
            state: "pending",
          });

          console.log('inside if 3');

          // Send mechanic notification
          let requestTypeFull = "Request type: " + requestType;
          getFCMTokenOfSingleUser(providerID).then(async (receiverIDToken) => {
            if (receiverIDToken != null) {
              let notificationPayload = {
                token: receiverIDToken,
                title: "Received new request",
                body: requestTypeFull,
                data: {"type": "requestType"},
              };

              console.log(await sendNotificationSingleClient(notificationPayload));
            }
            else{
              console.log('no token');
            }
            }
          );


        });
      });

      // console.log('inside if 4');

    }

    // console.log('After if');
    console.log('before making the rest not chosen');
    // update the state of not chosen mechanics in database to "not chosen"
    let stateWord = requestType !== "rsa" ? "not chosen" : "timeout";
    await (await admin.database().ref(`/${requestType}/${requestID}/${receiverResponse}`)).get().then(async (snapshot) => {
        let chosenMechanics = snapshot.val();
        if (chosenMechanics !== null) {
          for (let mechanicID in chosenMechanics) {
            if (mechanicID !== receiverID) {
              await updateStateReceiversRequests({
                requestType: requestType,
                requestID: requestID,
                receiverID: mechanicID,
                receiverType: receiverType,
                state: stateWord,
              });
            }
          }
        }
      },
    );
    console.log('after making the rest not chosen');


  });


/*
// console.log('After if');
    console.log('before making the rest not chosen');
    // update the state of not chosen mechanics in database to "not chosen"
    let stateWord = requestType !== "rsa" ? "not chosen" : "timeout";
    await (await admin.database().ref(`/${requestType}/${requestID}/${receiverResponse}`)).get().then(async (snapshot) => {
        let chosenMechanics = snapshot.val();
        if (chosenMechanics !== null) {
          for (let mechanicID in chosenMechanics) {
            if (mechanicID !== receiverID) {
              await updateStateReceiversRequests({
                requestType: requestType,
                requestID: requestID,
                receiverID: mechanicID,
                receiverType: receiverType,
                state: stateWord,
              });
            }
          }
        }
      },
    );
    console.log('after making the rest not chosen');
 */
exports.onRequestCancel = functions.database.ref("/{requestType}/{requestID}/state")
  .onUpdate(async (change, context) => {
    let requestType = context.params.requestType;
    let requestID = context.params.requestID;
    let state = change.after.val();
    if (state === "cancelled" || state === "done") {
      console.log("Request " + requestID + " was "+state);
      // update the state of all mechanics in database to "not chosen"
      await (await admin.database().ref(`/${requestType}/${requestID}/mechanicsResponses`)).get().then(async (snapshot) => {
          let mechanics = snapshot.val();
          if (mechanics !== null) {
            for (let mechanicID in mechanics) {
              await updateStateReceiversRequests({
                requestType: requestType,
                requestID: requestID,
                receiverID: mechanicID,
                receiverType: "mechanic",
                state: state,
              });
            }
          }
        },
      );
      // update the state of all providers in database to "not chosen"
      await (await admin.database().ref(`/${requestType}/${requestID}/providersResponses`)).get().then(async (snapshot) => {
          let providers = snapshot.val();
          if (providers !== null) {
            for (let providerID in providers) {
              await updateStateReceiversRequests({
                requestType: requestType,
                requestID: requestID,
                receiverID: providerID,
                receiverType: "provider",
                state: state,
              });
            }
          }
        },
      );
    }
  });


function sendLog() {
  console.log("ok");
}


// FOR FUTURE USE
async function putRequestInDBOfMechanicOrProvider({
  requestType,
  requestID,
  receiverID,
  receiverType,
  state,
}) {
  // Put this request in mechanic's requests
  await updateStateReceiversRequests({
    requestType: requestType,
    requestID: requestID,
    receiverID: receiverID,
    receiverType: receiverType,
    state: "pending",
  });


  // Send mechanic notification
  let requestTypeFull = "Request type: " + requestType;
  let receiverIDToken = await getFCMTokenOfSingleUser(receiverID);
  if (receiverIDToken == null) return;
  let notificationPayload = {
    token: receiverIDToken,
    title: "Received new request",
    body: requestTypeFull,
    data: {"type": "requestType"},
  };
  console.log(await sendNotificationSingleClient(notificationPayload)); // WRONG
}

// make a map with requestID and state which we will use at line 163 to check if an update is currently ongoing (stop till the variable is removed}
let currentRSAPreviouslyAcceptedCheckingMap = {}; // not implemented yet
exports.onMechanicOrProviderResponse = functions.database.ref("/{requests}/{receiverID}/{requestID}")
  .onUpdate(async (change, context) => {
    let requests = context.params.requests;
    let receiver = "";
    if (requests === "providersRequests") {
      receiver = "provider";
    } else if (requests === "mechanicsRequests") {
      receiver = "mechanic";
    } else {
      return;
    }
    var notificationMsg = "";

    let receiverID = context.params.receiverID;
    let requestID = context.params.requestID;
    let state = change.after.child("state").val();
    let requestType = change.after.child("type").val();
    let responses = receiver + "sResponses";
    /*  console.log("REACHED: "+1);
     console.log("requests: "+requests);
     console.log("receiver: "+receiver);
     console.log("receiverID: "+receiverID);
     console.log("requestID: "+requestID);
     console.log("state: "+state);
     console.log("requestType: "+requestType);
     console.log("responses: "+responses); */
    // if request type is rsa we need to make only 1 mechanic accept, and update it in rsa
    if (requestType === "rsa" && (state === "accepted" )) { //|| state === "rejected"
      // check if anyone accepted before,
      let someoneAccepted = false;

       // await ( admin.database().ref(`/${requestType}/${requestID}/${responses}`)).get().then(async (snapshot) => {
       //  let chosenMechanics = snapshot.val();
       //  if (chosenMechanics !== null) {
       //    for (let mechanicID in chosenMechanics) {
       //      if(mechanicID === receiverID) continue;
       //      let response = snapshot.child(mechanicID).val();
       //      if (response === "accepted") {
       //        someoneAccepted = true;
       //        break;
       //      }
       //    }
       //  }
      // });
      let idsSnapshot = await admin.database().ref("/rsa/" + requestID + "/" + responses).get();
      (await idsSnapshot).forEach((idSnap => {
        let response = idSnap.val();
        if (response === "accepted" && receiverID !== idSnap && receiverID !== idSnap.key) {
          someoneAccepted = true;
        }
      }));

      // if someone accepted, timeout the request to the receiver
      if (someoneAccepted) {
        return await updateStateReceiversRequests({
          requestType: requestType,
          requestID: requestID,
          receiverID: receiverID,
          receiverType: receiver,
          state: "timeout",
        });
      }
      // if no one accepted, save the receiver acceptance
      else {
        await idsSnapshot.child(receiverID).ref.set("accepted");
        // Change state of RSA to RSAStates.waitingForProviderResponse
        await admin.database().ref("/rsa/" + requestID + "/state").ref.set(RSAStates.waitingForProviderResponse);
        // notify user that we found a mechanic or a provider
        let userID = (await idsSnapshot.ref.parent.parent.child("userID").get()).val();
        let userToken = await getFCMTokenOfSingleUser(userID);
        if (!userToken) return;
        return await sendNotificationSingleClient({
          token: userToken,
          title: "Road side assistance request",
          body: "Found a nearby available " + receiver,
          data: {
            requestType: requestType,
            requestID: requestID,
            accepterType: receiver,
            accepterID: receiverID,
          },
        });
      }
    } else if ((requestType === "wsa" || requestType === "tta") && (state === "accepted" || state === "rejected")) {
      notificationMsg = requestType === "wsa" ? "Work shop assistance request" : "Tow truck assistance request";

      // Sync mechanic/provider response in request table
      await admin.database().ref("/" + requestType + "/" + requestID + "/" + responses + "/" + receiverID).ref.set(state);
      // notify user that we found a mechanic or a provider
      let userID = (await admin.database().ref("/" + requestType + "/" + requestID).child("userID").get()).val();
      let userToken = await getFCMTokenOfSingleUser(userID);
      if (!userToken) return;
      return await sendNotificationSingleClient({
        token: userToken,
        title: notificationMsg,
        body: "Found a nearby available " + receiver,
        data: {
          requestType: requestType,
          requestID: requestID,
          accepterType: receiver,
          accepterID: receiverID,
        },
      });
    }


  });

async function updateStateReceiversRequests({
  requestType, requestID, receiverID, receiverType, state,
}) {
  let receiverRequestsPath = "/" + receiverType + "sRequests";
  return await admin.database().ref(receiverRequestsPath).child(receiverID).child(requestID).set({
    "state": state, "type": requestType,
  });
}


// TODO
// will delete this function if the other one worked

// On new mechanic or provider added to mechanicsResponses or providersResponses in either RSA or WSA
exports.onRSAFindNewMechanicOrProvider = functions.database.ref("/{requestType}/{requestID}/{receiverResponse}/{receiverID}")
  .onCreate(async (snap, context) => {
    let receiverResponse = context.params.receiverResponse;
    let receiver = "";
    if (receiverResponse === "providersResponses") {
      receiver = "provider";
      return; //TODO  this return makes no action happens when provider is added
    } else if (receiverResponse === "mechanicsResponses") {
      receiver = "mechanic";
    } else {
      return;
    }

    let receiverID = context.params.receiverID;
    let requestID = context.params.requestID;
    let requestType = context.params.requestType;

    // Put this request in mechanic's requests
    await updateStateReceiversRequests({
      requestType: requestType,
      requestID: requestID,
      receiverID: receiverID,
      receiverType: receiver,
      state: "pending",
    });


    // Send mechanic notification
    let requestTypeFull = "Request type: " + requestType;
    let receiverIDToken = await getFCMTokenOfSingleUser(receiverID);
    if (receiverIDToken == null) return;
    let notificationPayload = {
      token: receiverIDToken,
      title: "Received new request",
      body: requestTypeFull,
      data: {"type": "requestType"},
    };
    console.log(await sendNotificationSingleClient(notificationPayload));


  });

exports.onCreateInTest = functions.database.ref("/test/{ke}")
  .onCreate(async (snap, context) => {
    console.log("hello, listened a msg");
    console.log(context.params.ke);
  });


exports.onCreateInTest2 = functions.database
  // .instance('https://salahny-6bfea-default-rtdb.firebaseio.com')
  // .instance('https://console.firebase.google.com/u/1/project/salahny-6bfea/database/salahny-6bfea-default-rtdb/data/~2F')
  .ref("/test/{ke}")
  .onCreate(async (snap, context) => {
    console.log("hello, listened a msg");
    console.log(context.params.ke);
  });


exports.testGetFromDB = functions.https.onRequest(async (req, res) => {
  let r = await admin.database().ref("/test").child("T1").get();
  if (r.val() == null) {
    console.log("null value");
  } else {
    console.log(r.val());
  }
  return r.val();
});

//  firebase emulators:start --only functions --inspect-functions

//  firebase emulators:start --inspect-functions
