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
    ndkVersion = "27.2.12479018"

    defaultConfig {
        applicationId = "com.mateusrodcosta.apps.vidyamusic"
        minSdk = 28
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // libdatastore_shared_counter.so has been pulled in as a dependency
        // however it tries to ship for x86, which Flutter doesn't support
        // Therefore restrict native libs to only arches supported by Flutter
        ndk {
            abiFilters.addAll(arrayOf("armeabi-v7a", "arm64-v8a", "x86_64"))
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String

            // Force disable v2 signing and only enable v3 signing scheme
            enableV2Signing = false
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

            ndk {
                // Should solve the "native code but no debug symbols" message from Play Console
                // This follows https://developer.android.com/build/shrink-code#android_gradle_plugin_version_41_or_later
                debugSymbolLevel = "FULL"
            }
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
            // Detect app bundle and conditionally disable split abis
            // This is needed due to a "Sequence contains more than one matching element" error
            // present since AGP 8.9.0, for more info see:
            // https://issuetracker.google.com/issues/402800800

            // AppBundle tasks usually contain "bundle" in their name
            val isBuildingBundle = gradle.startParameter.taskNames.any { it.lowercase().contains("bundle") }

            // Disable split abis when building appBundle
            isEnable = !isBuildingBundle

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

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    packaging {
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
