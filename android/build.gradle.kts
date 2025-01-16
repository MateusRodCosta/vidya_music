allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory = file("../build")
subprojects {
    project.layout.buildDirectory = rootProject.layout.buildDirectory.dir(project.name)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks {
    task<Delete>("clean") {
        delete(rootProject.layout.buildDirectory)
    }
}
