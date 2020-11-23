/**
 * @name handleFail
 * @param err - error thrown by any function
 * @description Helper function to handle errors
 */
let handleFail = function(err){
    console.log("Error : ", err);
};

// Queries the container in which the remote feeds belong
let remoteContainer = document.getElementById("remote-container");
var count = 0; // number of remote containers


// Reads value from a variable named `channelName` in our local storage 
var channelName = localStorage.getItem("channelName");

// <---- Add your code here ----->
document.getElementById('disconnect_call').onclick = () => {
    disconnectCall();
}

function disconnectCall() {
    client.leave();
    if (client.leave) {
        window.location.href = '../index.html';
    }
}

document.getElementById('mute_mic').onclick = () => {
    toggleMic();
}

var isMuted = false;

function toggleMic() {
    if (isMuted) {
        isMuted = false;
        globalstream.muteAudio();
        console.log('Stream has been muted.');
    } else {
        isMuted = true;
        globalstream.enableAudio();
        console.log('Stream has been unmuted.');
    }
}

document.getElementById('disable_camera').onclick = () => {
    toggleCamera();
}

var isCameraOn = true;

function toggleCamera() {
    if (isCameraOn) {
        isCameraOn = false;
        globalstream.muteVideo();
        console.log('Video has been disabled');
    } else {
        isCameraOn = true;
        globalstream.enableVideo();
        console.log('Video has been enabled');
    }
}

/**
 * @name addVideoStream
 * @param streamId
 * @description Helper function to add the video stream to "remote-container"
 */
function addVideoStream(streamId){
    count = count + 1;
    let streamDiv=document.createElement("div"); // Create a new div for every stream
    streamDiv.id=streamId;                       // Assigning id to div
    streamDiv.style.transform="rotateY(180deg)"; // Takes care of lateral inversion (mirror image)
    streamDiv.style.marginBottom = "3vw";        // Creates some space between the remote containers
    remoteContainer.appendChild(streamDiv);      // Add new div to container
}

/**
 * @name removeVideoStream
 * @param evt - Remove event
 * @description Helper function to remove the video stream from "remote-container"
 */
function removeVideoStream (evt) {
    let stream = evt.stream;
    stream.stop();
    let remDiv = document.getElementById('remote-container');
    remDiv.parentNode.removeChild(remDiv);
    console.log("Remote stream removed ");
}

// Start code
//Creating client
let client = AgoraRTC.createClient({
    mode : 'live',
    codec : "h264"
});

var stream = AgoraRTC.createStream({
  streamID: 0,
  audio:true,
  video:true,
  screen:false
});

//Initializing client
client.init("dc96e5c14025414ea38980c9b1b1fbe4", function(){
    console.log("Initialized successfully!");
});

//Joining the client
client.join(null, channelName, null, function(uid){

    let localstream = AgoraRTC.createStream({
        streamID : uid,
        audio : true,
        video : true,
        screen : false
    });

    globalstream = localstream;

    //Publishing the stream.
    localstream.init(function(){
        localstream.play('me');
        client.publish(localstream, handleFail);

        client.on('stream-added', (evt)=>{
            client.subscribe(evt.stream,handleFail);
        });

        client.on('stream-subscribed', (evt)=>{
            let stream = evt.stream;
            addVideoStream(stream.getId());
            stream.play('remote-container');
        });
        client.on('stream-removed', removeVideoStream);
    },handleFail);

},handleFail);