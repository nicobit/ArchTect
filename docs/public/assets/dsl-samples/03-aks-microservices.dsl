workspace "Azure AKS Microservices" "Microservices application deployed to Azure Kubernetes Service." {

  model {
    customer = person "Delivery Customer" {
      description "Creates and tracks drone delivery orders."
      tags "External"
    }
    operator = person "Platform Engineer" {
      description "Operates the AKS platform."
    }
    entra = softwareSystem "Microsoft Entra ID" {
      description "Provides identities for users and workloads."
      tags "Azure" "Security" "Microsoft Azure - Identity Governance"
    }
    acr = softwareSystem "Azure Container Registry" {
      description "Stores signed application container images."
      tags "Azure" "Microsoft Azure - Container Registries"
    }
    monitor = softwareSystem "Azure Monitor" {
      description "Provides logs, metrics, traces, dashboards, and alerts."
      tags "Azure" "Observability" "Microsoft Azure - Monitor"
    }
    platform = softwareSystem "Drone Delivery Platform" {
      description "Reference microservices workload running on AKS."
      gateway = container "API Gateway" {
        description "Provides a single API entry point and routes requests."
        technology "Ingress Controller / Gateway API"
        tags "Azure" "Security" "Microsoft Azure - Application Gateways"
      }
      delivery = container "Delivery Service" {
        description "Owns delivery lifecycle and status."
        technology "Microservice"
        tags "Microsoft Azure - Kubernetes Services"
      }
      drone = container "Drone Scheduler Service" {
        description "Selects and schedules drones."
        technology "Microservice"
        tags "Microsoft Azure - Kubernetes Services"
      }
      package = container "Package Service" {
        description "Manages package information and constraints."
        technology "Microservice"
        tags "Microsoft Azure - Kubernetes Services"
      }
      notification = container "Notification Worker" {
        description "Sends delivery status notifications."
        technology "Background worker"
        tags "Microsoft Azure - Worker Container App"
      }
      bus = container "Domain Event Bus" {
        description "Distributes commands and domain events."
        technology "Azure Service Bus"
        tags "Azure" "Queue" "Microsoft Azure - Azure Service Bus"
      }
      deliveryDb = container "Delivery Database" {
        description "Stores delivery aggregates."
        technology "Azure Cosmos DB"
        tags "Azure" "Database" "Data" "Microsoft Azure - Azure Cosmos DB"
      }
      droneDb = container "Drone Database" {
        description "Stores drone state and availability."
        technology "Azure Cosmos DB"
        tags "Azure" "Database" "Data" "Microsoft Azure - Azure Cosmos DB"
      }
      packageDb = container "Package Database" {
        description "Stores package data."
        technology "Azure SQL Database"
        tags "Azure" "Database" "Data" "Microsoft Azure - SQL Database"
      }
      kv = container "Secrets Store" {
        description "Stores secrets and certificates."
        technology "Azure Key Vault"
        tags "Azure" "Security" "Microsoft Azure - Key Vaults"
      }
      telemetry = container "Workload Telemetry" {
        description "Collects logs, metrics, and traces."
        technology "Application Insights / Managed Prometheus"
        tags "Azure" "Observability" "Microsoft Azure - Application Insights"
      }
      gateway -> delivery "Routes delivery requests to" "HTTPS"
      gateway -> package "Routes package queries to" "HTTPS"
      delivery -> deliveryDb "Reads and writes"
      drone -> droneDb "Reads and writes"
      package -> packageDb "Reads and writes"
      delivery -> bus "Publishes DeliveryCreated events to" "AMQP" {
        tags "Asynchronous"
      }
      bus -> drone "Delivers delivery scheduling commands to" "AMQP" {
        tags "Asynchronous"
      }
      drone -> bus "Publishes DroneScheduled events to" "AMQP" {
        tags "Asynchronous"
      }
      bus -> delivery "Delivers delivery status events to" "AMQP" {
        tags "Asynchronous"
      }
      bus -> notification "Delivers notification events to" "AMQP" {
        tags "Asynchronous"
      }
      gateway -> kv "Retrieves certificates from" "HTTPS"
      delivery -> kv "Retrieves secrets from" "HTTPS"
      drone -> kv "Retrieves secrets from" "HTTPS"
      package -> kv "Retrieves secrets from" "HTTPS"
      gateway -> telemetry "Emits telemetry to"
      delivery -> telemetry "Emits telemetry to"
      drone -> telemetry "Emits telemetry to"
      package -> telemetry "Emits telemetry to"
      notification -> telemetry "Emits telemetry to"
    }
    production = deploymentEnvironment "Production" {
      azure_primary_region = deploymentNode "Azure Primary Region" "Primary production region." "Azure Region" {
        hub_virtual_network = deploymentNode "Hub Virtual Network" "Shared connectivity and security services." "Azure Virtual Network" {
          azure_firewall_subnet = deploymentNode "Azure Firewall Subnet" "Central egress and inspection." "Azure Subnet" {
            azure_firewall = infrastructureNode "Azure Firewall" "Controls ingress and egress." "Azure Firewall" {
            }
          }
        }
        aks_spoke_virtual_network = deploymentNode "AKS Spoke Virtual Network" "Workload network." "Azure Virtual Network" {
          application_gateway_subnet = deploymentNode "Application Gateway Subnet" "Ingress subnet." "Azure Subnet" {
            application_gateway_waf = deploymentNode "Application Gateway WAF" "Regional ingress." "Application Gateway" {
              gatewayInstance = containerInstance gateway
            }
          }
          aks_node_subnet = deploymentNode "AKS Node Subnet" "Private AKS nodes." "Azure Subnet" {
            aks_cluster = deploymentNode "AKS Cluster" "Private Kubernetes cluster." "Azure Kubernetes Service" {
              system_node_pool = deploymentNode "System Node Pool" "Hosts cluster system pods." "Kubernetes node pool" {
              }
              user_node_pool = deploymentNode "User Node Pool" "Hosts application workloads." "Kubernetes node pool" {
                deliveryInstance = containerInstance delivery droneInstance
                containerInstance drone packageInstance
                containerInstance package notificationInstance
                containerInstance notification
              }
            }
          }
          private_endpoint_subnet = deploymentNode "Private Endpoint Subnet" "Private access to managed dependencies." "Azure Subnet" {
            deliveryDbInstance = containerInstance deliveryDb droneDbInstance
            containerInstance droneDb packageDbInstance
            containerInstance packageDb busInstance
            containerInstance bus kvInstance
            containerInstance kv acrInstance
            softwareSystemInstance acr
          }
        }
        monitoring_services = deploymentNode "Monitoring Services" "Managed monitoring plane." "Azure Monitor" {
          telemetryInstance = containerInstance telemetry
        }
      }
    }
    customer -> gateway "Uses delivery APIs" "HTTPS/JSON"
    package -> customer "Returns package details to" "HTTPS/JSON"
    gateway -> entra "Validates customer identities with" "OIDC"
    telemetry -> monitor "Exports workload telemetry to"
    operator -> monitor "Observes the platform through"
    acr -> gateway "Supplies container image for"
    acr -> delivery "Supplies container image for"
    acr -> drone "Supplies container image for"
    acr -> package "Supplies container image for"
    acr -> notification "Supplies container image for"
  }

  views {
    themes "https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json"
    systemLandscape "Landscape" "AKS microservices ecosystem" {
      include *
      autoLayout lr
    }
    systemContext platform "SystemContext" {
      include *
      autoLayout lr
    }
    container platform "Containers" {
      include *
      autoLayout lr
    }
    dynamic platform "CreateDelivery" "Create and schedule a drone delivery" {
      customer -> gateway "1. Submits a delivery request"
      gateway -> delivery "2. Routes the validated request"
      delivery -> deliveryDb "3. Stores the delivery"
      delivery -> bus "4. Publishes DeliveryCreated"
      bus -> drone "5. Delivers the scheduling command"
      drone -> droneDb "6. Reserves an available drone"
      drone -> bus "7. Publishes DroneScheduled"
      bus -> delivery "8. Updates delivery status"
      bus -> notification "9. Requests a customer notification"
      autoLayout lr
    }
    dynamic platform "ReadPackage" "Synchronous package lookup" {
      customer -> gateway "1. Requests package details"
      gateway -> package "2. Routes the request"
      package -> packageDb "3. Loads package data"
      package -> customer "4. Returns package details through the gateway"
      autoLayout lr
    }
    deployment platform "Production" "Production" "Private AKS production deployment" {
      include *
      autoLayout tb
      title "Production"
      properties {
        "layoutEngine" "graphviz"
        "layoutEngine.graphviz.clusterExternalMargin" "20"
        "layoutEngine.graphviz.clusterMargin" "70"
        "layoutEngine.graphviz.margin" "0.2"
        "layoutEngine.graphviz.nodesep" "2.4"
        "layoutEngine.graphviz.pad" "0.5"
        "layoutEngine.graphviz.ranksep" "1.8"
        "layoutEngine.graphviz.splines" "ortho"
      }
    }
    styles {
      relationship "Relationship" {
        thickness 2
        color #707070
        routing orthogonal
        fontSize 18
      }
      relationship "Asynchronous" {
        color #8e44ad
        dashed true
      }
    }
  }

}
