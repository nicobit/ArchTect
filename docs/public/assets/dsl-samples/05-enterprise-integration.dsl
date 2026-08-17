workspace "Azure Enterprise Integration" "Enterprise integration architecture using Azure Integration Services." {

    !identifiers hierarchical

    model {
        consumer = person "API Consumer" {
            description "Invokes enterprise business capabilities."
            tags "External"
        }
        integrationOps = person "Integration Operator" {
            description "Operates APIs, workflows, and messages."
        }
        crm = softwareSystem "CRM SaaS" {
            description "External customer relationship management platform."
            tags "External"
        }
        erp = softwareSystem "On-Premises ERP" {
            description "Existing enterprise resource planning system."
            tags "External"
        }
        partner = softwareSystem "Business Partner API" {
            description "External partner service."
            tags "External"
        }
        monitor = softwareSystem "Azure Monitor" {
            description "Central observability and alerting."
            tags "Azure,Observability"
        }

        integration = softwareSystem "Enterprise Integration Platform" {
            description "API-led and message-driven integration platform."
            apim = container "API Gateway" {
                description "Secures, publishes, throttles, and observes enterprise APIs."
                technology "Azure API Management"
                tags "Azure,Security"
            }
            workflow = container "Business Workflow" {
                description "Orchestrates long-running integration processes."
                technology "Azure Logic Apps Standard"
                tags "Azure"
            }
            functions = container "Integration Functions" {
                description "Performs custom validation and transformation."
                technology "Azure Functions"
                tags "Azure"
            }
            bus = container "Enterprise Message Bus" {
                description "Provides reliable queues and topics."
                technology "Azure Service Bus Premium"
                tags "Azure,Queue"
            }
            eventGrid = container "Integration Events" {
                description "Routes discrete integration events to subscribers."
                technology "Azure Event Grid"
                tags "Azure,Queue"
            }
            dataFactory = container "Batch Data Integration" {
                description "Moves and transforms scheduled data sets."
                technology "Azure Data Factory"
                tags "Azure,Data"
            }
            storage = container "Integration Storage" {
                description "Stores payloads, files, and claim-check content."
                technology "Azure Storage"
                tags "Azure,Database,Data"
            }
            kv = container "Integration Secrets" {
                description "Stores certificates, secrets, and connection metadata."
                technology "Azure Key Vault"
                tags "Azure,Security"
            }
            insights = container "Integration Telemetry" {
                description "Collects workflow and API telemetry."
                technology "Application Insights / Log Analytics"
                tags "Azure,Observability"
            }
        }

        consumer -> apim "Invokes enterprise APIs" "HTTPS/JSON"
workflow -> consumer "Returns orchestrated API responses to" "HTTPS/JSON"
functions -> bus "Publishes validated work items to" "AMQP" "Asynchronous"
        apim -> workflow "Starts managed business workflows" "HTTPS"
        apim -> functions "Invokes custom API logic" "HTTPS"
        workflow -> crm "Calls CRM connectors and APIs" "HTTPS"
        workflow -> erp "Calls ERP services through hybrid connectivity" "HTTPS/SOAP"
        workflow -> partner "Calls partner APIs" "HTTPS"
        workflow -> bus "Publishes commands and work items" "AMQP" "Asynchronous"
        bus -> workflow "Triggers message-driven workflows" "AMQP" "Asynchronous"
        workflow -> eventGrid "Publishes business events" "HTTPS" "Asynchronous"
        eventGrid -> functions "Triggers event handlers" "HTTPS" "Asynchronous"
        functions -> storage "Stores or retrieves large payloads"
        dataFactory -> crm "Extracts scheduled data from"
        dataFactory -> storage "Stages batch data in"
        workflow -> kv "Retrieves secrets and certificates from"
        apim -> kv "Retrieves policy secrets from"
        apim -> insights "Emits API telemetry to"
        workflow -> insights "Emits workflow telemetry to"
        functions -> insights "Emits function telemetry to"
        insights -> monitor "Forwards logs, traces, and metrics to"
        integrationOps -> monitor "Reviews dashboards and alerts in"

        deploymentEnvironment "Production" {
            deploymentNode "Azure Integration Subscription" {
                description "Production integration subscription."
                technology "Azure Subscription"
                deploymentNode "Integration Virtual Network" {
                    description "Private integration network."
                    technology "Azure Virtual Network"
                    deploymentNode "API Management Subnet" {
                        description "Internal API gateway subnet."
                        technology "Azure Subnet"
                        apimInstance = containerInstance apim {
                        }
                    }
                    deploymentNode "Logic Apps Integration Subnet" {
                        description "Workflow runtime integration subnet."
                        technology "Azure Subnet"
                        workflowInstance = containerInstance workflow {
                        }
                    }
                    deploymentNode "Functions Integration Subnet" {
                        description "Function runtime integration subnet."
                        technology "Azure Subnet"
                        functionsInstance = containerInstance functions {
                        }
                    }
                    deploymentNode "Private Endpoint Subnet" {
                        description "Private PaaS endpoints."
                        technology "Azure Subnet"
                        busInstance = containerInstance bus {
                        }
                        eventGridInstance = containerInstance eventGrid {
                        }
                        storageInstance = containerInstance storage {
                        }
                        kvInstance = containerInstance kv {
                        }
                    }
                }
                deploymentNode "Managed Data Integration" {
                    description "Data movement service."
                    technology "Azure Data Factory"
                    dataFactoryInstance = containerInstance dataFactory {
                    }
                }
                deploymentNode "Monitoring Workspace" {
                    description "Central integration monitoring."
                    technology "Azure Monitor"
                    insightsInstance = containerInstance insights {
                    }
                }
            }
        }
    }

    views {
        systemLandscape "Landscape" "Enterprise systems connected by Azure Integration Services" {
            include *
            autoLayout lr 350 300
        }
        systemContext integration "SystemContext" "Context of the enterprise integration platform" {
            include *
            autoLayout lr 300 250
        }
        container integration "Containers" "API, workflow, messaging, events, batch, and observability services" {
            include *
            autoLayout lr 300 250
        }
        dynamic integration "SynchronousOrderQuery" "Consumer performs an orchestrated ERP query" {
            consumer -> apim "1. Calls the enterprise order API"
            apim -> workflow "2. Starts the order query workflow"
            workflow -> erp "3. Retrieves order information"
            workflow -> consumer "4. Returns the normalized response through API Management"
            autoLayout lr
        }
        dynamic integration "AsynchronousOrderProcessing" "Consumer submits an order for reliable asynchronous processing" {
            consumer -> apim "1. Submits an order"
            apim -> functions "2. Validates and normalizes the payload"
            functions -> storage "3. Stores the large payload"
            functions -> bus "4. Publishes a claim-check work item"
            bus -> workflow "5. Triggers the processing workflow"
            workflow -> erp "6. Creates the order"
            workflow -> eventGrid "7. Publishes OrderCreated"
            eventGrid -> functions "8. Triggers downstream processing"
            autoLayout lr
        }
        deployment integration "Production" "Production Azure Integration Services deployment" {
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
