const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {getMessaging} = require("firebase-admin/messaging");
const {user} = require("firebase-functions/v1/auth");

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
  return (await admin.database().ref("/FCMTokens/" + id).get()).val();
}

async function getFCMTokensOfMultiUsers(ids) {

}

async function sendNotificationMultiClients(tokens) {

}
const RSAStates = {
  canceled:"canceled",

  requestingRSA:"requestingRSA",
  failedToRequestRSA:"failedToRequestRSA",
  created:"created", // created RSA on DB

  waitingForMechanicResponse:"waitingForMechanicResponse", //
  mechanicConfirmed:"mechanicConfirmed",
  waitingForProviderResponse:"waitingForProviderResponse",
  providerConfirmed:"providerConfirmed",
  waitingForArrival:"waitingForArrival",
  confirmedArrival:"confirmedArrival",
  done:"done"
};
Object.freeze(RSAStates);

// Listener when user chooses certain mechanic or provider in a wsa or tta request update the state of this request in the receiverRequests table
exports.onChoosingCertainMechanicOrProviderForRequest = functions.database.ref("/{requestType}/{requestID}/{receiverResponse}/{receiverID}")
  .onUpdate(async (change, context) => {
    console.log("First line in function");
    let receiverResponse = context.params.receiverResponse;
    let receiverType = "";
    let receiverID = context.params.receiverID;
    let requestID = context.params.requestID;
    let requestType = context.params.requestType;
    let state = (await admin.database().ref(`/${requestType}/${requestID}/${receiverResponse}/${receiverID}`).get()).val();
    console.log("before if");
    // Handling the case when we receive wrong data
    if (requestType !== "rsa" && requestType !== "tta" && requestType !== "wsa") {
      console.log("wrong receiver type");
      return;
    }
    if(state !== "chosen"){
      console.log("wrong state");
      return;
    }
    if (receiverResponse === "providersResponses") {
      receiverType = "provider";
    } else if (receiverResponse === "mechanicsResponses") {
      receiverType = "mechanic";
    } else {
      return;
    }
    // Put this request in mechanic's requests
    await updateStateReceiversRequests({
      requestType: requestType,
      requestID: requestID,
      receiverID: receiverID,
      receiverType: receiverType,
      state: state,
    });


      // Send mechanic notification that he was chosen
      let requestTypeFull = "Request type: " + requestType;
      let receiverIDToken = await getFCMTokenOfSingleUser(receiverID);
      let notificationPayload = {
        token: receiverIDToken,
        title: "You were chosen in a request",
        body: requestTypeFull,
        data: {"type": requestType},
      };
      console.log(await sendNotificationSingleClient(notificationPayload));

      // Send each mechanic that was not chosen that he was not chosen
    await (await admin.database().ref(`/${requestType}/${requestID}/${receiverResponse}`)).once("value", async (snapshot) => {
      let chosenMechanics = snapshot.val();
      if (chosenMechanics !== null) {
        for (let mechanicID in chosenMechanics) {
          if (mechanicID !== receiverID) {
            let mechanicIDToken = await getFCMTokenOfSingleUser(mechanicID);
            let notificationPayload = {
              token: mechanicIDToken,
              title: "Request expired",
              body: requestTypeFull,
              data: {"type": requestType},
            };
            console.log(await sendNotificationSingleClient(notificationPayload));
          }
        }
      }
    });

  });

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
    if (requestType === "rsa" &&  (state === "accepted" || state === "rejected")) {
      // check if anyone accepted before,
      let someoneAccepted = false;

      let idsSnapshot = await admin.database().ref("/rsa/" + requestID + "/" + responses).get();
      (await idsSnapshot).forEach((idSnap => {
        let response = idSnap.val();
        if (response === "accepted") {
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
        if(!userToken) return;
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
    } else if ((requestType === "wsa" || requestType === "tta" )&& (state === "accepted" || state === "rejected")) {
      notificationMsg = requestType === "wsa"?"Work shop assistance request":"Tow truck assistance request";

      // Sync mechanic/provider response in request table
      await admin.database().ref("/"+requestType+"/" + requestID + "/" + responses + "/" + receiverID).ref.set(state);
      // notify user that we found a mechanic or a provider
      let userID = (await admin.database().ref("/"+requestType+"/" + requestID).child("userID").get()).val();
      let userToken = await getFCMTokenOfSingleUser(userID);
      if(!userToken) return;
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
  let receiverRequestsPath = receiverType + "sRequests";
  return await admin.database().ref(receiverRequestsPath).child(receiverID).child(requestID).set({
    "state": state, "type": requestType,
  });
}

// On new mechanic or provider added to mechanicsResponses or providersResponses in either RSA or WSA
exports.onRSAFindNewMechanicOrProvider = functions.database.ref("/{requestType}/{requestID}/{receiverResponse}/{receiverID}")
  .onCreate(async (snap, context) => {
    let receiverResponse = context.params.receiverResponse;
    let receiver = "";
    if (receiverResponse === "providersResponses") {
      receiver = "provider";
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
    let notificationPayload = {
      token: receiverIDToken,
      title: "Received new request",
      body: requestTypeFull,
      data: {"type": "requestType"},
    };
    console.log(await sendNotificationSingleClient(notificationPayload));


  });

