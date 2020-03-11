const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();

exports.sendAdminNotification = functions.firestore.document('/news/{newsId}').onCreate(snapshot => {

     const payload = {notification: {
         title: 'خبر عاجل',
         body: snapshot.data().title,
         icon:'https://firebasestorage.googleapis.com/v0/b/asima-online.appspot.com/o/images%2FchatRooms%2FAlasima%20Online%20Logo.png?alt=media&token=84aa95e5-f5dc-4418-a5bc-53d8a8c32706'
         }};

     return fcm.sendToTopic("news",payload)
        .then(function(response){
             console.log('Notification sent successfully:',response);
        })
        .catch(function(error){
             console.log('Notification sent failed:',error);
        });
});