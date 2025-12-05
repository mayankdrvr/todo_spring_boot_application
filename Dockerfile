# Use a Maven build image
FROM maven:3.9.1-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the Spring Boot jar
RUN mvn clean package -DskipTests

# Use a lightweight JDK runtime image
FROM eclipse-temurin:17-jdk-alpine

# Set working directory
WORKDIR /app

# Copy jar from build stage
COPY --from=build /app/target/todoapp-0.0.1-SNAPSHOT.jar app.jar

# Expose port (same as Spring Boot default)
EXPOSE 8080

# Run the jar
ENTRYPOINT ["java","-jar","app.jar"]
