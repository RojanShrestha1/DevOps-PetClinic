# 🚀 Spring PetClinic DevOps Infrastructure

An automated, production-ready AWS ecosystem built with **Terraform**, **Ansible**, and **GitHub Actions**. This project demonstrates how to deploy a scalable Spring PetClinic application while maintaining comprehensive monitoring with **Prometheus** and **Grafana** for observability and cost optimization.

---

## 🏗️ Architecture Overview

The infrastructure is designed for high availability and observability across multiple Availability Zones in the **Mumbai (ap-south-1)** region.

```
┌─────────────────────────────────────────────────────────────────────┐
│                          AWS VPC (ap-south-1)                       │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                     Internet Gateway                          │  │
│  └─────────────────────────┬────────────────────────────────────┘  │
│                            │                                        │
│  ┌────────────────────────▼─────────────────────────────────────┐  │
│  │         Application Load Balancer (ALB - Port 80)            │  │
│  └─────────────────────────┬─────────────────────────────────────┘  │
│                            │                                        │
│  ┌────────────────────────▼─────────────────────────────────────┐  │
│  │           Auto Scaling Group (Min: 1, Max: 3)               │  │
│  │  ┌──────────────────────────────────────────────────────┐   │  │
│  │  │  EC2 Instance (Ubuntu + Docker)                      │   │  │
│  │  │  • Spring PetClinic App (Port 8080)                  │   │  │
│  │  │  • Node Exporter (Port 9100)                         │   │  │
│  │  └──────────────────────────────────────────────────────┘   │  │
│  │  ┌──────────────────────────────────────────────────────┐   │  │
│  │  │  EC2 Instance (Ubuntu + Docker) - Optional Scale     │   │  │
│  │  └──────────────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │        Monitoring EC2 Instance (Ubuntu)                      │  │
│  │  • Prometheus (Port 9090) - Metrics Scraping & Storage      │  │
│  │  • Grafana (Port 3000) - Dashboard & Visualization          │  │
│  │  • Node Exporter (Port 9100)                                │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘

GitHub Actions
    ↓
Terraform State: S3 + DynamoDB (State Locking)
```

---

## 🛠️ The Tech Stack

| Tool | Purpose |
| :--- | :--- |
| **Terraform** | Infrastructure as Code (IaC) for AWS resource provisioning. |
| **Ansible** | Configuration Management (Docker setup, Node Exporter installation). |
| **Docker** | Containerization of the Spring PetClinic (Java/Gradle) application. |
| **Prometheus** | Time-series database for metrics collection and Service Discovery. |
| **Grafana** | Visualization dashboard for real-time CPU/Memory/Network monitoring. |
| **AWS** | Cloud provider (VPC, EC2, IAM, S3, ALB, ASG). |

---

## 🚦 Features

### 1. Automated CI/CD Pipeline
* **Terraform State Locking:** S3 and DynamoDB prevent concurrent infrastructure changes.
* **GitHub Actions:** Automatic validation and planning on every push.

### 2. Service Discovery & Monitoring
* **Dynamic Instance Discovery:** Prometheus automatically discovers new EC2 instances launched by the ASG.
* **System-Level Metrics:** Node Exporter deployed via Ansible for comprehensive monitoring.

### 3. Security & Cost Management
* **Least Privilege IAM:** Custom roles for monitoring server with read-only EC2 access.
* **Security Groups:** Hardened firewalls (ALB: 80, Prometheus: 9090, Grafana: 3000).
* **Cost Control:** ASG limits and AWS Budgets integration.

---

## 🚀 Deployment Guide

### Prerequisites
* AWS CLI configured with a profile (e.g., `Techaxis`).
* Terraform installed on your local machine.
* SSH Key named `My_cloud` in your AWS region.

### Steps
1.  **Initialize the Backend:**
    ```bash
    terraform init
    ```
2.  **Verify the Plan:**
    ```bash
    terraform plan
    ```
3.  **Apply the Infrastructure:**
    ```bash
    terraform apply --auto-approve
    ```

---

## 📊 Visualizing Results

Once deployed, access your infrastructure:

* **Application:** `http://<ALB_DNS_NAME>`
* **Prometheus Target Discovery:** `http://<MONITORING_IP>:9090/targets`
* **Grafana Dashboard:** `http://<MONITORING_IP>:3000` (admin/admin)

### Verify Monitoring:
```bash
sudo apt install stress -y
stress --cpu 4 --timeout 60s
```

or

```bash
docker compose up postgres
```

## Test Applications

At development time we recommend you use the test applications set up as `main()` methods in `PetClinicIntegrationTests` (using the default H2 database and also adding Spring Boot Devtools), `MySqlTestApplication` and `PostgresIntegrationTests`. These are set up so that you can run the apps in your IDE to get fast feedback and also run the same classes as integration tests against the respective database. The MySql integration tests use Testcontainers to start the database in a Docker container, and the Postgres tests use Docker Compose to do the same thing.

## Compiling the CSS

There is a `petclinic.css` in `src/main/resources/static/resources/css`. It was generated from the `petclinic.scss` source, combined with the [Bootstrap](https://getbootstrap.com/) library. If you make changes to the `scss`, or upgrade Bootstrap, you will need to re-compile the CSS resources using the Maven profile "css", i.e. `./mvnw package -P css`. There is no build profile for Gradle to compile the CSS.

## Working with Petclinic in your IDE

### Prerequisites

The following items should be installed in your system:

- Java 17 or newer (full JDK, not a JRE)
- [Git command line tool](https://help.github.com/articles/set-up-git)
- Your preferred IDE
  - Eclipse with the m2e plugin. Note: when m2e is available, there is a m2 icon in `Help -> About` dialog. If m2e is
  not there, follow the installation process [here](https://www.eclipse.org/m2e/)
  - [Spring Tools Suite](https://spring.io/tools) (STS)
  - [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  - [VS Code](https://code.visualstudio.com)

### Steps

1. On the command line run:

    ```bash
    git clone https://github.com/spring-projects/spring-petclinic.git
    ```

1. Inside Eclipse or STS:

    Open the project via `File -> Import -> Maven -> Existing Maven project`, then select the root directory of the cloned repo.

    Then either build on the command line `./mvnw generate-resources` or use the Eclipse launcher (right-click on project and `Run As -> Maven install`) to generate the CSS. Run the application's main method by right-clicking on it and choosing `Run As -> Java Application`.

1. Inside IntelliJ IDEA:

    In the main menu, choose `File -> Open` and select the Petclinic [pom.xml](pom.xml). Click on the `Open` button.

    - CSS files are generated from the Maven build. You can build them on the command line `./mvnw generate-resources` or right-click on the `spring-petclinic` project then `Maven -> Generates sources and Update Folders`.

    - A run configuration named `PetClinicApplication` should have been created for you if you're using a recent Ultimate version. Otherwise, run the application by right-clicking on the `PetClinicApplication` main class and choosing `Run 'PetClinicApplication'`.

1. Navigate to the Petclinic

    Visit [http://localhost:8080](http://localhost:8080) in your browser.

## Looking for something in particular?

|Spring Boot Configuration | Class or Java property files  |
|--------------------------|---|
|The Main Class | [PetClinicApplication](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java) |
|Properties Files | [application.properties](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/resources) |
|Caching | [CacheConfiguration](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/java/org/springframework/samples/petclinic/system/CacheConfiguration.java) |

## Interesting Spring Petclinic branches and forks

The Spring Petclinic "main" branch in the [spring-projects](https://github.com/spring-projects/spring-petclinic)
GitHub org is the "canonical" implementation based on Spring Boot and Thymeleaf. There are
[quite a few forks](https://spring-petclinic.github.io/docs/forks.html) in the GitHub org
[spring-petclinic](https://github.com/spring-petclinic). If you are interested in using a different technology stack to implement the Pet Clinic, please join the community there.

## Interaction with other open-source projects

One of the best parts about working on the Spring Petclinic application is that we have the opportunity to work in direct contact with many Open Source projects. We found bugs/suggested improvements on various topics such as Spring, Spring Data, Bean Validation and even Eclipse! In many cases, they've been fixed/implemented in just a few days.
Here is a list of them:

| Name | Issue |
|------|-------|
| Spring JDBC: simplify usage of NamedParameterJdbcTemplate | [SPR-10256](https://github.com/spring-projects/spring-framework/issues/14889) and [SPR-10257](https://github.com/spring-projects/spring-framework/issues/14890) |
| Bean Validation / Hibernate Validator: simplify Maven dependencies and backward compatibility |[HV-790](https://hibernate.atlassian.net/browse/HV-790) and [HV-792](https://hibernate.atlassian.net/browse/HV-792) |
| Spring Data: provide more flexibility when working with JPQL queries | [DATAJPA-292](https://github.com/spring-projects/spring-data-jpa/issues/704) |

## Contributing

The [issue tracker](https://github.com/spring-projects/spring-petclinic/issues) is the preferred channel for bug reports, feature requests and submitting pull requests.

For pull requests, editor preferences are available in the [editor config](.editorconfig) for easy use in common text editors. Read more and download plugins at <https://editorconfig.org>. All commits must include a __Signed-off-by__ trailer at the end of each commit message to indicate that the contributor agrees to the Developer Certificate of Origin.
For additional details, please refer to the blog post [Hello DCO, Goodbye CLA: Simplifying Contributions to Spring](https://spring.io/blog/2025/01/06/hello-dco-goodbye-cla-simplifying-contributions-to-spring).

## License

The Spring PetClinic sample application is released under version 2.0 of the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).
