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
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});

async function sendNotificationSingleClient(token,title,body){
  const payload = {
    notification: {
      title: title,
      body: body
    },
    // data: {
    //     body: "Helloooo",
    // },
    token: token
  };
  return await admin.messaging().send(payload).then((response) => {
    console.log('Successfully sent message:', response);
    return {success: true};
  }).catch((error) => {
    console.log('couldn\'t send:', error);
    return {error: error.code};
  });
}

async function getFCMTokenOfSingleUser(id){
  return await admin.database().ref("/FCMTokens/" + id).get();
}

async function getFCMTokensOfMultiUsers(ids){

}

async function sendNotificationMultiClients(tokens){

}


exports.simpleDbFunction = functions.database.ref('/rsa/{rsaID}')
  .onCreate(async (snap, context) => {
    var userID = snap.child("userID").val();
    var rsaID = context.params.rsaID;
    var dataDS = await getFCMTokenOfSingleUser(userID);
    var userToken = dataDS.val().toString();
    await sendNotificationSingleClient(userToken,"Firebase notification test", rsaID);


  });

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
