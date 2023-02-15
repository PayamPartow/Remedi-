// Handle navigation based on sign in status
firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    console.log("Success! Signed in");
    document.location='dash.html';
  } else {
    console.log("Not signed in!");
  }
});

// Login related elements
const txtPassword= document.getElementById('password');
const txtEmail = document.getElementById('email');
loginMessage = document.getElementById('badLogin');

// Attempt to login, display errpr messages if not successful
function login() {
  loginMessage.innerText = "";
  const email = username.value;
  const pass = txtPassword.value;
  firebase.auth().signInWithEmailAndPassword(email, pass).catch(function(error) {
    var errorCode = error.code;
    var errorMessage = error.message;
    if (errorMessage) {
      console.log("Error: " + errorMessage);
      loginMessage.innerText = "Email and/or password incorrect";
    } else {
      console.log("No error");
    }
  });
};