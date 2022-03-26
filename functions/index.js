const functions = require("firebase-functions");


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
exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.simpleDbFunction = functions.database.ref('/rsa')
    .onCreate((snap, context) => {
//      if (context.authType === 'ADMIN') {
//        // do something
//      } else if (context.authType === 'USER') {
//        console.log(snap.val(), 'written by', context.auth.uid);
//      }

       // send notification to all mechanics whose IDs are registered

    });
