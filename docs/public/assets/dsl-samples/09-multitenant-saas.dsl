workspace "Azure Multitenant SaaS Deployment Stamps" "Multitenant SaaS architecture with a control plane and regional deployment stamps." {

    !identifiers hierarchical

    model {
        tenantAdmin = person "Tenant Administrator" {
            description "Onboards and configures a customer tenant."
            tags "External"
        }
        tenantUser = person "Tenant User" {
            description "Uses the SaaS application."
            tags "External"
        }
        saasOps = person "SaaS Operator" {
            description "Operates tenants, stamps, and platform health."
        }
        entraExternal = softwareSystem "Microsoft Entra External ID" {
            description "Authenticates tenant users."
            tags "Azure,Security"
        }
        billing = softwareSystem "Billing Provider" {
            description "Processes subscriptions and usage charges."
            tags "External"
        }
        monitor = softwareSystem "Azure Monitor" {
            description "Aggregates platform and tenant telemetry."
            tags "Azure,Observability"
        }

        saas = softwareSystem "Multitenant SaaS Platform" {
            description "Global SaaS platform using a control plane and deployment stamps."
            edge = container "Global Entry Point" {
                description "Routes tenant traffic to the correct regional stamp."
                technology "Azure Front Door with WAF"
                tags "Azure,Edge,Security"
            }
            portal = container "Tenant Administration Portal" {
                description "Supports signup, configuration, and tenant administration."
                technology "Azure App Service"
                tags "Azure"
            }
            controlApi = container "Control Plane API" {
                description "Manages tenant lifecycle, placement, configuration, and operations."
                technology "Azure App Service / Container Apps"
                tags "Azure"
            }
            catalog = container "Tenant Catalog" {
                description "Maps tenant identities to configuration, plan, and deployment stamp."
                technology "Azure Cosmos DB"
                tags "Azure,Database,Data"
            }
            provisioner = container "Stamp and Tenant Provisioner" {
                description "Deploys infrastructure and configures tenants."
                technology "Azure Functions / Durable Functions"
                tags "Azure"
            }
            config = container "Tenant Configuration Store" {
                description "Stores per-tenant configuration and feature flags."
                technology "Azure App Configuration"
                tags "Azure,Database,Data"
            }
            stampApi = container "Regional Application API" {
                description "Serves tenant business requests within a deployment stamp."
                technology "Azure Container Apps / AKS"
                tags "Azure"
            }
            stampWorker = container "Regional Background Worker" {
                description "Processes asynchronous tenant work."
                technology "Azure Container Apps / AKS"
                tags "Azure"
            }
            stampBus = container "Regional Message Bus" {
                description "Isolates asynchronous workload processing per stamp."
                technology "Azure Service Bus"
                tags "Azure,Queue"
            }
            sharedDb = container "Shared Tenant Database" {
                description "Stores partitioned data for standard tenants."
                technology "Azure SQL Database / Cosmos DB"
                tags "Azure,Database,Data"
            }
            dedicatedDb = container "Dedicated Tenant Database" {
                description "Provides stronger isolation for selected tenants."
                technology "Azure SQL Database"
                tags "Azure,Database,Data"
            }
            usage = container "Usage Metering" {
                description "Aggregates tenant usage for limits and billing."
                technology "Azure Functions / Data Explorer"
                tags "Azure,Data"
            }
            telemetry = container "SaaS Telemetry" {
                description "Collects stamp, tenant, and control-plane telemetry."
                technology "Application Insights / Log Analytics"
                tags "Azure,Observability"
            }
        }

        tenantAdmin -> portal "Signs up and configures a tenant through" "HTTPS"
        portal -> entraExternal "Authenticates tenant administrators with" "OIDC"
        portal -> controlApi "Invokes tenant lifecycle operations" "HTTPS"
controlApi -> tenantAdmin "Returns tenant lifecycle status to" "HTTPS"
stampApi -> tenantUser "Returns tenant application responses to" "HTTPS"
        controlApi -> catalog "Creates and reads tenant records in"
        controlApi -> provisioner "Starts provisioning workflows in"
        provisioner -> catalog "Updates tenant placement and status in"
        provisioner -> config "Creates tenant configuration in"
        controlApi -> billing "Creates and updates subscriptions in" "HTTPS"
        tenantUser -> edge "Uses the SaaS application" "HTTPS"
        edge -> catalog "Resolves tenant-to-stamp routing through" "HTTPS"
        edge -> stampApi "Routes the request to the assigned stamp" "HTTPS"
        stampApi -> entraExternal "Validates tenant user tokens with" "OIDC"
        stampApi -> config "Loads tenant configuration from"
        stampApi -> sharedDb "Reads and writes standard tenant data in"
        stampApi -> dedicatedDb "Reads and writes isolated tenant data in"
        stampApi -> stampBus "Publishes background work to" "AMQP" "Asynchronous"
        stampBus -> stampWorker "Delivers tenant work to" "AMQP" "Asynchronous"
        stampWorker -> sharedDb "Updates tenant data in"
        stampWorker -> usage "Publishes metering events to"
        usage -> billing "Reports billable usage to" "HTTPS"
        controlApi -> telemetry "Emits control-plane telemetry to"
        stampApi -> telemetry "Emits tenant and stamp telemetry to"
        stampWorker -> telemetry "Emits workload telemetry to"
        telemetry -> monitor "Exports dashboards and alerts to"
        saasOps -> monitor "Operates the SaaS platform with"

        deploymentEnvironment "Production" {
            deploymentNode "Azure Global Services" {
                description "Global entry and identity services."
                technology "Azure"
                edgeInstance = containerInstance edge {
                }
            }
            deploymentNode "Control Plane Subscription" {
                description "Central SaaS management plane."
                technology "Azure Subscription"
                deploymentNode "Control Plane Region" {
                    description "Primary management region."
                    technology "Azure Region"
                    portalInstance = containerInstance portal {
                    }
                    controlApiInstance = containerInstance controlApi {
                    }
                    catalogInstance = containerInstance catalog {
                    }
                    provisionerInstance = containerInstance provisioner {
                    }
                    configInstance = containerInstance config {
                    }
                    usageInstance = containerInstance usage {
                    }
                    telemetryInstance = containerInstance telemetry {
                    }
                }
            }
            deploymentNode "Deployment Stamp A" {
                description "Regional scale unit for a set of tenants."
                technology "Azure Subscription / Resource Group"
                deploymentNode "Region A" {
                    description "Regional workload resources."
                    technology "Azure Region"
                    stampApiInstance = containerInstance stampApi {
                    }
                    stampWorkerInstance = containerInstance stampWorker {
                    }
                    stampBusInstance = containerInstance stampBus {
                    }
                    sharedDbInstance = containerInstance sharedDb {
                    }
                    dedicatedDbInstance = containerInstance dedicatedDb {
                    }
                }
            }
            deploymentNode "Deployment Stamp B" {
                description "Second independent regional scale unit."
                technology "Azure Subscription / Resource Group"
                deploymentNode "Region B" {
                    description "Regional workload resources."
                    technology "Azure Region"
                    stampApiInstance2 = containerInstance stampApi {
                    }
                    stampWorkerInstance2 = containerInstance stampWorker {
                    }
                    stampBusInstance2 = containerInstance stampBus {
                    }
                    sharedDbInstance2 = containerInstance sharedDb {
                    }
                    dedicatedDbInstance2 = containerInstance dedicatedDb {
                    }
                }
            }
        }
    }

    views {
        systemLandscape "Landscape" "Tenants, identity, billing, operations, and the SaaS platform" {
            include *
            autoLayout lr 350 300
        }
        systemContext saas "SystemContext" "Context of the multitenant SaaS platform" {
            include *
            autoLayout lr 300 250
        }
        container saas "Containers" "Control plane, global routing, deployment stamp, data, and telemetry" {
            include *
            autoLayout lr 300 250
        }
        dynamic saas "TenantOnboarding" "Tenant administrator onboards a new SaaS tenant" {
            tenantAdmin -> portal "1. Submits signup and plan information"
            portal -> controlApi "2. Requests tenant creation"
            controlApi -> billing "3. Creates the subscription"
            controlApi -> catalog "4. Creates a pending tenant record"
            controlApi -> provisioner "5. Starts provisioning"
            provisioner -> config "6. Creates tenant configuration"
            provisioner -> catalog "7. Assigns a deployment stamp and activates the tenant"
            controlApi -> tenantAdmin "8. Confirms tenant readiness through the portal"
            autoLayout lr
        }
        dynamic saas "TenantRequest" "Tenant request is routed to the correct deployment stamp" {
            tenantUser -> edge "1. Sends an authenticated request"
            edge -> catalog "2. Resolves tenant placement"
            edge -> stampApi "3. Routes to the assigned regional stamp"
            stampApi -> config "4. Loads tenant-specific configuration"
            stampApi -> sharedDb "5. Accesses partitioned tenant data"
            stampApi -> tenantUser "6. Returns the response through the global edge"
            autoLayout lr
        }
        deployment saas "Production" "Global control plane and two regional deployment stamps" {
            include *
            autoLayout lr 300 250
        }

        styles {
            element "Element" {
                color #ffffff
                fontSize 22
            }
            element "Person" {
                shape person
                background #08427b
            }
            element "Software System" {
                background #1168bd
            }
            element "Container" {
                background #438dd5
            }
            element "Database" {
                shape cylinder
                background #2e73b8
            }
            element "Queue" {
                shape pipe
                background #6b5b95
            }
            element "Azure" {
                background #0078d4
                stroke #005a9e
            }
            element "External" {
                background #666666
            }
            element "Security" {
                background #8b1a1a
            }
            element "Observability" {
                background #5c2d91
            }
            element "Data" {
                background #00796b
            }
            element "Edge" {
                background #ca5010
            }
            relationship "Relationship" {
                color #707070
                thickness 2
                routing orthogonal
                fontSize 18
            }
            relationship "Asynchronous" {
                dashed true
                color #8e44ad
            }
        }
    }

}
