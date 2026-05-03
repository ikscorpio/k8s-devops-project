FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app 
COPY app/target/k8s-devops-app-1.0.jar app.jar
CMD ["java", "-jar", "app.jar"]
