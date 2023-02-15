/**
 * File: dash.js
 * Author: Joseph Dillman, Kevin Jerome
 * Version: 1.0
 * Description: Contains core functionality of the website 
 *              dashboard/home page for Remedi.
 */

// Database and ID authorization setup, 
var db = firebase.firestore();
var uid;
var PhysData;
firebase.auth().onAuthStateChanged(function(user) {
  if (user) {
    uid = user.uid;
    // Get doctor name and update greeting
    const docRef = db.doc("doctor/" + uid);
    docRef.get().then(function (doc) {
      if (doc && doc.exists) {
        PhysData = doc.data();
        document.getElementById("greet").innerText = "Hello, " + doc.data().firstName + ".";
      }
    }).catch(function(error) {
      console.log("error :", error);
    });
    updateTable();
     /* Get email (the "id") of each patient -- used in analytics.js */
    //retrievePatientSet(uid);
  };
});

// Log out of Firebase and return to login page 
function logout() {
  firebase.auth().signOut().then(function() {
    console.log('Signed Out');
    document.location='login.html';
  }, function(error) {
    console.error('Sign Out Error', error);
  });
};

//////////////////////////////////////////////////////////////////////////
//                      SIDENAV           // 
//////////////////////////////////////////////////////////////////////////

/* Set the width of the side navigation to 250px */
function openNav() {
  document.getElementById("mySidenav").style.width = "200px";
}

/* Set the width of the side navigation to 0 */
function closeNav() {
  document.getElementById("mySidenav").style.width = "0%";
}

//////////////////////////////////////////////////////////////////////////
//                      PATIENT TABLE AND VIEW MODAL CREATION           // 
//////////////////////////////////////////////////////////////////////////

// Get doctor's patients and update table
function updateTable() {

  const docRef2 = db.collection("doctor/" + uid + "/patients/");
  table = document.getElementById("patientTable");

  // make headers
  var header = table.insertRow();
  var h1 = header.insertCell(0);
  var h2 = header.insertCell(1);
  h1.innerHTML = "First Name";
  h2.innerHTML = "Last Name";
  h1.classList = "tHeader";
  h2.classList = "tHeader";

  docRef2.get().then((querySnapshot) => {
    querySnapshot.forEach((doc) => {
      const patID = doc.id


      // Create a new row and insert columns 
      var row = table.insertRow();
      row.id = doc.id;
      var cell1 = row.insertCell(0);
      var cell2 = row.insertCell(1);
      var cell3 = row.insertCell(2);
      var cell4 = row.insertCell(3);
      cell1.innerHTML = doc.data().firstName;
      cell2.innerHTML = doc.data().lastName;
      cell3.style.width = "115px";
      cell4.style.width = "160px";

      // Create button to view data
      var btn = document.createElement("BUTTON");
      btn.innerHTML = "Patient Options";
      btn.id = "mybtn";
      btn.classList = "mybtn";

      // Create button to donwload data
      var pdfBtn = document.createElement("BUTTON");
      pdfBtn.innerHTML = "Download Summary";
      pdfBtn.classList = "mybtn";
      pdfBtn.style.backgroundColor = "#727272";
      pdfBtn.onclick = function() {
        downloadPdf(patID);
      }
      cell4.appendChild(pdfBtn);

      // onclick, set data to modal and open
      var viewRunning = false;
      btn.onclick = function() {
        if (viewRunning) {
          return;
        }
        viewRunning = true;

        const docRefPat = db.doc("users/" + patID);
        docRefPat.get().then(function (doc) {
          if (doc && doc.exists) {
            // Populate Modal with data, then display
            var Pmodal = document.getElementById("myModalView");
            document.getElementById('Pname').innerHTML = doc.data().firstname + " " + doc.data().lastname;
            document.getElementById('Pemail').innerHTML = doc.data().email;
            document.getElementById('Pdob').innerHTML = doc.data().birthDate;
            document.getElementById('Paddress').innerHTML = doc.data().homeAddress;
            document.getElementById('Pphone').innerHTML = doc.data().phoneNumber;
            document.getElementById('Pgender').innerHTML = doc.data().gender;
            document.getElementById('Phcn').innerHTML = doc.data().healthID;
            document.getElementById('Pstage').innerHTML = doc.data().PDStage;
            document.getElementById('Pnotes').innerHTML = doc.data().notes;
            
            Pmodal.style.display = "block";

            // Populate exercise table and create delete button
            exTable = document.getElementById("exTable");
            var exTitle = exTable.insertRow();
            var exTitleCell = exTitle.insertCell(0);
            exTitleCell.innerHTML = "Exercises";
            exTitleCell.classList = "smallerTableHeader";

            const exRef = db.collection("users/" + patID + "/exercises");
            exRef.get().then((querySnapshot) => {
              querySnapshot.forEach((doc) => {
                var exRow = exTable.insertRow();
                var ex1 = exRow.insertCell(0);
                ex1.innerHTML = doc.data().exName;
                exNameDel = doc.data().exName;
                row.id = exNameDel;

                // Delete exercise
                var btnDelEx = document.createElement("BUTTON");
                btnDelEx.innerHTML = "Delete";
                btnDelEx.classList = "delTask";
                btnDelEx.onclick = function() {
                  var r = confirm("You are about to delete this exercise. This cannot be undone.");
                  if (r == true) {
                    var patIDDel = document.getElementById('Pemail').innerHTML;
                      db.doc("users/" + patIDDel + "/exercises/" + exNameDel).delete().then(function() {
                        console.log("Exercise" + exNameDel + " has been deleted");
                        row = document.getElementById(exNameDel);
                        row.innerHTML = "";
                      }).catch(function(error) {
                        console.error("Error removing exercise: ", error);
                    });
                  }
                }
                ex1.appendChild(btnDelEx);
              });
              if (querySnapshot.empty) {
                var exEmpty = exTable.insertRow();
                var exEmptyCol = exEmpty.insertCell(0);
                exEmptyCol.innerHTML = "No Exercises";
              }
            }).catch(function(error) {
              console.log("error :", error);
            });

            // Populate medication table
            medTable = document.getElementById("medTable");
            var medTitle = medTable.insertRow();
            var medTitleCell = medTitle.insertCell(0);
            medTitleCell.innerHTML = "Medication";
            medTitleCell.classList = "smallerTableHeader";

            const medRef = db.collection("users/" + patID + "/medications");
            medRef.get().then((querySnapshot) => {
              querySnapshot.forEach((doc) => {
                var medRow = medTable.insertRow();
                var med1 = medRow.insertCell(0);
                med1.innerHTML = doc.data().medName;
                medNameDel = doc.data().medName;
                medRow.id = medNameDel;
                
                // Delete medication
                var btnDelMed = document.createElement("BUTTON");
                btnDelMed.innerHTML = "Delete";
                btnDelMed.classList = "delTask";
                btnDelMed.onclick = function() {
                  var r = confirm("You are about to delete this medication. This cannot be undone.");
                  if (r == true) {
                    var patIDDel = document.getElementById('Pemail').innerHTML;
                      db.doc("users/" + patIDDel + "/medications/" + medNameDel).delete().then(function() {
                        console.log("Medication" + medNameDel + " has been deleted");
                        row = document.getElementById(medNameDel);
                        medRow.innerHTML = "";
                      }).catch(function(error) {
                        console.error("Error removing medication: ", error);
                    });
                  }
                }
                med1.appendChild(btnDelMed);
              });
              if (querySnapshot.empty) {
                var medEmpty = medTable.insertRow();
                var medEmptyCol = medEmpty.insertCell(0);
                medEmptyCol.innerHTML = "No Exercises";
              }
            }).catch(function(error) {
              console.log("error :", error);
            });
          }
        }).catch(function(error) {
          console.log("error :", error);
        });
        setTimeout(function() {
          viewRunning = false;
        }, 1000);
      };
      cell3.appendChild(btn);
    });
  }).catch(function(error) {
    console.log("error :", error);
  });
}

// Generate and download PDF for each patient 
downloadPdf = function(id){
  db.doc("users/" + id).get().then(function (docData) {
    if (docData && docData.data()) {
      var data = docData.data();
      var doc = new jsPDF();
  
      // Logo header
      var img = new Image();
      img.src = 'Logo2.jpg';
      var row = 40;
      doc.addImage(img, "JPEG", 57, 5, 100, row);
      row = row + 10;
      
      doc.setFontSize(14);
      doc.setFontStyle("bold");
      doc.setTextColor(58,58,58);
      doc.text("Patient Information, Exercise, and Medication Report", 15, row);
      row = row + 10;

      doc.setFontSize(12);
      doc.setFontStyle("normal");
      doc.setTextColor(114,114,114);
      doc.text("Physician: ", 15, row);
      doc.text(PhysData.firstName + " " + PhysData.lastName, 50, row);
      row = row + 5;
      doc.text("Address: ", 15, row);
      doc.text(PhysData.physHomeAdd, 50, row);
      row = row + 5;
      doc.text("Phone Number: ", 15, row);
      doc.text(PhysData.physPhone, 50, row);
      row = row + 5;
      doc.text("Date: ", 15, row);
      doc.text(new Date().toDateString(), 50, row);
      row = row + 15;

      doc.setFontSize(20);
      doc.setTextColor(117,156,201)
      doc.setFont("Helvetica");
      doc.text("Patient Summary", 15, row);

      row = row + 10;
      doc.setFontSize(12);
      doc.setTextColor(114,114,114);
      doc.text("Name: ", 15, row);
      doc.text(data.firstname + " " + data.lastname, 55, row);
      row = row + 5;
      doc.text("Birth Date: ", 15, row);
      doc.text(data.birthDate, 55, row);
      row = row + 5;
      doc.text("Address: ", 15, row);
      doc.text(data.homeAddress, 55, row);
      row = row + 5;
      doc.text("Email: ", 15, row);
      doc.text(data.email, 55, row);
      row = row + 5;
      doc.text("Phone Number: ", 15, row);
      doc.text(data.phoneNumber, 55, row);
      row = row + 5;
      doc.text("Gender: ", 15, row);
      doc.text(data.gender, 55, row);
      row = row + 5;
      doc.text("Parkinsons Stage: ", 15, row);
      doc.text(data.PDStage, 55, row);
      row = row + 5;
      doc.text("Health Number: ", 15, row);
      doc.text(data.healthID, 55, row);
      row = row + 5;
      doc.text("Notes: ", 15, row);
      doc.text(data.notes, 55, row);

      if (row > 250) {
        doc.addPage();
        row = 15
      }
      row = row + 10;
      doc.setFontSize(20);
      doc.setTextColor(117,156,201)
      doc.text("Exercises", 15, row);
      
      // for each exercise, display data
      db.collection("users/" + id + "/exercises").get().then((querySnapshot) => {
        querySnapshot.forEach((exDoc) => {
          if (row > 250) {
            doc.addPage();
            row = 15
          }
          exData = exDoc.data();

          row = row + 10;
          doc.setFontSize(16);
          doc.setTextColor(143,177,204);
          doc.text(exData.exName, 20, row);
          row = row + 10;
          doc.setFontSize(12);
          doc.setTextColor(114,114,114);
          doc.text("Instructions: ", 20, row);
          doc.text(exData.instructions, 65, row);
          row = row + 5;
          doc.text("Reps/time per set: ", 20, row);
          doc.text(exData.exReps, 65, row);
          row = row + 5;
          doc.text("Sets: ", 20, row);
          doc.text(exData.exSets, 65, row);
          row = row + 5;
          doc.text("Frequency: ", 20, row);
          doc.text(exData.frequency, 65, row);
          row = row + 5;
          doc.text("Times per frequency: ", 20, row);
          doc.text(exData.numberOfTimes, 65, row);
          row = row + 5;
          doc.text("Notes: ", 20, row);
          doc.text(exData.exNotes, 65, row);
          row = row + 10;
          doc.text("Dates of completed exercises: ", 20, row);
          if (exData.dayExTaken.length == 0){
            row = row + 5;
            doc.text("None completed", 65, row);
          }
          for (date in exData.dayExTaken) {
            if (row > 280) {
              doc.addPage();
              row = 15
            }
            row = row + 5;
            doc.text(exData.dayExTaken[date], 65, row);
          }
        });
        if (querySnapshot.empty) {
          // No exercises, display none 
          row = row + 10;
          doc.setFontSize(12);
          doc.setTextColor(114,114,114);
          doc.text("No exercises", 20, row);
        }
        
        if (row > 250) {
          doc.addPage();
          row = 15
        }
        row = row + 10;
        doc.setFontSize(20);
        doc.setTextColor(117,156,201)
        doc.text("Medication", 15, row);
        
        // for each medication, display data
        db.collection("users/" + id + "/medications").get().then((querySnapshot) => {
          querySnapshot.forEach((exDoc) => {
            if (row > 250) {
              doc.addPage();
              row = 15
            }
            exData = exDoc.data();

            row = row + 10;
            doc.setFontSize(16);
            doc.setTextColor(143,177,204);
            doc.text(exData.medName, 20, row);
            row = row + 10;
            doc.setFontSize(12);
            doc.setTextColor(114,114,114);
            doc.text("Instructions: ", 20, row);
            doc.text(exData.instructions, 65, row);
            row = row + 5;
            doc.text("Dosage Notes: ", 20, row);
            doc.text(exData.doseNotes, 65, row);
            row = row + 5;
            doc.text("Size of Dose: ", 20, row);
            doc.text(exData.doseSize, 65, row);
            row = row + 5;
            doc.text("Number of Doses: ", 20, row);
            doc.text(exData.medSize, 65, row);
            row = row + 5;
            doc.text("Frequency: ", 20, row);
            doc.text(exData.frequency, 65, row);
            row = row + 5;
            doc.text("Times per frequency: ", 20, row);
            doc.text(exData.numberOfTimes, 65, row);
            row = row + 5;
            doc.text("Notes: ", 20, row);
            doc.text(exData.medNotes, 65, row);
            row = row + 10;
            doc.text("Dates of completed medication: ", 20, row);
            if (exData.dayMedTaken.length == 0){
              row = row + 5;
              doc.text("None completed", 65, row);
            }
            for (date in exData.dayMedTaken) {
              if (row > 280) {
                doc.addPage();
                row = 15
              }
              row = row + 5;
              doc.text(exData.dayMedTaken[date], 65, row);
            }
          });
          if (querySnapshot.empty) {
            // No exercises, display none 
            row = row + 10;
            doc.setFontSize(12);
            doc.setTextColor(114,114,114);
            doc.text("No medications", 20, row);
          }
          doc.save(String(data.firstname) + String(data.lastname) + 'Summary.pdf');
        }).catch(function(error) {
          console.log("error : unable to read exercises", error);
        });
      }).catch(function(error) {
        console.log("error: ", error);
      });
    }
  });
}

// Button to delete patient + data
delPatient = function() {
  var r = confirm("You are about to delete this patient profile and all of its contents? This cannot be undone.");
  if (r == true) {
    
    // delete from doctor collection
    var patIDDel = document.getElementById('Pemail').innerHTML;
    db.doc("doctor/" + uid + "/patients/" + patIDDel).delete().then(function() {
      db.doc("users/" + patIDDel).delete().then(function() {
        console.log("Patient with ID " + patIDDel + " has been deleted");
        row = document.getElementById(patIDDel);
        row.innerHTML = "";
      }).catch(function(error) {
        console.error("Error removing document from users: ", error);
      });
    }).catch(function(error) {
      console.error("Error removing document from doctors: ", error);
    });
    Pmodal.style.display = "none";
    document.getElementById("success").style.display = "none";
    document.getElementById("badDate").style.display = "none";
    document.getElementById("badInputs").style.display = "none";
    document.getElementById('exMessage').style.display = "none";
    document.getElementById('medMessage').style.display = "none";
    document.getElementById("medTable").innerHTML = "";
    document.getElementById("exTable").innerHTML = "";
  }
}


//////////////////////////////////////////////////////////////////////////
//                      MODAL RELATED LOGIC                             // 
//////////////////////////////////////////////////////////////////////////

// Logic for modal for viewing information
var Pmodal = document.getElementById("myModalView");
function closeView() {
  Pmodal.style.display = "none";
}

// Logic to open modal
var modal = document.getElementById("myModal");
var btn = document.getElementById("myBtn");
var span = document.getElementById("closeAdd");
btn.onclick = function() {
  modal.style.display = "block";
}
// Close modal with X button
span.onclick = function() {
  modal.style.display = "none";
  document.getElementById('exMessage').style.display = "none";
  document.getElementById('medMessage').style.display = "none";
  document.getElementById("success").style.display = "none";
  document.getElementById("badDate").style.display = "none";
  document.getElementById("badInputs").style.display = "none";
  document.getElementById("medTable").innerHTML = "";
  document.getElementById("exTable").innerHTML = "";


}
// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
  if (event.target == modal) { // add new patient modal
    modal.style.display = "none";
    document.getElementById("success").style.display = "none";
    document.getElementById("badDate").style.display = "none";
    document.getElementById("badInputs").style.display = "none";
  } else if (event.target == Pmodal) { // view modal
    Pmodal.style.display = "none";
    document.getElementById('exMessage').style.display = "none";
    document.getElementById('medMessage').style.display = "none";
    document.getElementById("medTable").innerHTML = "";
    document.getElementById("exTable").innerHTML = "";
  }
}

//////////////////////////////////////////////////////////////////////////
//                        ADDING A PATIENT                              // 
//////////////////////////////////////////////////////////////////////////

// Attempt to add patient to user and doctor collections
// Test inputs before adding, update tables when complete
var isRunningAdd = false;
function addPatient() {
  if (isRunningAdd) {
    return;
  }

  isRunningAdd = true;
  
  document.getElementById("badInputs").style.display = "none";
  document.getElementById("badDate").style.display = "none";
  document.getElementById("success").style.display = "none";
  
  firstName = document.getElementById('patientFirstName').value;
  lastName = document.getElementById('patientLastName').value;
  email = document.getElementById('patientEmail').value;
  dob = document.getElementById('patientDOB').value;
  address = document.getElementById('patientAdd').value;
  phone = document.getElementById('patientPhone').value;
  gender = document.getElementById('patientGender').value;
  hcn = document.getElementById('patientNum').value;
  stage = document.getElementById('patientStage').value;
  notes = document.getElementById('patientNotes').value;
  
  // Ensure data is formatted properly
  const date = new Date(dob);
  if (isNaN(date) || (dob.match(/-/g)||[]).length != 2) { 
    document.getElementById("badDate").style.display = "block";
    return;
  } else {

    // Add patient to users collection
    const userRef = db.collection("users").doc(email).set({
      doctorID: uid,
      firstname: firstName,
      lastname: lastName,
      email: email,
      homeAddress: address,
      phoneNumber: phone,
      birthDate: dob,
      gender: gender,
      healthID: hcn,
      PDStage: stage,
      notes: notes
    })
    .then(function(docRef) {
      console.log("User added with ID: ", email);
      
      // Add patient to doctor collection
      const PhysRef = db.collection("doctor").doc(uid)
      PhysRef.collection("patients").doc(email).set({
        firstName: firstName,
        lastName: lastName
      })
      .then(function() {
        // display message, clear inputs, update table
        console.log("Added patient to Doctor");
        document.getElementById("success").style.display = "block";
        
        document.getElementById('patientFirstName').value = "";
        document.getElementById('patientLastName').value = "";
        document.getElementById('patientEmail').value = "";
        document.getElementById('patientAdd').value = "";
        document.getElementById('patientPhone').value = "";
        document.getElementById('patientDOB').value = "";
        document.getElementById('patientGender').value = "";
        document.getElementById('patientNum').value = "";
        document.getElementById('patientStage').value = "";
        document.getElementById('patientNotes').value = "";
        
        table.innerHTML = "";
       // document.getElementById('alertAddNewPatient').style = "display: block";
        updateTable();

      }).catch(function(error) {
        console.error("Error", error);
      });
    })
    .catch(function(error) {
      // Display error message
      document.getElementById("badInputs").style.display = "block";
      console.error("Error adding User: ", error);
    });
  }
  setTimeout(function() {
    isRunningAdd = false;
  }, 2000);
};

//////////////////////////////////////////////////////////////////////////
//                        ADD MEDICATION/EXERCISE                       // 
//////////////////////////////////////////////////////////////////////////
function addEx() {
  var exMessage = document.getElementById('exMessage');
  exMessage.style.display = "none";
  var exName = document.getElementById('exName').value;
  var exReps = document.getElementById('exReps').value;
  var exSets = document.getElementById('exSets').value;
  var exInst = document.getElementById('exInstructions').value;
  var exNotes = document.getElementById('exNotes').value;
  var exTimes = document.getElementById('exTimes').value;
  var exFreq = document.getElementById('exFreq').value;
  var Pemail= document.getElementById('Pemail').innerText;

  const userRef = db.doc("users/" + Pemail + "/exercises/" + exName).set({
    exName: exName,
    exReps: exReps,
    exSets: exSets,
    instructions: exInst,
    exNotes: exNotes,
    dayExTaken: [],
    frequency: exFreq,
    numberOfTimes: exTimes
  }).then(function() {
    console.log("Added exercise " + exName + " to patient " + Pemail);
    
    exMessage.innerText = "Successfully added exercise! Refresh to see your change";
    exMessage.style.color = "#76cf53";
    exMessage.style.display = "block";

  }).catch(function(error) {
    console.error("Error", error);
    exMessage.innerText = "Error adding exercise!";
    exMessage.style.color = "#ff8080";
    exMessage.style.display = "block";
  });
}

function addMed() {
  var medMessage = document.getElementById('medMessage');
  medMessage.style.display = "none";
  var medName = document.getElementById('medName').value;
  var doseNotes = document.getElementById('doseNotes').value;
  var doseSize = document.getElementById('doseSize').value;
  var medSize = document.getElementById('medSize').value;
  var medNotes = document.getElementById('medNotes').value;
  var medInst = document.getElementById('medInstructions').value;
  var medTimes = document.getElementById('medTimes').value;
  var medFreq = document.getElementById('medFreq').value;
  var timePref = document.getElementById('timePref').value;
  var Pemail= document.getElementById('Pemail').innerText;

  const userRef = db.doc("users/" + Pemail + "/medications/" + medName).set({
    medName: medName,
    doseNotes: doseNotes,
    doseSize: doseSize,
    medSize: medSize,
    instructions: medInst,
    medNotes: medNotes,
    timePref: timePref,
    dayMedTaken: [],
    frequency: medFreq,
    numberOfTimes: medTimes
  }).then(function() {
    console.log("Added medication " + medName + " to patient " + Pemail);

    medMessage.innerText = "Successfully added medication! Refresh to see your change";
    medMessage.style.color = "#76cf53";
    medMessage.style.display = "block";

  }).catch(function(error) {
    console.error("Error", error);
    medMessage.innerText = "Error adding medication!";
    medMessage.style.color = "#ff8080";
    medMessage.style.display = "block";
  });
}

//////////////////////////////////////////////////////////////////////////
//                        AUTOCOMPLETE                                  //
//////////////////////////////////////////////////////////////////////////

function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
          b.addEventListener("click", function(e) {
              /*insert the value for the autocomplete text field:*/
              inp.value = this.getElementsByTagName("input")[0].value;
              /*close the list of autocompleted values,
              (or any other open lists of autocompleted values:*/
              closeAllLists();
          });
          a.appendChild(b);
        }
      }
  });
  /*execute a function presses a key on the keyboard:*/
  inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
  });
  function addActive(x) {
    /*a function to classify an item as "active":*/
    if (!x) return false;
    /*start by removing the "active" class on all items:*/
    removeActive(x);
    if (currentFocus >= x.length) currentFocus = 0;
    if (currentFocus < 0) currentFocus = (x.length - 1);
    /*add class "autocomplete-active":*/
    x[currentFocus].classList.add("autocomplete-active");
  }
  function removeActive(x) {
    /*a function to remove the "active" class from all autocomplete items:*/
    for (var i = 0; i < x.length; i++) {
      x[i].classList.remove("autocomplete-active");
    }
  }
  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  }
  /*execute a function when someone clicks in the document:*/
  document.addEventListener("click", function (e) {
      closeAllLists(e.target);
  });
}

var exercises = ["Arms", "Legs", "Balance", "Hand", "Bicep curl", "Calf raise"]
var medication = ["Selegiline","Amantadine","Levodopa","Safinamide","Trihexyphenidyl","Selegiline","Tolcapone","Promethzine","Biperidin"]
autocomplete(document.getElementById("exName"), exercises);
autocomplete(document.getElementById("medName"), medication);

