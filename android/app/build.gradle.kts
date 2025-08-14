import com.android.build.gradle.internal.api.BaseVariantOutputImpl
import java.util.Date
import java.text.SimpleDateFormat

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fingerprint_app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.fingerprint_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            applicationVariants.all {
                outputs.all { output ->
                    if (output is BaseVariantOutputImpl) {
                        val project = "Surveryor App"
                        val separator = "_"
                        val buildType = buildType.name
                        val version = versionName
                        val formattedDate = SimpleDateFormat("MM-dd-yyyy_hh-mm").format(Date())
                        val filename =
                            "$project$version$separator$buildType$separator$formattedDate.apk"
                        output.outputFileName = filename
                    }
                    true
                }
            }
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                // Includes the default ProGuard rules files that are packaged with
                // the Android Gradle plugin. To learn more, go to the section about
                // R8 configuration files.
                getDefaultProguardFile("proguard-android-optimize.txt"),

                // Includes a local, custom Proguard rules file
                "proguard-rules.pro"
            )
        }
    }
    
    flavorDimensions += "flavors"
    productFlavors {
        create("development") {
            dimension = "flavors"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-ocrapi"
            // versionNameSuffix = "-alpha"
        }

        create("staging") {
            dimension = "flavors"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-ocrmobile"
            // versionNameSuffix = "-beta"
        }

        create("production") {
            dimension = "flavors"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.aar"))))
}