const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.sendNotification = functions.firestore
    .document('chatroom/{groupId1}/{groupId2}/{message}')
    // .document('chatroom/')
    .onCreate((snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)

        const idFrom = doc.sendById
        const idTo = doc.sendToId
        const contentMessage = doc.message

        // Get push token user to (receive)
        admin
            .firestore()
            .collection('users')
            .where('UserID', '==', idTo)
            .get()
            .then(querySnapshot => {
                querySnapshot.forEach(userTo => {
                    console.log(`Found user to: ${userTo.data().userName}`)
                    if (userTo.data().pushToken && userTo.data().chattingWith !== idFrom) {
                        // Get info user from (sent)
                        admin
                            .firestore()
                            .collection('users')
                            .where('UserID', '==', idFrom)
                            .get()
                            .then(querySnapshot2 => {
                                querySnapshot2.forEach(userFrom => {
                                    console.log(`Found user from: ${userFrom.data().userName}`)
                                    const payload = {
                                        notification: {
                                            title: `You have a message from "${userFrom.data().userName}"`,
                                            body: contentMessage,
                                            badge: '1',
                                            sound: 'default'
                                        }
                                    }
                                    // Let push to the target device
                                    admin
                                        .messaging()
                                        .sendToDevice(userTo.data().pushToken, payload)
                                        .then(response => {
                                            console.log('Successfully sent message:', response)
                                        })
                                        .catch(error => {
                                            console.log('Error sending message:', error)
                                        })
                                })
                            })
                    } else {
                        console.log('Cannot find pushToken target user or the users are chatting with each other')
                    }
                })
            })
        return null
    })


// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
