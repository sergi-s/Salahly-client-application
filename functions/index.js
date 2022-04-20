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
//

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

/*

exports.onRSAUpdate = functions.database.ref("/rsa/{rsaID}").onUpdate(async (change, context) => {
  var rsaID = context.params.rsaID;
  console.log("RSA UPDATE");


  // if one of the mechanics accepted
  // we need to detect if his state changed from pending to accepted
  if (change.before.child("state").val() === "waitingForMechanicResponse") {

    change.after.child("mechanicsResponses").forEach((mechanicSnap) => {
      let mechanicState = mechanicSnap.val().toString();
      console.log("Mechanic state: " + mechanicState);
      if (mechanicState === "accepted") {

        // Put this rsa in mechanic's list
        let mechanicID = mechanicSnap.key.toString();
        // admin.database().ref("mechanicsRequests/" + mechanicID).child(rsaID).set(
        //   "ongoing",
        // );
        admin.database().ref("/mechanicsRequests").child(mechanicID).child(rsaID).set("ongoing");
        // admin.database().ref("mechanRequests").child(mechanicID).child(rsaID).set("ongoing");
        // admin.database().ref("/mechRequests/"+mechanicID+"/"+rsaID).set("ongoing");

        // Send client notification
        let userID = change.after.child("userID").val();
        admin.database().ref("/FCMTokens/" + userID).get().then((dataDS) => {
          console.log("userFCMToken: " + dataDS.val().toString());
          const payload = {
            notification: {
              title: "Mechanic Accepted", body: mechanicID,
            }, // data: {
            //     body: "Helloooo",
            // },
            token: dataDS.val().toString(),
          };
          admin.messaging().send(payload).then((response) => {
            console.log("Successfully sent message:", response);
            return {success: true};
          }).catch((error) => {
            console.log("couldn't send:", error);
            return {error: error.code};
          });
        });
      }
    });
  } else if (change.before.child("state").val() === "waitingForProviderResponse") {

    change.after.child("providersResponses").forEach((providerSnap) => {
      let providerState = providerSnap.val().toString();
      console.log("Provider state: " + providerState);
      if (providerState === "accepted") {

        // Put this rsa in mechanic's list
        let providerID = providerSnap.key.toString();
        // admin.database().ref("/providerHistory/" + providerID).child(rsaID).set(
        //   "ongoing",
        // );

        admin.database().ref().child("/providersRequests").child(providerSnap.key.toString()).child(rsaID).set("ongoing");


        // Send client notification
        let userID = change.after.child("userID").val();
        admin.database().ref("/FCMTokens/" + userID).get().then((dataDS) => {
          console.log("userFCMToken: " + dataDS.val().toString());
          const payload = {
            notification: {
              title: "Provider Accepted", body: providerID,
            }, // data: {
            //     body: "Helloooo",
            // },
            token: dataDS.val().toString(),
          };
          admin.messaging().send(payload).then((response) => {
            console.log("Successfully sent message:", response);
            return {success: true};
          }).catch((error) => {
            console.log("couldn't send:", error);
            return {error: error.code};
          });
        });
      }
    });
  }
});
*/

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
    if (requestType === "rsa" &&  (state === "accepted" || state === "denied")) {
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
    } else if (requestType === "wsa" && (state === "accepted" || state === "denied")) {
      // set the mechanic as accepted or canceled in wsa request
      await admin.database().ref("/wsa/" + requestID + "/" + responses + "/" + receiverID).ref.set(state);
      // notify user that we found a mechanic or a provider
      let userID = (await admin.database().ref("/wsa/" + requestID).child("userID").get()).val();
      let userToken = await getFCMTokenOfSingleUser(userID);
      if(!userToken) return;
      return await sendNotificationSingleClient({
        token: userToken,
        title: "Work shop assistance request",
        body: "Found a nearby available " + receiver,
        data: {
          requestType: requestType,
          requestID: requestID,
          accepterType: receiver,
          accepterID: receiverID,
        },
      });
    }
    else if(requestType === "tta"  && (state === "accepted" || state === "denied")){
      await admin.database().ref("/tta/" + requestID + "/" + responses + "/" + receiverID).ref.set(state);
      // notify user that we found a mechanic or a provider
      let userID = (await admin.database().ref("/tta/" + requestID).child("userID").get()).val();
      let userToken = await getFCMTokenOfSingleUser(userID);
      if(!userToken) return;
      return await sendNotificationSingleClient({
        token: userToken,
        title: "Tow truck assistance request",
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


/*

exports.onRSACreation = functions.database.ref("/rsa/{rsaID}")
  .onCreate(async (snap, context) => {
    // var userID = snap.child("userID").val();
    var rsaID = context.params.rsaID;


    snap.child("mechanicsResponses").forEach((mechanic_ID) => {
      mechanic_ID = mechanic_ID.key.toString();
      console.log("after mechanic id");
      console.log("mechanic id: " + mechanic_ID);

      admin.database().ref("/mechanicsRequests").child(mechanic_ID).child(rsaID).set("pending");


      admin.database().ref("/FCMTokens/" + mechanic_ID).get().then((dataDS) => {
        console.log("userFCMToken: " + dataDS.val().toString());
        const payload = {
          notification: {
            title: "cloud function demo",
            body: rsaID,
          },
          // data: {
          //     body: "Helloooo",
          // },
          token: dataDS.val().toString(),
        };
        admin.messaging().send(payload).then((response) => {
          console.log("Successfully sent message:", response);
          return {success: true};
        }).catch((error) => {
          console.log("couldn't send:", error);
          return {error: error.code};
        });
      });


      // getFCMTokenOfSingleUser(mechanic_ID).then((dataDS) => {
      // var userToken = dataDS.val().toString();
      //   console.log("after getting token");
      //   console.log("user token: "+userToken);
      // sendNotificationSingleClient(userToken,"Firebase notification test", rsaID);
      // });
    });


  });
*/

/*
WORKING ONRSACREATION
// we must handle multiple tokens in a single notification message (avoid spamming sending) and try to read once from DB not spam reading too (mostly will stay the same)
exports.onRSACreation = functions.database.ref("/rsa/{rsaID}")
  .onCreate(async (snap, context) => {
    // var userID = snap.child("userID").val();
    var rsaID = context.params.rsaID;
    snap.child("mechanicsResponses").forEach((mechanic_ID) => {
      mechanic_ID = mechanic_ID.key.toString();
      console.log("after mechanic id");
      console.log("mechanic id: " + mechanic_ID);

      admin.database().ref("/mechanicsRequests").child(mechanic_ID).child(rsaID).set("pending");


      admin.database().ref("/FCMTokens/" + mechanic_ID).get().then((dataDS) => {
        console.log("userFCMToken: " + dataDS.val().toString());
        const payload = {
          notification: {
            title: "cloud function demo",
            body: rsaID,
          },
          // data: {
          //     body: "Helloooo",
          // },
          token: dataDS.val().toString(),
        };
        admin.messaging().send(payload).then((response) => {
          console.log("Successfully sent message:", response);
          return {success: true};
        }).catch((error) => {
          console.log("couldn't send:", error);
          return {error: error.code};
        });
      });



      // getFCMTokenOfSingleUser(mechanic_ID).then((dataDS) => {
      // var userToken = dataDS.val().toString();
      //   console.log("after getting token");
      //   console.log("user token: "+userToken);
      // sendNotificationSingleClient(userToken,"Firebase notification test", rsaID);
      // });
    });


  });
*/

/*
WORKING ♥♥♥
exports.simpleDbFunction = functions.database.ref('/rsa/{rsaID}')
    .onCreate(async (snap, context) => {
        var userID = snap.child("userID").val();
        var rsaID = context.params.rsaID;
        console.log("userID: " + userID);
      const userFCMToken = await admin.database().ref("/FCMTokens/"+userID).get().then( (dataDS) => {
          console.log("userFCMToken: "+dataDS.val().toString());
          const payload = {
            notification: {
              title: 'cloud function demo',
              body: rsaID
            },
            // data: {
            //     body: "Helloooo",
            // },
            token: dataDS.val().toString()
          };
          admin.messaging().send(payload).then((response) => {
            console.log('Successfully sent message:', response);
            return {success: true};
          }).catch((error) => {
            console.log('couldn\'t send:', error);
            return {error: error.code};
          });
        });
    }); */
