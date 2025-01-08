plugins {
    id("java")
    id("war")
    kotlin("jvm")
}

group = "org.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(platform("org.junit:junit-bom:5.10.0"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    implementation(kotlin("stdlib-jdk8"))

    // Use the Jakarta Servlet API for web development.
    implementation("jakarta.servlet:jakarta.servlet-api:5.0.0")

    // Add ZXing dependencies for QR code generation.
    implementation("com.google.zxing:core:3.5.2")
    implementation("com.google.zxing:javase:3.5.2")

    // https://mvnrepository.com/artifact/org.postgresql/postgresql
    implementation("org.postgresql:postgresql:42.1.4")

    implementation("io.github.cdimascio:dotenv-kotlin:6.4.2")

    implementation("com.google.code.gson:gson:2.8.9")

    // pdf generation
    implementation("com.itextpdf:itext7-core:7.1.15")

}

tasks.test {
    useJUnitPlatform()
}
kotlin {
    jvmToolchain(11)
}