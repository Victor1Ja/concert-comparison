devLaptop = deploymentNode "Developer Laptop" "" "Microsoft Windows 10 or Apple macOS or Linux" {
    devBrowser = deploymentNode "Web" "" "Chrome, Firefox, Safari, or Edge" {
        developerSinglePageApplicationInstance = containerInstance ticketingWebsite.spa
    }
    
    devDocker = deploymentNode "Docker Container - Web Server" "" "Docker" {
        devNginx = deploymentNode "Nginx" "" "Nginx 1.27.0" {
            developerWebApplicationInstance = containerInstance ticketingWebsite.web
            developerWebSocketApplicationInstance = containerInstance ticketingWebsite.webSocketServer
        }
    }
    
    devDbDocker = deploymentNode "Docker Container - Database Server" "" "Docker" {
        devDbServer = deploymentNode "Database Server" "" "Postgres 16.3" {
            developerDatabaseInstance = containerInstance ticketingWebsite.database
        }
    }
}
