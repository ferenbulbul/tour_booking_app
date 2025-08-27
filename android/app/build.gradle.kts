plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

/* ---------- ENV HELPER + LOADER (android {}'dan ÖNCE OLMALI) ---------- */
fun env(name: String): String {
    val extra = rootProject.extra
    val fromExtra = if (extra.has(name)) extra[name] as String else null
    val fromSys = System.getenv(name)
    val fromProp = project.findProperty(name) as String?
    return fromExtra ?: fromSys ?: fromProp
        ?: throw GradleException("Missing env: $name")
}

fun loadDotEnvIntoExtra(envFileName: String) {
    val f = rootProject.file(envFileName)
    if (!f.exists()) return
    println("Loading env from ${f.absolutePath}")
    f.readLines().forEach { raw ->
        val line = raw.trim()
        if (line.isEmpty() || line.startsWith("#")) return@forEach
        val eq = line.indexOf('=')
        if (eq <= 0) return@forEach
        val key = line.substring(0, eq).trim()
        var value = line.substring(eq + 1).trim()
        if ((value.startsWith("\"") && value.endsWith("\"")) ||
            (value.startsWith("'") && value.endsWith("'"))) {
            value = value.substring(1, value.length - 1)
        }
        rootProject.extensions.extraProperties.set(key, value)
    }
}

// dosya adın hangisiyse; ikisini de deniyoruz
loadDotEnvIntoExtra(".env.android")
/* ---------------------------------------------------------------------- */

android {
    namespace = "com.tourbooking.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

    defaultConfig {
        applicationId = "com.tourbooking.app"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["onesignal_app_id"] = "f8fa783c-24c8-4655-b17d-2ecbc6a8ab22"
        manifestPlaceholders["onesignal_google_project_number"] = "REMOTE"
    }

    signingConfigs {
        create("release") {
            storeFile = file(env("ANDROID_STORE_FILE"))
            storePassword = env("ANDROID_STORE_PASSWORD")
            keyAlias = env("ANDROID_KEY_ALIAS")
            keyPassword = env("ANDROID_KEY_PASSWORD")
        }
    }
    buildTypes {
        release {
            // 🔴 debug imzası KULLANMA
            signingConfig = signingConfigs.getByName("release")  // ✅
            isMinifyEnabled = false
            isShrinkResources = false 
        }
    }
}

flutter { source = "../.." }

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.2.0"))
    implementation("com.google.firebase:firebase-messaging-ktx")
}
