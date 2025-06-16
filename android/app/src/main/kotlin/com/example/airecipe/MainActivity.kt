package com.example.airecipe

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onResume() {
        super.onResume()
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Hourly Notifications"
            val descriptionText = "Shows notification every hour"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel("hourly_channel_id", name, importance).apply {
                description = descriptionText
                enableVibration(true)
                setShowBadge(true)
            }
            
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}
