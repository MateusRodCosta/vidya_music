import java.util.Properties
import com.android.build.api.variant.FilterConfiguration.FilterType.*
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

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

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

kotlin {
    jvmToolchain(21)
    compilerOptions {
        jvmTarget = JvmTarget.JVM_21
    }
}

android {
    namespace = "com.mateusrodcosta.apps.vidyamusic"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.mateusrodcosta.apps.vidyamusic"
        minSdk = 26
        //noinspection OldTargetApi
        targetSdk = 34
        versionCode = flutter.versionCode
        // Temporarily override versionName due to https://github.com/MateusRodCosta/vidya_music/issues/26
        //versionName = flutter.versionName
        versionName = "1.5.0b"
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
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    packaging {
        // This is set to false starting with minSdk >= 28, but I want uncompressed DEX files with minSdk 26
        // According to https://developer.android.com/build/releases/past-releases/agp-4-2-0-release-notes#dex-files-uncompressed-in-apks-when-minsdk-=-28-or-higher:
        //
        // > This causes an increase in APK size, but it results in a smaller installation size on the device, and the download size is roughly the same.
        //
        // Currently this makes the APK ~1.4MB heavier
        //
        dex.useLegacyPackaging = false
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
        dependenciesInfo {
            // Disables dependency metadata when building APKs, for F-Droid.
            // As instructed in https://github.com/MateusRodCosta/Share2Storage/issues/44
            includeInApk = false
        }
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
                    output.versionCode.get() * 100 + baseAbiCode
                )
            }
        }
    }
}
