# Bước 1: Dùng Maven để build project ra file .war
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Bước 2: Dùng Tomcat để chạy file .war vừa build
FROM tomcat:9.0-jdk17
# Xóa các app mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copy file .war vào Tomcat và đổi tên thành ROOT.war để chạy ở trang chủ
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
