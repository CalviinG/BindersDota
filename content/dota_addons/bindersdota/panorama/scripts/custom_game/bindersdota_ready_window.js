var forceReadyEnabled = false; // Declares if ForceReady is enabled or disabled from the beginning
var waitTime = 3; // Waiting time in seconds until ForceReady() gets enabled

function CreateReadyWindow() {
  $.Msg('***** CreateReadyWindow() *****');
  CountdownTimer(waitTime);
}

function ForceReadyCreate() {
  $.Msg('***** ForceReadyCreate() *****');
  var host = Players.GetLocalPlayer();
  $.Msg('Host is: ', host);
  forceReadyEnabled = true; // Enables ForceReadyClick()
}

function ForceReadyClick() {
  if (forceReadyEnabled) {
    $.Msg('***** ForceReady is ENABLED *****');
    GameEvents.SendCustomGameEventToServer( "my_event_name", { "key1" : "value1", "key2" : "value2" } );
  } else {
    $.Msg('***** ForceReady is DISABLED *****');
  }
}

var countdownValue;
function CountdownTimer(value) {
  // Sets initial value of countdownValue and ticks down if its not the initial call of CountdownTimer()
  if (value) {
    countdownValue = value;
  } else {
    countdownValue--;
  }
  
  // Updates the string on the Panorama window
  $('#bindersdota-ready-window-timer-label').text = countdownValue;

  // Checks if the timer reaches 0 and then ends the function
  if (countdownValue === 0) {
    ForceReadyCreate();
    return
  } else {
    $.Schedule(1, CountdownTimer);
  }
}

// Runs on map INIT
(function () {
  CreateReadyWindow();
  GameEvents.Subscribe( "create_ready_window", CreateReadyWindow );
  GameEvents.Subscribe( "force_ready_create", ForceReadyCreate );
  GameEvents.Subscribe( "force_ready_click", ForceReadyClick );
})();