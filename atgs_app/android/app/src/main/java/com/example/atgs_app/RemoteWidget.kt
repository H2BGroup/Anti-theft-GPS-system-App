package com.example.atgs_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetProvider
/**
 * Implementation of App Widget functionality.
 */
class RemoteWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val widgetData =  context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.remote_widget).apply {

                val deviceStatus = widgetData.getBoolean("flutter.deviceArmedKey", false)
                setTextViewText(R.id.statusTextView, if (deviceStatus) "ARMED" else "DISARMED")

                val armIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homeWidget://arm")
                )
                val disarmIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    Uri.parse("homeWidget://disarm")
                )

                setOnClickPendingIntent(R.id.armButton, armIntent)
                setOnClickPendingIntent(R.id.disarmButton, disarmIntent)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

    }


    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}