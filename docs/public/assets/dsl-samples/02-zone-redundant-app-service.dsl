workspace "Azure Zone-Redundant App Service" "Network-secured and highly available App Service baseline architecture." {

  properties {
    "semantic-zoom" "false"
  }

  model {
    user = person "Internet User" {
      description "Uses the public web application."
      tags "External" "_el.user"
    }
    admin = person "Platform Operator" {
      description "Operates the production workload."
      tags "_el.admin"
    }
    entra = softwareSystem "Microsoft Entra ID" {
      description "Provides workforce and application identity."
      tags "Azure" "Security" "Microsoft Azure - Azure Active Directory"
    }
    dns = softwareSystem "Azure DNS" {
      description "Resolves the public application hostname."
      tags "Azure" "Microsoft Azure - DNS Private Resolver"
    }
    monitor = softwareSystem "Azure Monitor" {
      description "Aggregates platform and application telemetry."
      tags "Azure" "Observability" "Microsoft Azure - Monitor"
    }
    system = softwareSystem "Highly Available Web Platform" {
      description "Zone-redundant, network-isolated web application."
      tags "Microsoft Azure - Availability Sets"
      frontDoor = container "Global Edge" {
        description "Terminates public traffic, applies WAF policies, and routes to the region."
        technology "Azure Front Door Premium with WAF"
        tags "Azure" "Security" "Edge" "Microsoft Azure - Front Door and CDN Profiles"
      }
      app = container "Web Application" {
        description "Runs the business application across availability zones."
        technology "Azure App Service Premium v3"
        tags "Azure" "Microsoft Azure - App Services"
      }
      sql = container "Operational Database" {
        description "Stores transactional data with zone redundancy."
        technology "Azure SQL Database"
        tags "Azure" "Database" "Data" "Microsoft Azure - SQL Database"
      }
      kv = container "Secrets and Certificates" {
        description "Stores application secrets and certificates."
        technology "Azure Key Vault"
        tags "Azure" "Security" "Microsoft Azure - Key Vaults"
      }
      privateDns = container "Private DNS Zones" {
        description "Resolves private endpoints inside the workload network."
        technology "Azure Private DNS"
        tags "Microsoft Azure - DNS Private Resolver"
      }
      insights = container "Application Insights" {
        description "Collects distributed traces and application metrics."
        technology "Application Insights"
        tags "Azure" "Observability" "Microsoft Azure - Application Insights"
      }
      frontDoor -> app "Routes inspected traffic to" "HTTPS"
      app -> sql "Reads and writes through a private endpoint" "TDS/TLS"
      app -> kv "Retrieves secrets through a private endpoint" "HTTPS"
      app -> privateDns "Resolves private service endpoints with" "DNS"
      app -> insights "Emits traces and metrics to" "HTTPS"
    }
    production = deploymentEnvironment "Production" {
      azure_global_edge = deploymentNode "Azure Global Edge" "Globally distributed edge network." "Azure" {
        front_door_profile = deploymentNode "Front Door Profile" "Premium edge and WAF." "Azure Front Door" {
          frontDoorInstance = containerInstance frontDoor
        }
      }
      azure_primary_region = deploymentNode "Azure Primary Region" "Production region with availability zones." "Azure Region" {
        workload_virtual_network = deploymentNode "Workload Virtual Network" "Network boundary for private workload connectivity." "Azure Virtual Network" "Microsoft Azure - Virtual Networks" {
          integration_subnet = deploymentNode "Integration Subnet" "Delegated App Service virtual network integration subnet." "Azure Subnet" "Microsoft Azure - Subnet" {
            zone_redundant_app_service_plan = deploymentNode "Zone-Redundant App Service Plan" "Workers distributed across availability zones." "Azure App Service" "Microsoft Azure - App Service Plans" {
              appInstance = containerInstance app {
                tags "Microsoft Azure - App Services"
              }
            }
          }
          private_endpoint_subnet = deploymentNode "Private Endpoint Subnet" "Private endpoints for PaaS services." "Azure Subnet" "Microsoft Azure - Subnet" {
            sql_private_endpoint = deploymentNode "SQL Private Endpoint" "Private database endpoint." "Private Endpoint" "Microsoft Azure - Private Endpoints" {
              sqlInstance = containerInstance sql {
                tags "Microsoft Azure - SQL Database"
              }
            }
            key_vault_private_endpoint = deploymentNode "Key Vault Private Endpoint" "Private vault endpoint." "Private Endpoint" "Microsoft Azure - Private Endpoints" {
              kvInstance = containerInstance kv
            }
          }
        }
        private_dns = deploymentNode "Private DNS" "Private name resolution." "Azure Private DNS" {
          privateDnsInstance = containerInstance privateDns
        }
        monitoring = deploymentNode "Monitoring" "Regional application telemetry." "Azure Monitor" "Microsoft Azure - Monitor" {
          insightsInstance = containerInstance insights
        }
      }
    }
    user -> dns "Resolves application hostname with" "DNS"
    dns -> frontDoor "Returns the global edge endpoint for"
    user -> frontDoor "Uses" "HTTPS"
    app -> user "Returns application responses to" "HTTPS"
    app -> entra "Validates identities and obtains tokens from" "OAuth 2.0"
    insights -> monitor "Forwards telemetry to"
    admin -> monitor "Reviews dashboards and alerts in" "HTTPS"
  }

  views {
    themes "https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json"
    systemLandscape "Landscape" "Enterprise landscape for the zone-redundant web platform" {
      include *
      autoLayout lr
    }
    systemContext system "SystemContext" {
      include *
      autoLayout lr
    }
    container system "Containers" {
      include *
      autoLayout lr
    }
    dynamic system "PublicRequest" "Zone-redundant public request path" {
      user -> dns "1. Resolves the application hostname"
      dns -> frontDoor "2. Resolves to Azure Front Door"
      user -> frontDoor "3. Sends an HTTPS request"
      frontDoor -> app "4. Applies WAF policy and routes the request"
      app -> sql "5. Reads or updates application data"
      app -> user "6. Returns the response through Front Door"
      autoLayout lr
    }
    dynamic system "SecretAccess" "Application retrieves a secret without public network access" {
      app -> privateDns "1. Resolves the Key Vault private endpoint"
      app -> entra "2. Obtains a managed identity token"
      app -> kv "3. Retrieves the authorized secret"
      autoLayout lr
    }
    deployment system "Production" "Production" "Production network and availability-zone deployment" {
      include *
      autoLayout lr
      title "Production"
      properties {
        "compactMode" "true"
      }
    }
    systemLandscape "system-landscape-4045-d" {
      include *
      autoLayout lr
      title "System Landscape"
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
      element "_el.user" {
        stroke #6fc677
        color #6fc677
      }
      element "_el.admin" {
        stroke #df9745
        color #df9745
      }
      relationship "Relationship" {
        thickness "2"
        color "#707070"
        routing "orthogonal"
        fontSize "18"
      }
      relationship "Asynchronous" {
        color "#8e44ad"
        dashed true
      }
    }
  }

}
