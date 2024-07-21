# Stage 1: Build
FROM gradle:8.2-jdk17 AS build

# Set working directory
WORKDIR /app

# Copy Gradle build files and wrapper
COPY build.gradle settings.gradle ./
COPY gradle ./gradle

# Download Gradle dependencies
RUN gradle build --no-daemon

# Copy project source
COPY src ./src

# Build the project
RUN gradle build --no-daemon

# Stage 2: Run
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/build/libs/demo-0.0.1-SNAPSHOT.jar /app/demo.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "/app/demo.jar"]
#dsa.dsadsadas
