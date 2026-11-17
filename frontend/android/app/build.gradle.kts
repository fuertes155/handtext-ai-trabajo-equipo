// Reinicio autorizado 2026-11-17. T409 pendiente de LUISDACA.
// Firma retirada; release bloqueada mientras exista frontend/LUIS_PENDIENTE.
// Se conservan los identificadores Android y las comprobaciones de URL compartidas.

import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    // El complemento de Flutter va después de los de Android y Kotlin: los necesita
    // ya cargados para agregar el código Dart a la compilación.
    id("dev.flutter.flutter-gradle-plugin")
}

// T409: Luis debe implementar y revisar la firma. No se modifican sus claves locales.
// El reinicio de tareas no es una versión que pueda entregarse.
val checkLuisReleaseReady = tasks.register("checkLuisReleaseReady") {
    val pending = rootProject.file("../LUIS_PENDIENTE")
    doLast {
        if (pending.exists()) {
            throw GradleException(
                "HandText: release bloqueada. Implementar y verificar las tareas de " +
                    "LUISDACA antes de retirar frontend/LUIS_PENDIENTE.",
            )
        }
    }
}

// Versión de demostración con la API local por HTTP (petición explícita, R8).
val allowLocalHttp = project.findProperty("permitirHttpLocal") == "true"

// URL de la API con la que se compila (--dart-define=API_BASE_URL=...). Flutter entrega
// los --dart-define a Gradle en la propiedad «dart-defines»: cada uno en base64 y
// separados por comas.
val apiBaseUrl: String? = project.findProperty("dart-defines")?.toString()
    ?.split(",")
    ?.mapNotNull { encoded ->
        runCatching { String(Base64.getDecoder().decode(encoded), Charsets.UTF_8) }.getOrNull()
    }
    ?.firstOrNull { it.startsWith("API_BASE_URL=") }
    ?.removePrefix("API_BASE_URL=")
    ?.trim()

// Una versión release que no puede hablar con la API no debe entregarse. Sin
// API_BASE_URL la app usaría http://10.0.2.2:8001/, que solo existe dentro del
// emulador; y con HTTP sin permitirHttpLocal, Android bloquea la conexión. En los dos
// casos el reconocimiento y la exportación no podrían conectarse; las cuentas son locales. Se comprueba
// antes de compilar la release (debug y las pruebas no cambian).
val checkReleaseApiUrl = tasks.register("checkReleaseApiUrl") {
    val url = apiBaseUrl
    val allowHttp = allowLocalHttp
    doLast {
        val problem = when {
            url.isNullOrEmpty() ->
                "falta --dart-define=API_BASE_URL=<dirección de la API>. Sin ella, la app " +
                    "usaría http://10.0.2.2:8001/, que solo existe dentro del emulador."
            url.startsWith("https://") -> null
            url.startsWith("http://") && allowHttp -> null
            url.startsWith("http://") ->
                "API_BASE_URL=$url usa HTTP, y la versión release solo permite HTTPS. " +
                    "Use una dirección HTTPS o, para una demostración local, agregue " +
                    "-P permitirHttpLocal=true."
            else -> "API_BASE_URL=$url debe empezar por https:// (o http:// en una demostración)."
        }
        if (problem != null) {
            throw GradleException("HandText AI: este APK no podría conectarse a la API: $problem")
        }
        if (url != null && url.contains("10.0.2.2")) {
            logger.warn("HandText AI: API_BASE_URL=$url solo funciona dentro del emulador.")
        }
    }
}
// Antes de compilar el código Dart, para avisar en segundos y no al final.
tasks.matching { it.name in setOf("preReleaseBuild", "compileFlutterBuildRelease") }
    .configureEach { dependsOn(checkLuisReleaseReady, checkReleaseApiUrl) }

android {
    namespace = "com.handtextai.handtext_ai"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Identificador único de la app en Android y en Google Play. No se cambia
        // después de publicarla: el teléfono la trataría como otra app y no se
        // actualizaría.
        applicationId = "com.handtextai.team"
        // Versiones de Android que admite la app: las que recomienda Flutter.
        // versionName y versionCode salen de «version» en pubspec.yaml
        // (1.0.0+N: versionName 1.0.0 y versionCode N).
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // [SC-506] Por omisión, Android rechaza HTTP sin cifrar.
        manifestPlaceholders["usesCleartextTraffic"] = "false"
    }

    buildTypes {
        debug {
            applicationIdSuffix = ".debug"
            // La API de desarrollo corre en el computador: http://10.0.2.2:8001.
            manifestPlaceholders["usesCleartextTraffic"] = "true"
        }
        release {
            // T409 pendiente: sin firma de depuración como sustituto de una entrega.
            // Se conserva la restricción segura de HTTPS incluso durante el reinicio.
            manifestPlaceholders["usesCleartextTraffic"] = "false"
        }
    }
}

flutter {
    source = "../.."
}
