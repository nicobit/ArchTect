workspace "Azure Industrial IoT Edge to Cloud" "Industrial IoT architecture with Azure IoT Operations at the edge and cloud analytics." {

    !identifiers hierarchical

    model {
        plantOperator = person "Plant Operator" {
            description "Monitors equipment and responds to operational conditions."
        }
        dataScientist = person "Industrial Data Scientist" {
            description "Builds condition-monitoring and predictive models."
        }
        enterpriseUser = person "Operations Manager" {
            description "Consumes fleet and plant dashboards."
        }
        industrialAssets = softwareSystem "Industrial Equipment" {
            description "Machines, PLCs, sensors, and production lines."
            tags "External"
        }
        enterpriseSystems = softwareSystem "Enterprise Systems" {
            description "MES, ERP, maintenance, and quality systems."
            tags "External"
        }
        monitor = softwareSystem "Azure Monitor" {
            description "Monitors edge and cloud platform health."
            tags "Azure,Observability"
        }

        platform = softwareSystem "Industrial IoT Platform" {
            description "Edge-to-cloud industrial telemetry, analytics, and command platform."
            opc = container "OPC UA Connectivity" {
                description "Discovers assets and collects industrial data."
                technology "OPC UA Connector"
                tags "Edge"
            }
            mqtt = container "Edge MQTT Broker" {
                description "Provides local publish-subscribe messaging."
                technology "Azure IoT Operations MQTT Broker"
                tags "Edge,Queue"
            }
            edgeProcessor = container "Edge Data Processor" {
                description "Filters, normalizes, and enriches telemetry close to equipment."
                technology "Azure IoT Operations Data Flows"
                tags "Edge"
            }
            edgeConfig = container "Edge Configuration and Registry" {
                description "Stores asset definitions and edge configuration."
                technology "Azure Device Registry / Arc"
                tags "Azure,Edge"
            }
            eventHubs = container "Cloud Telemetry Ingestion" {
                description "Ingests high-volume industrial telemetry."
                technology "Azure Event Hubs"
                tags "Azure,Queue"
            }
            stream = container "Streaming Analytics" {
                description "Processes telemetry and detects conditions in near real time."
                technology "Azure Stream Analytics / Databricks"
                tags "Azure,Data"
            }
            lake = container "Industrial Data Lake" {
                description "Stores raw and curated telemetry history."
                technology "ADLS Gen2 / Delta Lake"
                tags "Azure,Database,Data"
            }
            explorer = container "Time-Series Analytics" {
                description "Supports low-latency exploration and operational analytics."
                technology "Azure Data Explorer"
                tags "Azure,Database,Data"
            }
            digitalTwin = container "Asset Context Model" {
                description "Represents assets, relationships, and contextual metadata."
                technology "Azure Digital Twins / Fabric Real-Time Intelligence"
                tags "Azure,Data"
            }
            alerts = container "Alert and Workflow Service" {
                description "Creates operational alerts and maintenance workflows."
                technology "Azure Functions / Logic Apps"
                tags "Azure"
            }
            dashboards = container "Industrial Dashboards" {
                description "Provides OEE, condition, anomaly, and fleet dashboards."
                technology "Power BI / Managed Grafana"
                tags "Azure,Data"
            }
            ml = container "Predictive Analytics" {
                description "Trains and serves anomaly and failure prediction models."
                technology "Azure Machine Learning"
                tags "Azure,Data"
            }
            command = container "Cloud-to-Edge Command Service" {
                description "Sends approved configuration and control messages to edge sites."
                technology "Azure IoT Operations / Event Grid"
                tags "Azure,Security"
            }
            telemetry = container "Platform Telemetry" {
                description "Collects edge and cloud operational telemetry."
                technology "Log Analytics / Managed Prometheus"
                tags "Azure,Observability"
            }
        }

        industrialAssets -> opc "Publishes industrial data to" "OPC UA"
        opc -> mqtt "Publishes normalized asset telemetry to" "MQTT" "Asynchronous"
        mqtt -> edgeProcessor "Delivers telemetry streams to" "MQTT" "Asynchronous"
        edgeProcessor -> eventHubs "Forwards selected telemetry to the cloud" "MQTT/AMQP" "Asynchronous"
        edgeConfig -> opc "Supplies asset and endpoint configuration to"
        eventHubs -> stream "Provides telemetry partitions to" "Event stream" "Asynchronous"
        stream -> lake "Writes historical telemetry to"
        stream -> explorer "Writes operational time-series data to"
        stream -> alerts "Emits detected conditions to" "Event" "Asynchronous"
        stream -> digitalTwin "Updates asset state and context in"
        lake -> ml "Provides training data to"
        ml -> stream "Provides deployed scoring models to"
        explorer -> dashboards "Provides operational queries to"
        digitalTwin -> dashboards "Provides asset context to"
        enterpriseUser -> dashboards "Uses industrial dashboards in" "HTTPS"
        plantOperator -> alerts "Receives and acknowledges alerts from"
        alerts -> enterpriseSystems "Creates maintenance or quality workflows in" "HTTPS"
        dataScientist -> ml "Develops and evaluates models in"
        enterpriseSystems -> command "Requests approved edge configuration changes through" "HTTPS"
        command -> mqtt "Publishes cloud-to-edge commands to" "MQTT" "Asynchronous"
        mqtt -> industrialAssets "Delivers approved commands through edge connectors to" "Industrial protocol"
        opc -> telemetry "Emits edge telemetry to"
        mqtt -> telemetry "Emits broker telemetry to"
        eventHubs -> telemetry "Emits ingestion telemetry to"
        stream -> telemetry "Emits processing telemetry to"
        telemetry -> monitor "Exports health and alerts to"

        deploymentEnvironment "Production" {
            deploymentNode "Factory Site" {
                description "Industrial edge location."
                technology "Physical Site"
                industrialAssetsInstance = softwareSystemInstance industrialAssets {
                }
                deploymentNode "Azure Arc-enabled Kubernetes Cluster" {
                    description "Connected edge Kubernetes cluster."
                    technology "Azure Arc-enabled Kubernetes"
                    deploymentNode "Azure IoT Operations" {
                        description "Industrial edge services."
                        technology "Kubernetes namespace"
                        opcInstance = containerInstance opc {
                        }
                        mqttInstance = containerInstance mqtt {
                        }
                        edgeProcessorInstance = containerInstance edgeProcessor {
                        }
                    }
                }
            }
            deploymentNode "Azure Primary Region" {
                description "Cloud ingestion, analytics, and management region."
                technology "Azure Region"
                deploymentNode "Edge Management Plane" {
                    description "Central edge configuration and inventory."
                    technology "Azure IoT Operations / Azure Arc"
            edgeConfigInstance = containerInstance edgeConfig {
            }
            commandInstance = containerInstance command {
            }
        }
                deploymentNode "Streaming Ingestion" {
                    description "Managed telemetry ingestion."
                    technology "Azure Event Hubs"
                    eventHubsInstance = containerInstance eventHubs {
                    }
                }
                deploymentNode "Analytics Platform" {
                    description "Stream, lakehouse, time-series, contextual, and ML services."
                    technology "Azure Data Platform"
                    streamInstance = containerInstance stream {
                    }
                    lakeInstance = containerInstance lake {
                    }
                    explorerInstance = containerInstance explorer {
                    }
                    digitalTwinInstance = containerInstance digitalTwin {
                    }
                    mlInstance = containerInstance ml {
                    }
                }
                deploymentNode "Operations Services" {
                    description "Alerts and visualization."
                    technology "Azure Operations"
            alertsInstance = containerInstance alerts {
            }
            dashboardsInstance = containerInstance dashboards {
            }
        }
                deploymentNode "Monitoring Workspace" {
                    description "Central platform monitoring."
                    technology "Azure Monitor"
                    telemetryInstance = containerInstance telemetry {
                    }
                }
            }
        }
    }

    views {
        systemLandscape "Landscape" "Industrial equipment, enterprise systems, users, and the IoT platform" {
            include *
            autoLayout lr 350 300
        }
        systemContext platform "SystemContext" "Context of the industrial IoT platform" {
            include *
            autoLayout lr 300 250
        }
        container platform "Containers" "Edge connectivity, cloud ingestion, analytics, operations, and commands" {
            include *
            autoLayout lr 300 250
        }
        dynamic platform "TelemetryFlow" "Industrial telemetry flows from equipment to operational dashboards" {
            industrialAssets -> opc "1. Publishes OPC UA data"
            opc -> mqtt "2. Publishes normalized telemetry"
            mqtt -> edgeProcessor "3. Delivers local telemetry"
            edgeProcessor -> eventHubs "4. Forwards selected telemetry to Azure"
            eventHubs -> stream "5. Supplies partitioned event streams"
            stream -> explorer "6. Writes operational time-series data"
            stream -> lake "7. Persists telemetry history"
            explorer -> dashboards "8. Serves operational dashboard queries"
            enterpriseUser -> dashboards "9. Views plant and fleet dashboards"
            autoLayout lr
        }
        dynamic platform "CloudToEdgeCommand" "Approved enterprise command reaches industrial equipment" {
            enterpriseSystems -> command "1. Requests a configuration change"
            command -> mqtt "2. Publishes an authorized edge command"
            mqtt -> industrialAssets "3. Delivers the command through the edge connector"
            industrialAssets -> opc "4. Publishes the resulting equipment state"
            opc -> mqtt "5. Publishes confirmation telemetry"
            autoLayout lr
        }
        deployment platform "Production" "Factory edge and Azure cloud deployment" {
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
