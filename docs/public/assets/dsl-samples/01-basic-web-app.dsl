workspace "Azure Basic Web Application" "Structurizr interpretation of the Azure Architecture Center basic App Service web application." {

  properties {
    "semantic-zoom" "false"
    "shape.pack" "basic-a"
  }

  model {
    customer = person "Customer" {
      description "Uses the web application."
      tags "External" "Microsoft Azure - Users"
    }
    operator = person "Operations Engineer" {
      description "Operates and supports the workload."
      tags "_el.operator"
    }
    entra = softwareSystem "Microsoft Entra ID" {
      description "Authenticates users and issues tokens."
      tags "Azure" "Security" "Microsoft Azure - Azure Active Directory"
    }
    monitor = softwareSystem "Azure Monitor" {
      description "Central monitoring, alerting, and dashboards."
      tags "Azure" "Observability" "Microsoft Azure - Monitor"
    }
    webSystem = softwareSystem "Customer Web Application" {
      description "Single-region web application hosted on Azure App Service."
      tags "Microsoft Azure - App Services"
      web = container "Web Application" {
        description "Serves the user interface and application endpoints."
        technology "ASP.NET Core on Azure App Service"
        tags "Azure" "Microsoft Azure - App Services"
      }
      database = container "Application Database" {
        description "Stores application and customer data."
        technology "Azure SQL Database"
        tags "Azure" "Database" "Data" "Microsoft Azure - SQL Database"
      }
      keyVault = container "Secrets Store" {
        description "Stores secrets, certificates, and keys."
        technology "Azure Key Vault"
        tags "Azure" "Security" "Microsoft Azure - Key Vaults"
      }
      appInsights = container "Application Telemetry" {
        description "Collects traces, requests, dependencies, and exceptions."
        technology "Application Insights"
        tags "Azure" "Observability" "Microsoft Azure - Metrics"
      }
      web -> database "Reads from and writes to" "TDS/TLS"
      web -> keyVault "Retrieves secrets and certificates from" "HTTPS"
      web -> appInsights "Emits application telemetry to" "HTTPS"
    }
    production = deploymentEnvironment "Production" {
      microsoft_azure = deploymentNode "Microsoft Azure" "Azure cloud platform." "Azure" {
        primary_region = deploymentNode "Primary Region" "Single Azure region." "Azure Region" {
          app_service_plan = deploymentNode "App Service Plan" "Managed compute plan." "Azure App Service" {
            webInstance = containerInstance web
          }
          azure_sql_logical_server = deploymentNode "Azure SQL Logical Server" "Managed relational database service." "Azure SQL" {
            databaseInstance = containerInstance database
          }
          key_vault = deploymentNode "Key Vault" "Managed secrets service." "Azure Key Vault" {
            keyVaultInstance = containerInstance keyVault
          }
          application_insights_resource = deploymentNode "Application Insights Resource" "Application performance monitoring." "Application Insights" {
            appInsightsInstance = containerInstance appInsights
          }
        }
      }
    }
    customer -> web "Uses" "HTTPS"
    entra -> web "Returns identity tokens to" "OIDC"
    web -> customer "Returns application responses to" "HTTPS"
    web -> entra "Authenticates users with" "OpenID Connect/OAuth 2.0"
    appInsights -> monitor "Publishes telemetry and alerts to" "Azure Monitor pipeline"
    operator -> monitor "Reviews health, logs, and alerts in" "HTTPS"
  }

  views {
    themes "https://static.structurizr.com/themes/microsoft-azure-2023.01.24/theme.json"
    systemLandscape "Landscape" "Azure basic web application landscape" {
      include *
      autoLayout lr
      properties {
        "layoutEngine" "graphviz"
        "layoutEngine.graphviz.nodesep" "2.546717175261018"
        "layoutEngine.graphviz.ranksep" "3.58857180873323"
      }
    }
    systemContext webSystem "SystemContext" {
      include *
      autoLayout lr
    }
    container webSystem "Containers" {
      include *
      autoLayout lr
    }
    dynamic webSystem "SignInAndLoad" "Customer signs in and loads application data" {
      customer -> web "1. Requests the application"
      web -> entra "2. Redirects for authentication"
      entra -> web "3. Returns an identity token"
      web -> keyVault "4. Retrieves runtime secrets"
      web -> database "5. Loads customer data"
      web -> customer "6. Returns the rendered experience"
      autoLayout lr
    }
    deployment webSystem "Production" "Production" "Production deployment in a single Azure region" {
      include *
      autoLayout lr
    }
    styles {
      element "_el.operator" {
        color #df9745
        stroke #df9745
      }
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
