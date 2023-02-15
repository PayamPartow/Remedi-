/**
 * File: analytics.js
 * Author: Kevin Jerome
 * Version: 1.0
 * Description: Contains core functionality for 
 *              Remedi analytics page.
 */
 

// GLOBAL VARIABLES //

/* Firebase */
var db = firebase.firestore();

/* keys: name, value: ID */
var patientNameToIDDict = {};

/* keys: ID, value: name */
var patientIDToNameDict = {};

/* helper var to prevent multiclicking */
var isRenderingGraph = false;

/* helper var for prevention of fetching the same data */
var previousPatient = "";

/* FILL COLOURS */
var bg_colours = [
	'rgba(255, 99, 132, 0.2)',
	'rgba(54, 162, 235, 0.2)',
	'rgba(255, 206, 86, 0.2)',
	'rgba(75, 192, 192, 0.2)',
	'rgba(153, 102, 255, 0.2)',
	'rgba(255, 159, 64, 0.2)',
	'rgba(164, 159, 64, 0.2)',
	'rgba(111, 163, 32, 0.2)',
	'rgba(37, 211, 16, 0.2)',
	'rgba(11, 10, 30, 0.2)',
];

/* BORDER COLOURS */
var bo_colours = [
	'rgba(255, 99, 132, 1)',
	'rgba(54, 162, 235, 1)',
	'rgba(255, 206, 86, 1)',
	'rgba(75, 192, 192, 1)',
	'rgba(153, 102, 255, 1)',
	'rgba(255, 159, 64, 1)',
	'rgba(164, 159, 64, 1)',
	'rgba(111, 163, 32, 1)',
	'rgba(37, 211, 16, 1)',
	'rgba(11, 10, 30, 1)',
];


// FUNCTIONS // 

/**
 * Function name: addData
 * Function description: updates a given chart's data labels and data values with the supplied parameters
 */
function addData(chart, label, datum) {
	if (label != "" && datum != "") {
		chart.data.labels.push(label);
		chart.data.datasets[0].data.push(datum);
	}
	//chart.update();
}


/**
 * Function name: removeData
 * Function description: removes a given chart's data labels and data values, then hides the chart
 */
function removeData(chart) {
	/* hide chart, remove data */
	document.getElementById('myChart').style.display = "none";
	chart.data.labels = [];
	chart.data.datasets[0].data = [];
	chart.data.datasets[0].label = [];
	chart.data.datasets[0].backgroundColor = [];
	chart.data.datasets[0].borderColor = [];
	chart.update();
}


/**
 * Function name: retrieveGraphLabels
 * Function description: fetches data from Firebase to serve as a chart's data labels
 */
function retrieveGraphLabels(chart, pid) {
	/* add chart title label */
    chart.data.datasets[0].label = '# of Exercises Sets Completed';
    
    /* array of the exercises stored in Firebase */
	var exercises = ["arms", "legs", "balance", "hand", "bicep curl", "calf raise"];
	document.getElementById("graphSubTitle").style.display = "none";
    /* retrieve exercise names from Firebase */
    /*
    db.collection("exercises/").get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            exercises.push(doc.data().exName);
            //console.log(exercises);
		});
    });
    */

	db.collection("users/" + pid + "/exercises/").get().then((querySnapshot) => {

        if (querySnapshot.empty) {
            console.log(pid + " has no exercises.")
            document.getElementById("graphTitle").innerText = patientIDToNameDict[pid] + " has no assigned exercises."
			document.getElementById('myChart').style.display = "none";
			document.getElementById("graphSubTitle").style.display = "none";
            return;
        }
		
		querySnapshot.forEach((doc) => {
			if (exercises.indexOf(doc.data().exName.toLowerCase()) >= 0) {
				//console.log(doc.data());
				if(doc.data().exReps == "") {
					document.getElementById("graphSubTitle").innerText = "Warning: one or more exercises assigned to " + patientIDToNameDict[pid] + 
					" do not specify the number of repetitions the patient must perform. These exercises are not displayed on the graph."
					document.getElementById("graphSubTitle").style.display = "block";
				} else {
					addData(chart, doc.data().exName, doc.data().exReps);
				}
			}
		});
		//console.log(querySnapshot.size);
		generateGraphColours(chart, querySnapshot.size);
	});

	document.getElementById('myChart').style.display = "block";
	/* update patient h2 */
	document.getElementById("graphTitle").innerText = "Patient: " + patientIDToNameDict[pid];
}


/**
 * Function name: renderGraph
 * Function description: wrapper function that handles the creation of a given chart
 */
function renderGraph(chart) {
	var patientName = document.getElementById("analyticInput").value
	var patientID = patientNameToIDDict[patientName];

	if (isRenderingGraph || !patientID || (patientName === previousPatient)) {
		return;
	}

	previousPatient = patientName;
	document.getElementById("graphTitle").innerText = "Please wait...";

	isRenderingGraph = true;
	removeData(chart);
	retrieveGraphLabels(chart, patientID);

	/* timeout prevents multiclicking */
	setTimeout(function () {
		isRenderingGraph = false;
	}, 500);
}


/**
 * Function name: populatePatientList
 * Function description: retrives a list of patients from Firebase for use in the select patient datalist
 */
function populatePatientList() {
	var docid;
	firebase.auth().onAuthStateChanged(function (user) {
		if (user) {
			docid = user.uid;
		}
		var list = document.getElementById('listofpatients');
		db.collection("doctor/" + docid + "/patients/").get().then((querySnapshot) => {
			querySnapshot.forEach((doc) => {
				db.doc("users/" + doc.id).get().then(function (doc) {

					var option = document.createElement('option');
					var namestring = doc.data().firstname + " " + doc.data().lastname;

					patientNameToIDDict[namestring] = doc.id;
					patientIDToNameDict[doc.id] = namestring;
					option.value = namestring;
					list.appendChild(option);
				});
			});
		});
	});
}


/**
 * Function name: generateGraphColours
 * Function description: dynamically colours graphs using a preset colour palette
 */
function generateGraphColours(chart, dataLength) {
	//console.log("Num of graph colours: "  + dataLength)
	for (var i = 0; i < dataLength; i++) {
		//console.log("i is: " + i, " - adding colour " + i % (bg_colours.length));
		chart.data.datasets[0].backgroundColor.push(bg_colours[i % (bg_colours.length)]);
		chart.data.datasets[0].borderColor.push(bo_colours[i % (bo_colours.length)]);
		
	}
	chart.update();
}


// HELPER LOGIC //

/* Listens for change of input on the "patient" datalist, takes corresponding action */
$(document).on('change', 'input', function () {
	var val = $(this).val();
	if (val == "" || !patientNameToIDDict[val]) {
		previousPatient = val;
		if (val == "") {
			document.getElementById("graphTitle").innerText = "Please select a patient first.";
		} else {
			document.getElementById("graphTitle").innerText = "Patient not found.";
		}
		document.getElementById("graphSubTitle").style.display = "none";
		removeData(myChart);
	} else {
		document.getElementById("graphTitle").innerText = "Click button to generate graph.";
	}
});