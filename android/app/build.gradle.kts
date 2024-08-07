import java.util.Properties
import com.android.build.api.variant.FilterConfiguration.FilterType.*

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localPropertiesFile = rootProject.file("local.properties")
val localProperties = Properties()
if (localPropertiesFile.exists()) {
    localProperties.load(localPropertiesFile.inputStream())
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

kotlin {
    jvmToolchain(17)
}

android {
    namespace = "com.mateusrodcosta.apps.vidyamusic"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.mateusrodcosta.apps.vidyamusic"
        minSdk = 26
        targetSdk = 34
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String

            // Always enable v2 and v3 signing schemes, which will be used on modern Android OSes
            enableV2Signing = true
            enableV3Signing = true
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
            manifestPlaceholders["appName"] = "Vidya Music"
        }
        getByName("debug") {
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
            manifestPlaceholders["appName"] = "Vidya Music (Debug)"
        }
        getByName("profile") {
            applicationIdSuffix = ".profile"
            versionNameSuffix = "-profile"
            manifestPlaceholders["appName"] = "Vidya Music (Profile)"
        }
    }

    splits {
        abi {
            isEnable = true

            reset()
            //noinspection ChromeOsAbiSupport
            include("armeabi-v7a", "arm64-v8a", "x86_64")

            isUniversalApk = true
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-splashscreen:1.0.1")
}

val abiCodes = mapOf("armeabi-v7a" to 1, "arm64-v8a" to 2, "x86_64" to 4)


androidComponents {
    onVariants { variant ->

        variant.outputs.forEach { output ->
            val name = output.filters.find { it.filterType == ABI }?.identifier

            val baseAbiCode = abiCodes[name]

            if (baseAbiCode != null) {
                output.versionCode.set(
                    // As required by F-Droid, version code at beginning and abi code at the end
                    // If wanting to build a universal APK with similar naming scheme, do so manually
                    // via `--build-number` argument from `flutter build apk`
                    baseAbiCode * 100 + (output.versionCode.get() ?: 0)
                    // Default split apk version code, api code at beginning and version code at the end
                    //baseAbiVersionCode * 1000 + variant.versionCode
                )
            }
        }
    }
}

