# Agora Video Calling Sample 

This repository contains the sample code for the workshop conducted on October 20th on how to create a basic video call application using the Agora's web SDK.

## Pre-requisites

- An IDE
- A web browser

## How to begin? 

### Obtain an App ID

To build and run the sample application, get an App ID:
1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the signup process, you will be redirected to the Dashboard.
2. Navigate in the Dashboard tree on the left to **Projects** > **Project List**.
3. Copy the **App ID** from the Dashboard and paste it in `main.js` file over here: 

```
client.init("<--- Add Your APP ID Here --->", function(){
    console.log("Initialized successfully!");
});
```

### Creating a server

Once you have done that go to the root directory of your project and run the below command to run the website on your local server

```python3 -m http.server 8080```

This will run your project on: http://localhost:8080/

You can use any availble port over here. 