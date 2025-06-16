const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendEveryMinuteNotification = functions.pubsub
  .schedule("every 1 minutes") // ⏱ Runs every minute
  .timeZone("Asia/Kolkata") // optional: set your timezone
  .onRun(async (context) => {
    const message = {
      notification: {
        title: "🕐 Every Minute",
        body: "This is a message sent every minute!",
      },
      topic: "minuteTopic", // 👈 Make sure clients subscribe to this
    };

    try {
      await admin.messaging().send(message);
      console.log("✅ Notification sent every minute");
    } catch (e) {
      console.error("❌ Failed to send notification", e);
    }
  });
