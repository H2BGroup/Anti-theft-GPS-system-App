package com.example.atgs_app

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.Switch
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.preview.Preview
import androidx.glance.state.GlanceStateDefinition
import java.io.File


class RemoteGlanceWidget : GlanceAppWidget() {

    override val stateDefinition: GlanceStateDefinition<*>
        get() = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }

    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val isArmed = prefs.getBoolean("flutter.deviceArmedKey", false)
        val imagePath = prefs.getString("flutter.filename", null)

        var bitmap: Bitmap? = null

        if (imagePath != null) {
            val imageFile = File(imagePath)
            if (imageFile.exists()) {
                bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
            }
        }

        Box(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(Color(0xFF1DAEEF))
                .padding(16.dp)
                .cornerRadius(30.dp)
        ) {
            Column(
                modifier = GlanceModifier.fillMaxSize(),
                verticalAlignment = Alignment.Vertical.CenterVertically,
                horizontalAlignment = Alignment.Horizontal.CenterHorizontally
            ) {
                if (bitmap != null) {
                    // Ustal docelowe wymiary
                    val targetWidth = dpToPx(context, 170) // Ustal szerokość
                    val targetHeight = dpToPx(context, 250) // Ustal wysokość
                    val zoomFactor = 2f

                    // Przytnij bitmapę do pożądanych wymiarów
                    val zoomedAndCroppedBitmap =
                        zoomAndCropBitmap(bitmap, targetWidth, targetHeight, zoomFactor)

                    if (zoomedAndCroppedBitmap != null) {
                        Image(
                            provider = ImageProvider(zoomedAndCroppedBitmap),
                            contentDescription = "Map Image",
                            modifier = GlanceModifier
                                .cornerRadius(20.dp)
                        )
                    }
                }

                Row(
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .padding(top = 10.dp),
                    verticalAlignment = Alignment.Vertical.CenterVertically,
                    horizontalAlignment = Alignment.Horizontal.CenterHorizontally,
                ) {
                    Image(
                        provider = ImageProvider(R.mipmap.open_padlock),
                        contentDescription = "Open Padlock",
                        modifier = GlanceModifier.size(60.dp)
                    )

                    Switch(
                        checked = isArmed,
                        onCheckedChange = actionRunCallback<SwitchAction>(),
                        modifier = GlanceModifier.padding(16.dp)
                    )

                    Image(
                        provider = ImageProvider(R.mipmap.closed_padlock),
                        contentDescription = "Closed Padlock",
                        modifier = GlanceModifier.size(60.dp)
                    )
                }
            }
        }
    }

    private fun zoomAndCropBitmap(
        source: Bitmap,
        targetWidth: Int,
        targetHeight: Int,
        zoomFactor: Float
    ): Bitmap {
        // Obliczamy nowe wymiary po skalowaniu
        val scaledWidth = (source.width * zoomFactor).toInt()
        val scaledHeight = (source.height * zoomFactor).toInt()

        // Upewniamy się, że skalowane wymiary są większe niż docelowe wymiary
        if (scaledWidth < targetWidth || scaledHeight < targetHeight) {
            throw IllegalArgumentException("Skalowane wymiary są mniejsze niż docelowe wymiary. Zmniejsz zoomFactor.")
        }

        // Skalujemy bitmapę
        val scaledBitmap = Bitmap.createScaledBitmap(source, scaledWidth, scaledHeight, true)

        // Obliczamy środek bitmapy po skalowaniu
        val xOffset = (scaledBitmap.width - targetWidth) / 2
        val yOffset = (scaledBitmap.height - targetHeight) / 2

        // Tworzymy przyciętą bitmapę od środka
        return Bitmap.createBitmap(scaledBitmap, xOffset, yOffset, targetWidth, targetHeight)
    }

    fun dpToPx(context: Context, dp: Int): Int {
        return (dp * context.resources.displayMetrics.density).toInt()
    }

}

class SwitchAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val isArmed = prefs.getBoolean("flutter.deviceArmedKey", false)
        prefs.edit().putBoolean("flutter.deviceArmedKey", !isArmed).apply()

    }
}