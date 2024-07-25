liveUserComputer = deploymentNode "User's computer" "" "Microsoft Windows or Apple macOS" {
    liveWebBrowser = deploymentNode "Web" "" "Chrome, Firefox, Safari, or Edge" {
        liveSinglePageApplicationInstance = containerInstance ticketingWebsite.spa
    }
}

liveDc = deploymentNode "Cosmic Master Ticket SLU" "" "Cosmic Master Ticket SLU data center" {
    liveWebNode = deploymentNode "ticket-web***" "" "Ubuntu 16.04 LTS" {
        liveWebServer = deploymentNode "Nginx" "" "Nginx 1.27.0" {
            liveWebApplicationInstance = containerInstance ticketingWebsite.web
        }
    }
    
    liveWebSocketNode = deploymentNode "ticket-api***" "" "Ubuntu 16.04 LTS" 2 {
        liveWebServer = deploymentNode "Nginx" "" "Nginx 1.27.0" {
            liveWebSocketApplicationInstance = containerInstance ticketingWebsite.webSocketServer
        }
    }

    liveDbNode = deploymentNode "ticket-db01" "" "Ubuntu 16.04 LTS" {
        primaryDatabaseServer = deploymentNode "Postgres - Primary" "" "Postgres 16.3" {
            livePrimaryDatabaseInstance = containerInstance ticketingWebsite.database
        }
    }
    
    liveFailover = deploymentNode "ticket-db02" "" "Ubuntu 16.04 LTS" "Failover" {
        secondaryDatabaseServer = deploymentNode "Postgres - Secondary" "" "Postgres 16.3" "Failover" {
            liveSecondaryDatabaseInstance = containerInstance ticketingWebsite.database "Failover"
        }
        
        liveDbNode.primaryDatabaseServer -> secondaryDatabaseServer "Replicates data to"
    }
}