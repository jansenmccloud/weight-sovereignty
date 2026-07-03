import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// isar_flutter_libs 3.1.x: no namespace, compileSdk 30 → release fails (android:attr/lStar)
subprojects {
    afterEvaluate {
        if (name != "isar_flutter_libs") return@afterEvaluate
        extensions.findByType(LibraryExtension::class.java)?.apply {
            namespace = "dev.isar.isar_flutter_libs"
            compileSdk = 34
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
