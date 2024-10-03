importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyCGa69RV3KtftCJLjFwbSi1abxMEw3At_M",
    authDomain: "coupon-rswm.firebaseapp.com",
    projectId: "coupon-rswm",
    storageBucket: "coupon-rswm.appspot.com",
    messagingSenderId: "105784175004",
    appId: "1:105784175004:web:446e6e4febefcd12c14059",
    measurementId: "G-H353R6NPG1"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});