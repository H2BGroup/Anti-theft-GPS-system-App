package com.example.atgs_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import androidx.glance.appwidget.updateAll
import es.antonborri.home_widget.HomeWidgetProvider
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


/**
 * Implementation of App Widget functionality.
 */
class RemoteWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            // Tworzenie RemoteViews na podstawie layoutu
            val views = RemoteViews(context.packageName, R.layout.remote_widget)


            // Konfiguracja Intencji dla przycisku/przełącznika
            val intent = Intent(context, RemoteWidgetProvider::class.java)
            intent.setAction("TOGGLE_SWITCH")
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)

            val pendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.switch1, pendingIntent)

            // Aktualizacja widżetu
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        GlobalScope.launch {
            RemoteGlanceWidget().updateAll(context)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}