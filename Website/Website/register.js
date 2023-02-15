/**
 * File: register.js
 * Author: Kevin Jerome
 * Version: 1.0
 * Description: Allows the doctor registration form
 *              to create a new collection in Firebase.
 */



// Implement registration via Firebase

var db = firebase.firestore();
const settings = { timestampsInSnapshots: true};
firebase.firestore().settings(settings);
const signupForm = document.querySelector('#register-form');

signupForm.addEventListener('submit', (e) => {

    e.preventDefault();

    const myemail     = signupForm['email'].value;
    const mypassword  = signupForm['password'].value;
    const myHomeAdd   = signupForm['address'].value;
    const myPhone     = signupForm['phone'].value;
    const myfirstName = signupForm['firstName'].value;
    const mylastName  = signupForm['lastName'].value;

    
    firebase.auth().createUserWithEmailAndPassword(myemail, mypassword).then(function(user) {
        // When no errors are present, create the account
        var userUid = firebase.auth().currentUser.uid;
       
        db.collection('doctor').doc(userUid).set({
            firstName: myfirstName,
            lastName: mylastName,
            physHomeAdd: myHomeAdd,
            physPhone: myPhone,
            physEmail: myemail,
        });
        document.getElementById("alert").style = "background-color: #4CAF50; display: block;";
        document.getElementById("alert").innerText = "Success! Account registered."

    }).catch(function(error) {
        var errorCode = error.code;
        var errorMessage = error.message;
        console.log(errorCode);
        console.log(errorMessage);

        document.getElementById("alert").style = "background-color: #f44336; display: block;";
        document.getElementById("alert").innerText = errorMessage;
    });
});

