workspace "Azure Hub-Spoke Network" "Enterprise hybrid connectivity and shared-services hub-and-spoke topology." {

    !identifiers hierarchical

    model {
        branchUser = person "Branch User" {
            description "Consumes Azure-hosted business applications."
            tags "External"
        }
        networkOps = person "Network Operations" {
            description "Operates connectivity and security controls."
        }
        onprem = softwareSystem "On-Premises Datacenter" {
            description "Corporate networks, DNS, identity, and legacy systems."
            tags "External"
        }
        saas = softwareSystem "Internet and SaaS Services" {
            description "External internet destinations and SaaS providers."
            tags "External"
        }

        network = softwareSystem "Azure Enterprise Network" {
            description "Customer-managed hub-and-spoke network platform."
            gateway = container "Hybrid Connectivity Gateway" {
                description "Terminates ExpressRoute and VPN connectivity."
                technology "ExpressRoute Gateway / VPN Gateway"
                tags "Azure"
            }
            firewall = container "Central Firewall" {
                description "Inspects north-south and east-west traffic."
                technology "Azure Firewall Premium"
                tags "Azure,Security"
            }
            bastion = container "Secure Administration" {
                description "Provides browser-based administrative access."
                technology "Azure Bastion"
                tags "Azure,Security"
            }
            dns = container "Private DNS Resolver" {
                description "Resolves Azure and on-premises private names."
                technology "Azure DNS Private Resolver"
                tags "Azure"
            }
            prodApp = container "Production Workload" {
                description "Representative production application hosted in a spoke."
                technology "Azure App Service / VMs / AKS"
                tags "Azure"
            }
            prodDb = container "Production Data Store" {
                description "Representative private production database."
                technology "Azure SQL Database"
                tags "Azure,Database,Data"
            }
            nonProdApp = container "Nonproduction Workload" {
                description "Development and test workload in an isolated spoke."
                technology "Azure Compute"
                tags "Azure"
            }
            shared = container "Shared Platform Services" {
                description "Central agents, tooling, and shared services."
                technology "Azure Compute"
                tags "Azure"
            }
            watcher = container "Network Observability" {
                description "Captures flow logs, topology, and diagnostics."
                technology "Network Watcher / Log Analytics"
                tags "Azure,Observability"
            }
        }

        branchUser -> onprem "Uses corporate network"
        onprem -> gateway "Connects to Azure through" "ExpressRoute/VPN"
        gateway -> firewall "Routes hybrid traffic through"
        firewall -> prodApp "Allows approved production traffic to"
prodApp -> branchUser "Returns application responses to" "HTTPS"
        prodApp -> prodDb "Uses private data services in" "TDS/TLS"
        firewall -> nonProdApp "Allows approved nonproduction traffic to"
        firewall -> shared "Allows access to shared services"
        prodApp -> firewall "Routes controlled internet egress through"
        firewall -> saas "Connects to approved destinations in" "HTTPS"
        prodApp -> dns "Resolves private names with" "DNS"
        nonProdApp -> dns "Resolves private names with" "DNS"
        dns -> onprem "Forwards corporate DNS queries to" "DNS"
        networkOps -> bastion "Opens secure administration sessions through" "HTTPS"
        bastion -> prodApp "Administers authorized resources in" "RDP/SSH"
        firewall -> watcher "Emits diagnostics to"
        gateway -> watcher "Emits diagnostics to"
        prodApp -> watcher "Emits network and platform logs to"
        networkOps -> watcher "Reviews network health in"

        deploymentEnvironment "Production" {
            deploymentNode "Corporate Network" {
                description "On-premises locations and datacenters."
                technology "On-Premises"
                onpremInstance = softwareSystemInstance onprem {
                }
            }
            deploymentNode "Azure Connectivity Subscription" {
                description "Central connectivity subscription."
                technology "Azure Subscription"
                deploymentNode "Hub Virtual Network" {
                    description "Central connectivity and shared services."
                    technology "Azure Virtual Network"
                    deploymentNode "GatewaySubnet" {
                        description "Hybrid connectivity subnet."
                        technology "Azure Subnet"
                        gatewayInstance = containerInstance gateway {
                        }
                    }
                    deploymentNode "AzureFirewallSubnet" {
                        description "Firewall subnet."
                        technology "Azure Subnet"
                        firewallInstance = containerInstance firewall {
                        }
                    }
                    deploymentNode "AzureBastionSubnet" {
                        description "Bastion subnet."
                        technology "Azure Subnet"
                        bastionInstance = containerInstance bastion {
                        }
                    }
                    deploymentNode "DNS Inbound/Outbound Subnets" {
                        description "Private DNS resolver endpoints."
                        technology "Azure Subnet"
                        dnsInstance = containerInstance dns {
                        }
                    }
                    deploymentNode "Shared Services Subnet" {
                        description "Central platform services."
                        technology "Azure Subnet"
                        sharedInstance = containerInstance shared {
                        }
                    }
                }
            }
            deploymentNode "Azure Production Subscription" {
                description "Production workload subscription."
                technology "Azure Subscription"
                deploymentNode "Production Spoke VNet" {
                    description "Isolated production workload network."
                    technology "Azure Virtual Network"
                    deploymentNode "Application Subnet" {
                        description "Production compute."
                        technology "Azure Subnet"
                        prodAppInstance = containerInstance prodApp {
                        }
                    }
                    deploymentNode "Private Endpoint Subnet" {
                        description "Private data endpoints."
                        technology "Azure Subnet"
                        prodDbInstance = containerInstance prodDb {
                        }
                    }
                }
            }
            deploymentNode "Azure Nonproduction Subscription" {
                description "Development and test subscription."
                technology "Azure Subscription"
                deploymentNode "Nonproduction Spoke VNet" {
                    description "Isolated nonproduction workload network."
                    technology "Azure Virtual Network"
                    nonProdAppInstance = containerInstance nonProdApp {
                    }
                }
            }
            deploymentNode "Azure Management Subscription" {
                description "Central monitoring."
                technology "Azure Subscription"
                watcherInstance = containerInstance watcher {
                }
            }
        }
    }

    views {
        systemLandscape "Landscape" "Hybrid enterprise connectivity landscape" {
            include *
            autoLayout lr 350 300
        }
        systemContext network "SystemContext" "Context of the Azure enterprise network platform" {
            include *
            autoLayout lr 300 250
        }
        container network "NetworkTopology" "Logical hub, spokes, shared services, and workloads" {
            include *
            autoLayout lr 300 250
        }
        dynamic network "HybridRequest" "Branch user accesses a production workload" {
            branchUser -> onprem "1. Connects from the corporate network"
            onprem -> gateway "2. Sends traffic over ExpressRoute or VPN"
            gateway -> firewall "3. Routes traffic for central inspection"
            firewall -> prodApp "4. Allows the approved application request"
            prodApp -> prodDb "5. Loads private application data"
            prodApp -> branchUser "6. Returns the response over the reverse path"
            autoLayout lr
        }
        dynamic network "InternetEgress" "Production workload accesses an approved SaaS endpoint" {
            prodApp -> firewall "1. Sends default-route traffic to the hub firewall"
            firewall -> saas "2. Applies policy, SNAT, and forwards approved HTTPS traffic"
            autoLayout lr
        }
        deployment network "Production" "Subscriptions, VNets, subnets, and shared network services" {
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
