# FROM openjdk:17-jdk-slim
# WORKDIR /app
# COPY target/app.jar app.jar
# EXPOSE 8080
# CMD ["java", "-jar", "app.jar"]

#FROM maven:3.8.5-openjdk-17 AS build
#WORKDIR /app
#COPY . .
#RUN mvn clean package -DskipTests

#FROM openjdk:17-jdk-slim
#WORKDIR /app
#COPY --from=build /app/target/*.jar app.jar
#EXPOSE 8080
#CMD ["java", "-jar", "app.jar"]

# Build stage
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Runtime stage
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copy wait-for-it.sh script
COPY wait-for-it.sh wait-for-it.sh
RUN chmod +x wait-for-it.sh

# Copy JAR
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Wait for DB before starting app
CMD ["./wait-for-it.sh", "db", "3306", "--", "java", "-jar", "app.jar"]

