workspace "Azure RAG Application" "Retrieval-augmented generation application using Microsoft Foundry, Azure OpenAI, and Azure AI Search." {

    !identifiers hierarchical

    model {
        user = person "Knowledge User" {
            description "Asks questions grounded in enterprise documents."
            tags "External"
        }
        contentOwner = person "Content Owner" {
            description "Publishes approved source documents."
        }
        aiEngineer = person "AI Engineer" {
            description "Evaluates, monitors, and improves the RAG solution."
        }
        entra = softwareSystem "Microsoft Entra ID" {
            description "Authenticates users and workload identities."
            tags "Azure,Security"
        }
        monitor = softwareSystem "Azure Monitor" {
            description "Provides operational monitoring and alerting."
            tags "Azure,Observability"
        }

        rag = softwareSystem "Enterprise RAG Assistant" {
            description "Grounded conversational assistant over enterprise content."
            web = container "Chat Web Application" {
                description "Provides the conversational user experience."
                technology "React on Azure App Service"
                tags "Azure"
            }
            api = container "RAG API" {
                description "Authorizes requests and coordinates the online RAG flow."
                technology "ASP.NET Core / Python on App Service"
                tags "Azure"
            }
            orchestrator = container "RAG Orchestrator" {
                description "Rewrites queries, retrieves context, builds prompts, and applies response policies."
                technology "Microsoft Foundry SDK / Semantic Kernel"
                tags "Azure"
            }
            search = container "Vector and Hybrid Search" {
                description "Indexes and retrieves relevant document chunks."
                technology "Azure AI Search"
                tags "Azure,Database,Data"
            }
            model = container "Chat Model Deployment" {
                description "Generates grounded answers from prompts and context."
                technology "Azure OpenAI / Microsoft Foundry Models"
                tags "Azure"
            }
            embeddings = container "Embedding Model Deployment" {
                description "Creates vector representations for queries and chunks."
                technology "Azure OpenAI Embeddings"
                tags "Azure"
            }
            documents = container "Source Document Store" {
                description "Stores approved source documents."
                technology "Azure Blob Storage"
                tags "Azure,Database,Data"
            }
            ingestion = container "Document Ingestion Pipeline" {
                description "Extracts, chunks, enriches, embeds, and indexes documents."
                technology "Azure Functions / Data Factory"
                tags "Azure,Data"
            }
            safety = container "AI Content Safety" {
                description "Evaluates prompts and outputs for configured safety categories."
                technology "Azure AI Content Safety"
                tags "Azure,Security"
            }
            state = container "Conversation Store" {
                description "Stores conversation metadata and feedback."
                technology "Azure Cosmos DB"
                tags "Azure,Database,Data"
            }
            kv = container "AI Secrets and Configuration" {
                description "Stores secrets, certificates, and protected settings."
                technology "Azure Key Vault"
                tags "Azure,Security"
            }
            telemetry = container "AI Application Telemetry" {
                description "Collects traces, token usage, retrieval metrics, and evaluations."
                technology "Application Insights / Foundry Observability"
                tags "Azure,Observability"
            }
        }

        user -> web "Uses" "HTTPS"
        web -> entra "Authenticates users with" "OIDC"
        web -> api "Sends chat requests to" "HTTPS/JSON"
api -> user "Streams grounded answers to" "HTTPS"
        api -> orchestrator "Delegates grounded answer generation to"
        orchestrator -> embeddings "Creates a query embedding with" "HTTPS"
        orchestrator -> search "Runs hybrid and vector retrieval against" "HTTPS"
        orchestrator -> safety "Checks prompts and candidate responses with" "HTTPS"
        orchestrator -> model "Sends the grounded prompt to" "HTTPS"
        api -> state "Stores conversation metadata and feedback in"
        api -> kv "Retrieves protected configuration from"
        contentOwner -> documents "Publishes approved documents to"
        documents -> ingestion "Triggers or supplies documents to"
        ingestion -> embeddings "Creates embeddings with"
        ingestion -> search "Creates and updates the search index in"
        ingestion -> telemetry "Emits ingestion and indexing telemetry to"
        api -> telemetry "Emits request and feedback telemetry to"
        orchestrator -> telemetry "Emits retrieval, prompt, model, and evaluation telemetry to"
        telemetry -> monitor "Exports health and alerts to"
        aiEngineer -> telemetry "Reviews RAG quality and evaluation results in"

        deploymentEnvironment "Production" {
            deploymentNode "Azure AI Workload Subscription" {
                description "Production AI workload subscription."
                technology "Azure Subscription"
                deploymentNode "Application Virtual Network" {
                    description "Private application network."
                    technology "Azure Virtual Network"
                    deploymentNode "App Service Integration Subnet" {
                        description "Application compute integration."
                        technology "Azure Subnet"
                        deploymentNode "Web App Service Plan" {
                            description "Hosts the user interface."
                            technology "Azure App Service"
                            webInstance = containerInstance web {
                            }
                        }
                        deploymentNode "API App Service Plan" {
                            description "Hosts API and orchestration logic."
                            technology "Azure App Service"
                    apiInstance = containerInstance api {
                    }
                    orchestratorInstance = containerInstance orchestrator {
                    }
                }
                    }
                    deploymentNode "Private Endpoint Subnet" {
                        description "Private endpoints for AI and data services."
                        technology "Azure Subnet"
                        searchInstance = containerInstance search {
                        }
                        modelInstance = containerInstance model {
                        }
                        embeddingsInstance = containerInstance embeddings {
                        }
                        documentsInstance = containerInstance documents {
                        }
                        stateInstance = containerInstance state {
                        }
                        kvInstance = containerInstance kv {
                        }
                        safetyInstance = containerInstance safety {
                        }
                    }
                }
                deploymentNode "Serverless Ingestion" {
                    description "Document processing compute."
                    technology "Azure Functions"
                    ingestionInstance = containerInstance ingestion {
                    }
                }
                deploymentNode "AI Observability" {
                    description "Application and AI telemetry."
                    technology "Azure Monitor / Microsoft Foundry"
                    telemetryInstance = containerInstance telemetry {
                    }
                }
            }
        }
    }

    views {
        systemLandscape "Landscape" "Users, identity, monitoring, and the enterprise RAG assistant" {
            include *
            autoLayout lr 350 300
        }
        systemContext rag "SystemContext" "Context of the enterprise RAG assistant" {
            include *
            autoLayout lr 300 250
        }
        container rag "Containers" "Online RAG, ingestion, data, safety, and observability services" {
            include *
            autoLayout lr 300 250
        }
        dynamic rag "GroundedQuestion" "User asks a grounded enterprise question" {
            user -> web "1. Submits a question"
            web -> api "2. Sends the authenticated chat request"
            api -> orchestrator "3. Starts the RAG workflow"
            orchestrator -> embeddings "4. Creates a query embedding"
            orchestrator -> search "5. Retrieves relevant chunks with hybrid search"
            orchestrator -> safety "6. Evaluates the prompt"
            orchestrator -> model "7. Sends instructions, question, and grounded context"
            orchestrator -> safety "8. Evaluates the generated answer"
            api -> state "9. Stores conversation metadata"
            api -> user "10. Streams the grounded answer through the web application"
            autoLayout lr
        }
        dynamic rag "IndexDocument" "Approved content is chunked, embedded, and indexed" {
            contentOwner -> documents "1. Uploads an approved document"
            documents -> ingestion "2. Triggers document processing"
            ingestion -> embeddings "3. Creates chunk embeddings"
            ingestion -> search "4. Upserts chunks, vectors, and metadata"
            ingestion -> telemetry "5. Records indexing outcome and quality metrics"
            autoLayout lr
        }
        deployment rag "Production" "Private production deployment of the RAG assistant" {
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
