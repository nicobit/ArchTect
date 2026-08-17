workspace "Azure Serverless Event-Driven Platform" "Serverless publish-subscribe and command-processing architecture." {

    !identifiers hierarchical

    model {
        producer = person "Business Event Producer" {
            description "Creates business events through an application or device."
            tags "External"
        }
        subscriber = person "Operations User" {
            description "Receives alerts and reviews processing outcomes."
            tags "External"
        }
        externalApi = softwareSystem "Downstream Partner API" {
            description "Receives selected processed events."
            tags "External"
        }
        monitor = softwareSystem "Azure Monitor" {
            description "Central observability and alerting."
            tags "Azure,Observability"
        }

        system = softwareSystem "Serverless Event Processing Platform" {
            description "Processes events and commands with managed messaging and Azure Functions."
            ingestion = container "Event Ingestion API" {
                description "Validates producers and accepts incoming events."
                technology "Azure Functions HTTP trigger"
                tags "Azure"
            }
            eventGrid = container "Event Router" {
                description "Routes discrete events to interested subscribers."
                technology "Azure Event Grid"
                tags "Azure,Queue"
            }
            serviceBus = container "Command and Work Queue" {
                description "Provides reliable queues, topics, retries, and dead-lettering."
                technology "Azure Service Bus"
                tags "Azure,Queue"
            }
            processor = container "Event Processor" {
                description "Transforms and enriches incoming events."
                technology "Azure Functions"
                tags "Azure"
            }
            commandWorker = container "Command Worker" {
                description "Executes durable business commands."
                technology "Azure Functions"
                tags "Azure"
            }
            notifier = container "Notification Handler" {
                description "Creates user notifications."
                technology "Azure Functions"
                tags "Azure"
            }
            replay = container "Dead-Letter and Replay Worker" {
                description "Inspects, repairs, and replays failed messages."
                technology "Azure Functions / Durable Functions"
                tags "Azure"
            }
            state = container "Processing State" {
                description "Stores idempotency keys and processing state."
                technology "Azure Cosmos DB"
                tags "Azure,Database,Data"
            }
            payloads = container "Event Payload Store" {
                description "Stores large payloads referenced through claim checks."
                technology "Azure Blob Storage"
                tags "Azure,Database,Data"
            }
            telemetry = container "Serverless Telemetry" {
                description "Collects traces, logs, metrics, and failures."
                technology "Application Insights"
                tags "Azure,Observability"
            }
        }

        producer -> ingestion "Publishes business events" "HTTPS/JSON"
        ingestion -> payloads "Stores large event payloads in"
        ingestion -> eventGrid "Publishes accepted events to" "HTTPS" "Asynchronous"
        eventGrid -> processor "Triggers event processing" "Event Grid delivery" "Asynchronous"
        processor -> state "Checks idempotency and updates state in"
        processor -> serviceBus "Publishes reliable commands to" "AMQP" "Asynchronous"
        serviceBus -> commandWorker "Delivers commands to" "AMQP" "Asynchronous"
        commandWorker -> state "Updates command state in"
        commandWorker -> externalApi "Invokes approved downstream operations" "HTTPS"
        commandWorker -> eventGrid "Publishes command outcomes to" "HTTPS" "Asynchronous"
        eventGrid -> notifier "Triggers notifications" "Event Grid delivery" "Asynchronous"
        notifier -> subscriber "Sends operational notifications to" "Email/SMS/Push"
        serviceBus -> replay "Makes dead-lettered messages available to" "AMQP" "Asynchronous"
replay -> payloads "Loads original claim-check payloads from" "HTTPS"
        replay -> serviceBus "Replays repaired messages to" "AMQP" "Asynchronous"
        ingestion -> telemetry "Emits telemetry to"
        processor -> telemetry "Emits telemetry to"
        commandWorker -> telemetry "Emits telemetry to"
        notifier -> telemetry "Emits telemetry to"
        replay -> telemetry "Emits telemetry to"
        telemetry -> monitor "Exports telemetry to"

        deploymentEnvironment "Production" {
            deploymentNode "Azure Primary Region" {
                description "Production serverless region."
                technology "Azure Region"
                deploymentNode "Functions Premium Plan" {
                    description "Network-integrated serverless compute."
                    technology "Azure Functions"
                    ingestionInstance = containerInstance ingestion {
                    }
                    processorInstance = containerInstance processor {
                    }
                    commandWorkerInstance = containerInstance commandWorker {
                    }
                    notifierInstance = containerInstance notifier {
                    }
                    replayInstance = containerInstance replay {
                    }
                }
                deploymentNode "Messaging Services" {
                    description "Managed eventing and messaging."
                    technology "Azure Messaging"
                    eventGridInstance = containerInstance eventGrid {
                    }
                    serviceBusInstance = containerInstance serviceBus {
                    }
                }
                deploymentNode "State and Payload Services" {
                    description "Managed persistence."
                    technology "Azure Data Services"
                    stateInstance = containerInstance state {
                    }
                    payloadsInstance = containerInstance payloads {
                    }
                }
                deploymentNode "Application Monitoring" {
                    description "Serverless telemetry."
                    technology "Application Insights"
                    telemetryInstance = containerInstance telemetry {
                    }
                }
            }
        }
    }

    views {
        systemLandscape "Landscape" "Producers, subscribers, and downstream systems" {
            include *
            autoLayout lr 350 300
        }
        systemContext system "SystemContext" "Context of the serverless event-processing platform" {
            include *
            autoLayout lr 300 250
        }
        container system "Containers" "Serverless functions, messaging, state, payloads, and telemetry" {
            include *
            autoLayout lr 300 250
        }
        dynamic system "EventToCommand" "Business event becomes a reliable command" {
            producer -> ingestion "1. Publishes an event"
            ingestion -> payloads "2. Stores the large payload and creates a claim check"
            ingestion -> eventGrid "3. Publishes event metadata"
            eventGrid -> processor "4. Triggers processing"
            processor -> state "5. Verifies idempotency"
            processor -> serviceBus "6. Enqueues a durable command"
            serviceBus -> commandWorker "7. Delivers the command"
            commandWorker -> externalApi "8. Executes the downstream operation"
            commandWorker -> eventGrid "9. Publishes the outcome"
            eventGrid -> notifier "10. Triggers notification handling"
            notifier -> subscriber "11. Sends the notification"
            autoLayout lr
        }
        dynamic system "FailureReplay" "Dead-letter inspection and controlled replay" {
            serviceBus -> replay "1. Exposes a dead-lettered command"
            replay -> payloads "2. Loads the original payload"
            replay -> serviceBus "3. Resubmits the repaired command"
            serviceBus -> commandWorker "4. Redelivers the command"
            autoLayout lr
        }
        deployment system "Production" "Production serverless deployment" {
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
