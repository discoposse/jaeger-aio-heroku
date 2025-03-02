# Deploying Jaeger (All-in-One) on Heroku with Docker

This repository provides a **step-by-step guide** to deploying **Jaeger (all-in-one)** on **Heroku** using **Docker**. This setup is ideal for collecting traces from **Odigos** or other OpenTelemetry-enabled applications.

---

## **Prerequisites**
Before you begin, ensure you have the following installed:

- [Docker](https://www.docker.com/get-started)
- [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli)
- [Git](https://git-scm.com)

---

## **Step 1: Create a New Heroku App**
1. **Log in to Heroku**:
   ```sh
   heroku login
   ```

2. **Create the Heroku app**:
   ```sh
   heroku create jaeger-heroku
   ```
   *(Replace `jaeger-heroku` with your preferred app name.)*

3. **Enable Heroku Container Registry**:
   ```sh
   heroku stack:set container -a jaeger-heroku
   ```

---

## **Step 2: Create a Dockerfile**
Create a `Dockerfile` in your project directory:

```dockerfile
# Use the official Jaeger all-in-one image
FROM jaegertracing/all-in-one:latest

# Expose necessary ports
EXPOSE 5775/udp 6831/udp 6832/udp 5778 16686 14268 14250 4317 4318

# Start Jaeger all-in-one
CMD ["/go/bin/all-in-one-linux"]
```

---

## **Step 3: Create a `heroku.yml` File**
Create a `heroku.yml` file to define the deployment:

```yaml
build:
  docker:
    web: Dockerfile
run:
  web: /go/bin/all-in-one-linux
```

---

## **Step 4: Deploy to Heroku**

1. **Initialize a Git repository**:
   ```sh
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. **Log into Heroku container registry**:
   ```sh
   heroku container:login
   ```

3. **Push the Docker image to Heroku**:
   ```sh
   heroku container:push web -a jaeger-heroku
   ```

4. **Release the image**:
   ```sh
   heroku container:release web -a jaeger-heroku
   ```

5. **Check logs to confirm deployment**:
   ```sh
   heroku logs --tail -a jaeger-heroku
   ```

---

## **Step 5: Verify Deployment**
Jaeger should now be running. Access the **Jaeger UI** at:

```
https://jaeger-heroku.herokuapp.com
```

*(Replace `jaeger-heroku` with your actual Heroku app name.)*

---

## **Additional Configuration**
### **Configuring Odigos to Send Data to Jaeger**

Odigos should be configured to send traces to **your Heroku-hosted Jaeger collector** using **OTLP gRPC (`4317`)** or **OTLP HTTP (`4318`)**.

Example OpenTelemetry Collector configuration:

```yaml
exporters:
  otlp:
    endpoint: "https://jaeger-heroku.herokuapp.com:4317"
    tls:
      insecure: true
```

### **Customizing Storage**
By default, this setup uses **in-memory storage**. For persistent traces, configure Jaeger with **Elasticsearch** or another storage backend.

---
