package com.example.app_security

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import androidx.annotation.RequiresApi
import androidx.annotation.RequiresPermission
import androidx.core.app.ActivityCompat
import com.kevlar.antipiracy.KevlarAntipiracy
import com.kevlar.antipiracy.dsl.attestation.AntipiracyAttestation
import com.kevlar.rooting.KevlarRooting
import kotlinx.coroutines.runBlocking

class AppSecurityApiImpl(private val context: Context) : AppSecurityApi {



    override fun isUseJailBrokenOrRoot(): Boolean = runBlocking {
        val rooting = KevlarRooting {}
        val result = rooting.attestateTargets(context)
        println("isUseJailBrokenOrRoot");
        println(result);
        result::class.simpleName == "Failed"
    }

    @RequiresApi(Build.VERSION_CODES.M)
    @androidx.annotation.RequiresPermission(Manifest.permission.ACCESS_NETWORK_STATE)
    override fun isDeviceUseVPN(): Boolean {
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val network = cm.activeNetwork ?: return false
        val capabilities = cm.getNetworkCapabilities(network)
        return capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true
    }

    override fun isItRealDevice(): Boolean {
        return !(Build.FINGERPRINT.contains("generic") ||
                Build.MODEL.contains("google_sdk") ||
                Build.MODEL.lowercase().contains("emulator") ||
                Build.BRAND.startsWith("generic") ||
                Build.DEVICE.startsWith("generic") ||
                Build.PRODUCT.contains("sdk") ||
                Build.PRODUCT.contains("emulator"))
    }

    override fun checkIsTheDeveloperModeOn(): Boolean {
        return Settings.Global.getInt(context.contentResolver,
            Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0
    }

    override fun isRunningInTestFlight(): Boolean {
        return false
    }

    @RequiresApi(Build.VERSION_CODES.O)
    @RequiresPermission("android.permission.READ_PRIVILEGED_PHONE_STATE")
    @SuppressLint("ServiceCast", "HardwareIds")
    override fun getIMEI(): String? {
        return try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                val telephonyManager =
                    context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
                if (ActivityCompat.checkSelfPermission(
                        context,
                        Manifest.permission.READ_PHONE_STATE
                    ) == PackageManager.PERMISSION_GRANTED
                ) {
                    telephonyManager.imei ?: telephonyManager.deviceId ?: "Unavailable"
                } else {
                   null
                }
            } else {
                null
            }
        } catch (e: Exception) {
            e.printStackTrace()
           null
        }
    }

    @SuppressLint("HardwareIds")
    override fun getDeviceId(): String? {
        return Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
    }

    override fun installSource(): String? {
        val installer = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            context.packageManager.getInstallSourceInfo(context.packageName).installingPackageName
        } else {
            context.packageManager.getInstallerPackageName(context.packageName)
        }
        return installer;
    }

    override fun isSafeEnvironment(): List<String> {
        return isPiracyDetectedFull(context);
    }

    private fun isPiracyDetectedFull(context: Context): List<String> = runBlocking {
        val antiPiracy = KevlarAntipiracy.Defaults.Full()
        val att = antiPiracy.attestate(context)
        println("isPiracyDetectedFull");
        println(att);
        decodePiracyErrors(att)
    }

    private fun decodePiracyErrors(att: AntipiracyAttestation): List<String> = when (att) {
        is AntipiracyAttestation.Failed -> att.scanResult.detectedEntries.map { it.name }
        else -> emptyList()
    }

    override fun installedFromValidSource(sourceList: List<String>): Boolean = runBlocking {
      val res=  isPiracyDetectedFull(context);
        println("installedFromValidSource");
        println(res);
        val installer = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            context.packageManager.getInstallSourceInfo(context.packageName).installingPackageName
        } else {
            context.packageManager.getInstallerPackageName(context.packageName)
        }

        installer != null && sourceList.any { installer.contains(it, ignoreCase = true) }
    }

    @SuppressLint("SdCardPath")
    override fun isClonedApp(): Boolean {
        val filesDirPath = context.filesDir.absolutePath // Similar to getApplicationDocumentsDirectory()
        val matchCount = Regex("/data/user/0").findAll(filesDirPath).count()
        return matchCount != 1
    }

}
