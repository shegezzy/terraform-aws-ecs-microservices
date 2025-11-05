# Terraform AWS ECS Microservices Infrastructure

## Overview

This repository contains Infrastructure as Code (IaC) using Terraform to provision a complete AWS cloud infrastructure for deploying microservices applications. The infrastructure is designed for production workloads with high availability, security, and scalability in mind.

## Cloud Platform Choice: AWS

### Why AWS?

**Market Leadership & Maturity**: AWS is the market leader in cloud computing with the most comprehensive service portfolio and longest track record of enterprise adoption.

**Service Breadth**: Offers managed services for every infrastructure component needed (ECS, RDS, ElastiCache, MSK, etc.), reducing operational overhead.

**Global Infrastructure**: Extensive global footprint with 25+ regions and 80+ availability zones, enabling low-latency deployments worldwide.

**Enterprise Features**: Robust security, compliance certifications (SOC 2, PCI DSS, HIPAA), and enterprise support.

**Cost Optimization**: Pay-as-you-go pricing, reserved instances, and savings plans provide cost-effective scaling.

**Integration**: Seamless integration between services with native networking, security, and monitoring capabilities.

## Architecture Design

### Infrastructure Components

- **Networking**: VPC with public/private subnets, NAT gateways, and VPC endpoints
- **Compute**: Amazon ECS with AWS Fargate for serverless container execution
- **Load Balancing**: Application Load Balancer with health checks and auto-scaling
- **Data Storage**: Amazon RDS PostgreSQL for relational data, ElastiCache Redis for caching
- **Messaging**: Amazon Managed Streaming for Apache Kafka (MSK) for event-driven communication
- **Security**: Security groups, IAM roles, encryption at rest/transit, and Secrets Manager

### Design Principles

**Microservices Architecture**: Each service runs independently with its own compute resources, scaling, and data storage requirements.

**Security First**: Defense-in-depth approach with network isolation, least-privilege access, and encryption.

**High Availability**: Multi-AZ deployment for all critical components with automatic failover.

**Scalability**: Auto-scaling based on CPU utilization with horizontal scaling capabilities.

**Cost Efficiency**: Use of managed services, reserved capacity planning, and resource optimization.

**Observability**: Comprehensive monitoring with CloudWatch metrics, logs, and alerts.

## Assumptions Made

### Infrastructure Assumptions

1. **Multi-Environment Support**: Infrastructure supports staging and production environments with separate configurations
2. **Three Availability Zones**: Default configuration assumes 3 AZs for high availability
3. **Fargate-Only**: All container workloads run on AWS Fargate (serverless) for operational simplicity
4. **PostgreSQL Compatibility**: Database choice assumes PostgreSQL-compatible workloads
5. **Event-Driven Architecture**: MSK inclusion assumes asynchronous communication patterns between services

### Security Assumptions

1. **Private Networking**: All application components (ECS, databases, caches) reside in private subnets
2. **Internet-Facing ALB**: Application Load Balancer is internet-accessible for external traffic
3. **No Direct Database Access**: Databases are only accessible from ECS services, not directly from internet
4. **Secrets Management**: Sensitive data (DB credentials) stored in AWS Secrets Manager
5. **TLS Encryption**: All data in transit is encrypted using TLS/SSL

### Operational Assumptions

1. **Containerized Applications**: All microservices are containerized and follow 12-factor app principles
2. **Health Check Endpoints**: Services implement `/health` endpoints for load balancer health checks
3. **CloudWatch Logging**: Applications write structured logs to stdout/stderr for CloudWatch ingestion
4. **Environment Variables**: Configuration passed via environment variables and Secrets Manager
5. **CI/CD Integration**: Infrastructure deployed via automated pipelines with proper approvals

### Cost Assumptions

1. **On-Demand Pricing**: Initial deployment uses on-demand pricing; reserved instances planned for production
2. **Traffic Patterns**: Auto-scaling configured for variable workloads with CPU-based scaling
3. **Data Transfer**: VPC endpoints used to minimize data transfer costs
4. **Storage Optimization**: Appropriate instance sizes selected based on typical workloads

### Compliance Assumptions

1. **Data Residency**: No specific data residency requirements (deployable in any AWS region)
2. **Encryption Standards**: AES-256 encryption for data at rest, TLS 1.2+ for data in transit
3. **Access Logging**: All access to resources is logged for audit purposes
4. **Backup Retention**: 7-day backup retention for databases (configurable)

## Prerequisites

- **AWS Account**: With appropriate permissions for infrastructure provisioning
- **Terraform**: Version >= 1.0
- **AWS CLI**: Configured with credentials and default region
- **Git**: For version control

### Required AWS Permissions

The deploying user/role needs permissions for:
- VPC, subnets, security groups, route tables
- ECS clusters, services, task definitions
- IAM roles and policies
- RDS instances, ElastiCache clusters
- MSK clusters, CloudWatch logs
- Secrets Manager, KMS

## Quick Start

### 1. Clone Repository
```bash
git clone <repository-url>
cd terraform-aws-ecs-microservices
```

### 2. Configure Environment
```bash
# For staging
cp envs/staging.tfvars terraform.tfvars

# For production
cp envs/prod.tfvars terraform.tfvars
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan Deployment
```bash
terraform plan -var-file=envs/staging.tfvars
```

### 5. Deploy Infrastructure
```bash
terraform apply -var-file=envs/staging.tfvars
```

## Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `name` | Project name prefix | `microservices` |
| `environment` | Deployment environment | `staging`, `prod` |
| `region` | AWS region | `us-east-1` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `azs` | Availability zones | `["us-east-1a", "us-east-1b", "us-east-1c"]` |
| `db_name` | PostgreSQL database name | `microservicesdb` |
| `db_username` | Database master username | `admin` |
| `msk_log_group` | CloudWatch log group for MSK | `/microservices/msk` |

### Service Configuration

Services are defined in the ECS module with the following structure:
```hcl
services = {
  "api-gateway" = {
    image          = "nginx:latest"
    container_port = 80
    cpu            = 256
    memory         = 512
    desired_count  = 2
    autoscaling    = {
      min = 1
      max = 10
    }
    env     = []
    secrets = []
  }
}
```

## Module Structure

```
modules/
├── vpc/          # Network infrastructure
├── security/     # Security groups and rules
├── iam/          # IAM roles and policies
├── ecs/          # Container orchestration
├── rds/          # PostgreSQL database
├── redis/        # Redis cache
└── msk/          # Managed Kafka
```

## Security Features

- **Network Isolation**: Private subnets for all application components
- **Security Groups**: Least-privilege access control
- **IAM Roles**: Minimal required permissions for tasks
- **Encryption**: Data encrypted at rest and in transit
- **Secrets Management**: Secure credential storage
- **VPC Endpoints**: Private access to AWS services

## Monitoring & Logging

- **CloudWatch Metrics**: Infrastructure and application metrics
- **CloudWatch Logs**: Centralized logging for all services
- **ALB Access Logs**: Request-level logging
- **Health Checks**: Automated health monitoring
- **Alerts**: Configurable alerts for critical events

## Cost Optimization

- **Auto-scaling**: Scale resources based on demand
- **Reserved Instances**: Plan for production workloads
- **VPC Endpoints**: Reduce data transfer costs
- **Right-sizing**: Monitor and adjust resource allocations
- **Spot Instances**: Consider for non-critical workloads

## Troubleshooting

### Common Issues

1. **Security Group Conflicts**: Check inbound/outbound rules
2. **IAM Permission Errors**: Verify role policies
3. **Resource Limits**: Check service limits and quotas
4. **Network Connectivity**: Verify route tables and security groups

### Debug Commands

```bash
# Check Terraform state
terraform state list

# View resource details
terraform state show aws_ecs_cluster.this

# Validate configuration
terraform validate

# Refresh state
terraform refresh
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes with proper documentation
4. Test thoroughly in staging environment
5. Submit pull request with detailed description

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the CODEBASE_EXPLANATION.md for detailed technical documentation
- Review AWS documentation for service-specific guidance

---

**Note**: This infrastructure is designed for microservices architectures. For monolithic applications, consider simplifying the setup by removing MSK and adjusting scaling configurations.
