// T409: distribución exige HTTPS, cuentas del servidor y firma propia.
// Credenciales solo en archivo local excluido de Git; nunca se incluyen en Dart.
import java.net.URI
import java.security.KeyStore
import java.security.PrivateKey
import java.security.cert.X509Certificate
import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // El complemento de Flutter va después de los de Android y Kotlin: los necesita
    // ya cargados para agregar el código Dart a la compilación.
    id("dev.flutter.flutter-gradle-plugin")
}


val dartDefines = project.findProperty("dart-defines")?.toString()
    ?.split(",")?.mapNotNull { encoded ->
        runCatching { String(Base64.getDecoder().decode(encoded), Charsets.UTF_8) }.getOrNull()
    }?.mapNotNull { value ->
        val index = value.indexOf('=')
        if (index < 1) null else value.substring(0, index) to value.substring(index + 1)
    }?.toMap() ?: emptyMap()

// La ruta alternativa permite CI y pruebas con claves sintéticas en /tmp.
val signingPropertiesFile = rootProject.file(
    project.findProperty("handtextSigningProperties")?.toString() ?: "key.properties",
)
val signingProperties = Properties().apply {
    if (signingPropertiesFile.isFile) signingPropertiesFile.inputStream().use { load(it) }
}
val signingFields = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
val hasSigningFields = signingFields.all { !signingProperties.getProperty(it).isNullOrBlank() }
val releaseStore = signingProperties.getProperty("storeFile")?.let { rootProject.file(it) }

val checkReleaseConfiguration = tasks.register("checkReleaseConfiguration") {
    doLast {
        val uri = runCatching { URI(dartDefines["API_BASE_URL"] ?: "") }.getOrNull()
        if (uri == null || uri.scheme != "https" || uri.host.isNullOrEmpty() ||
            uri.rawUserInfo != null || uri.rawQuery != null || uri.rawFragment != null ||
            uri.host in setOf("localhost", "127.0.0.1", "10.0.2.2", "[::1]")) {
            throw GradleException("API_HTTPS_REQUIRED: API_BASE_URL HTTPS explícita sin credenciales.")
        }
        if (dartDefines["HOSTED_ACCOUNTS"] != "true") {
            throw GradleException("HOSTED_REQUIRED: la distribución usa cuentas del servidor.")
        }
        if (!dartDefines["LOCAL_DEV_API_TOKEN"].isNullOrEmpty() ||
            project.findProperty("permitirHttpLocal") == "true") {
            throw GradleException("LOCAL_DEV_FORBIDDEN: use debug para desarrollo local.")
        }
        if (!hasSigningFields || releaseStore?.isFile != true) {
            throw GradleException("SIGNING_REQUIRED: configure key.properties y la clave de entrega autorizada.")
        }
        try {
            val store = KeyStore.getInstance(releaseStore, signingProperties.getProperty("storePassword").toCharArray())
            val alias = signingProperties.getProperty("keyAlias")
            val certificate = store.getCertificate(alias) as? X509Certificate
                ?: throw IllegalStateException()
            if (alias.equals("androiddebugkey", ignoreCase = true) ||
                certificate.subjectX500Principal.name.contains("CN=Android Debug", ignoreCase = true)) {
                throw GradleException("DEBUG_SIGNING_FORBIDDEN: la firma debug no es una firma de entrega.")
            }
            certificate.checkValidity()
            if (store.getKey(alias, signingProperties.getProperty("keyPassword").toCharArray()) !is PrivateKey) {
                throw IllegalStateException()
            }
        } catch (error: GradleException) {
            throw error
        } catch (_: Exception) {
            // No divulgar contraseñas, alias, rutas o detalles del almacén.
            throw GradleException("SIGNING_INVALID: no se pudo validar la clave de entrega.")
        }
    }
}
// Fallar antes de compilar Dart, sin ruta de firma debug alternativa.
tasks.matching { it.name in setOf("preReleaseBuild", "compileFlutterBuildRelease") }
    .configureEach { dependsOn(checkReleaseConfiguration) }

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

    signingConfigs {
        if (hasSigningFields && releaseStore?.isFile == true) {
            create("release") {
                storeFile = releaseStore
                storePassword = signingProperties.getProperty("storePassword")
                keyAlias = signingProperties.getProperty("keyAlias")
                keyPassword = signingProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        debug {
            applicationIdSuffix = ".debug"
            // La API de desarrollo corre en el computador: http://10.0.2.2:8001.
            manifestPlaceholders["usesCleartextTraffic"] = "true"
        }
        release {
            if (hasSigningFields && releaseStore?.isFile == true) {
                signingConfig = signingConfigs.getByName("release")
            }
            // No se permite HTTP ni se usa firma debug como sustituto.
            manifestPlaceholders["usesCleartextTraffic"] = "false"
        }
    }
}

flutter {
    source = "../.."
}
