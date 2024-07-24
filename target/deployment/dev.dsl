devLaptop = deploymentNode "Developer Laptop" "" "Microsoft Windows 10 or Apple macOS" {
    devBrowser = deploymentNode "Web" "" "Chrome, Firefox, Safari, or Edge" {
        developerSinglePageApplicationInstance = containerInstance ticketingWebsite.spa
    }
    
    devDocker = deploymentNode "Docker Container - Web Server" "" "Docker" {
        devTomcat = deploymentNode "Apache Tomcat" "" "Apache Tomcat 8.x" {
            developerWebApplicationInstance = containerInstance ticketingWebsite.web
            // developerApiApplicationInstance = containerInstance ticketingWebsite.api
        }
    }
    
    devDbDocker = deploymentNode "Docker Container - Database Server" "" "Docker" {
        devDbServer = deploymentNode "Database Server" "" "Oracle 12c" {
            developerDatabaseInstance = containerInstance ticketingWebsite.database
        }
    }
}
