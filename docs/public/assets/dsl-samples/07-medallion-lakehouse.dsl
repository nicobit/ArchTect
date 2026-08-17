workspace "Azure Medallion Lakehouse" "Azure data platform with bronze, silver, and gold medallion layers." {

    !identifiers hierarchical

    model {
        dataProducer = person "Source System Owner" {
            description "Provides operational and analytical data."
            tags "External"
        }
        analyst = person "Data Analyst" {
            description "Explores curated data and builds reports."
        }
        dataEngineer = person "Data Engineer" {
            description "Develops and operates ingestion and transformation pipelines."
        }
        saas = softwareSystem "SaaS and Operational Sources" {
            description "CRM, ERP, files, APIs, and operational databases."
            tags "External"
        }
        onprem = softwareSystem "On-Premises Data Sources" {
            description "Private corporate databases and files."
            tags "External"
        }
        monitor = softwareSystem "Azure Monitor" {
            description "Monitors pipelines, clusters, and data quality."
            tags "Azure,Observability"
        }

        platform = softwareSystem "Enterprise Lakehouse Platform" {
            description "Batch-oriented medallion lakehouse and analytical serving platform."
            factory = container "Data Orchestration" {
                description "Schedules and coordinates ingestion and transformation pipelines."
                technology "Azure Data Factory"
                tags "Azure,Data"
            }
            integrationRuntime = container "Self-Hosted Integration Runtime" {
                description "Connects securely to on-premises sources."
                technology "Data Factory Integration Runtime"
                tags "Azure,Data"
            }
            bronze = container "Bronze Data Lake" {
                description "Stores raw, immutable source-aligned data."
                technology "ADLS Gen2 / Delta"
                tags "Azure,Database,Data"
            }
            silver = container "Silver Data Lake" {
                description "Stores validated, standardized, and conformed data."
                technology "ADLS Gen2 / Delta"
                tags "Azure,Database,Data"
            }
            gold = container "Gold Data Lake" {
                description "Stores business-ready aggregates and data products."
                technology "ADLS Gen2 / Delta"
                tags "Azure,Database,Data"
            }
            databricks = container "Lakehouse Processing" {
                description "Cleans, enriches, joins, and aggregates data."
                technology "Azure Databricks"
                tags "Azure,Data"
            }
            catalog = container "Data Governance Catalog" {
                description "Provides discovery, lineage, classification, and governance."
                technology "Microsoft Purview / Unity Catalog"
                tags "Azure,Data,Security"
            }
            serving = container "Analytical Serving Database" {
                description "Serves curated relational models and aggregates."
                technology "Azure SQL Database / Fabric Warehouse"
                tags "Azure,Database,Data"
            }
            bi = container "Business Intelligence" {
                description "Provides semantic models, dashboards, and reports."
                technology "Power BI"
                tags "Azure,Data"
            }
            kv = container "Data Platform Secrets" {
                description "Stores secrets and credentials."
                technology "Azure Key Vault"
                tags "Azure,Security"
            }
            telemetry = container "Data Platform Telemetry" {
                description "Collects pipeline, job, cluster, and quality telemetry."
                technology "Log Analytics / Application Insights"
                tags "Azure,Observability"
            }
        }

        dataProducer -> saas "Maintains data in"
        saas -> factory "Provides cloud data to" "Connectors/APIs"
factory -> saas "Extracts cloud source data from" "Connectors/APIs"
factory -> integrationRuntime "Orchestrates private-source extraction through"
integrationRuntime -> onprem "Reads private source data from" "JDBC/ODBC/File"
bi -> serving "Queries curated analytical models in"
bi -> analyst "Renders dashboards and reports for" "HTTPS"
        onprem -> integrationRuntime "Provides private data to" "JDBC/ODBC/File"
        integrationRuntime -> factory "Transfers data under orchestration of"
        factory -> bronze "Ingests raw data into"
        factory -> databricks "Starts transformation jobs in"
        databricks -> bronze "Reads raw data from"
        databricks -> silver "Writes validated and conformed data to"
        databricks -> gold "Writes business-ready data products to"
        gold -> serving "Loads curated serving models into"
        serving -> bi "Provides analytical models to"
        gold -> bi "Provides lake-based semantic data to"
        analyst -> bi "Builds and consumes reports in"
        dataEngineer -> factory "Develops and operates pipelines in"
        dataEngineer -> databricks "Develops notebooks and jobs in"
        factory -> kv "Retrieves connection secrets from"
        databricks -> kv "Retrieves secrets from"
        bronze -> catalog "Publishes metadata and lineage to"
        silver -> catalog "Publishes metadata and lineage to"
        gold -> catalog "Publishes metadata and lineage to"
        factory -> telemetry "Emits pipeline telemetry to"
        databricks -> telemetry "Emits job and cluster telemetry to"
        telemetry -> monitor "Forwards telemetry and alerts to"

        deploymentEnvironment "Production" {
            deploymentNode "Azure Data Platform Subscription" {
                description "Production data platform subscription."
                technology "Azure Subscription"
                deploymentNode "Data Platform Virtual Network" {
                    description "Private data platform network."
                    technology "Azure Virtual Network"
                    deploymentNode "Data Factory Managed VNet" {
                        description "Managed integration runtime network."
                        technology "Azure Managed VNet"
                        factoryInstance = containerInstance factory {
                        }
                    }
                    deploymentNode "Databricks Workspace VNet" {
                        description "Injected Databricks workspace."
                        technology "Azure Virtual Network"
                        databricksInstance = containerInstance databricks {
                        }
                    }
                    deploymentNode "Private Endpoint Subnet" {
                        description "Private endpoints for storage, SQL, and Key Vault."
                        technology "Azure Subnet"
                        bronzeInstance = containerInstance bronze {
                        }
                        silverInstance = containerInstance silver {
                        }
                        goldInstance = containerInstance gold {
                        }
                        servingInstance = containerInstance serving {
                        }
                        kvInstance = containerInstance kv {
                        }
                    }
                }
                deploymentNode "Governance Services" {
                    description "Enterprise governance plane."
                    technology "Azure Data Governance"
                    catalogInstance = containerInstance catalog {
                    }
                }
                deploymentNode "Analytics and Reporting" {
                    description "Managed BI service."
                    technology "Power BI"
                    biInstance = containerInstance bi {
                    }
                }
                deploymentNode "Monitoring Workspace" {
                    description "Central data platform monitoring."
                    technology "Azure Monitor"
                    telemetryInstance = containerInstance telemetry {
                    }
                }
            }
            deploymentNode "Corporate Datacenter" {
                description "Private source network."
                technology "On-Premises"
            integrationRuntimeInstance = containerInstance integrationRuntime {
            }
            onpremInstance = softwareSystemInstance onprem {
            }
        }
        }
    }

    views {
        systemLandscape "Landscape" "Enterprise sources, lakehouse, and analytical consumers" {
            include *
            autoLayout lr 350 300
        }
        systemContext platform "SystemContext" "Context of the enterprise lakehouse platform" {
            include *
            autoLayout lr 300 250
        }
        container platform "Containers" "Ingestion, medallion layers, processing, governance, serving, and BI" {
            include *
            autoLayout lr 300 250
        }
        dynamic platform "DailyBatchPipeline" "Daily ingestion and medallion transformation" {
            factory -> saas "1. Extracts cloud source data"
            factory -> integrationRuntime "2. Requests private source extraction"
            integrationRuntime -> onprem "3. Reads on-premises data"
            factory -> bronze "4. Writes immutable raw data"
            factory -> databricks "5. Starts the transformation workflow"
            databricks -> bronze "6. Reads raw data"
            databricks -> silver "7. Writes validated and conformed data"
            databricks -> gold "8. Writes business-ready aggregates"
            gold -> serving "9. Loads the analytical serving model"
            serving -> bi "10. Refreshes semantic models"
            autoLayout lr
        }
        dynamic platform "AnalyticalQuery" "Analyst opens a curated dashboard" {
            analyst -> bi "1. Opens a dashboard"
            bi -> serving "2. Queries the curated serving model"
            bi -> analyst "3. Renders the analytical result"
            autoLayout lr
        }
        deployment platform "Production" "Production lakehouse deployment" {
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
