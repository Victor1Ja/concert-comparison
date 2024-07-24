systemcontext ticketingWebsite "SystemContext" {
    include *
    animation {
        ticketingWebsite
        user
        businessOwner
        paymentService
    }
    autoLayout
    description "The system context diagram for the Cosmic Master Ticket system."
    properties {
        structurizr.groups false
    }
}

container ticketingWebsite "Containers" {
    include *
    animation {
        ticketingWebsite.spa
        ticketingWebsite.web
        ticketingWebsite.webSocketServer
        ticketingWebsite.database
        user
        businessOwner
        paymentService
    }
    autoLayout
    description "The container diagram for the Internet Banking System."
}

component ticketingWebsite.web "Components" {
    include *
    animation {
        // ticketingWebsite.spa
        // ticketingWebsite.web
        // ticketingWebsite.webSocketServer
        // ticketingWebsite.database
        ticketingWebsite.web.securityComponent
    }
    autoLayout
    description "The component diagram for the API Application."
}

deployment ticketingWebsite "Development" "DevelopmentDeployment" {
    include *
    animation {
        devEnv.devLaptop.devBrowser.developerSinglePageApplicationInstance
        devEnv.devLaptop.devDocker.devNginx.developerWebApplicationInstance devEnv.devLaptop.devDocker.devNginx.developerWebSocketApplicationInstance
        devEnv.devLaptop.devDbDocker.devDbServer.developerDatabaseInstance
    }
    autoLayout
    description "An example development deployment scenario for the Cosmic Master Ticket system."
}

deployment ticketingWebsite "Live" "LiveDeployment" {
    include *
    animation {
        liveEnv.liveUserComputer.liveWebBrowser.liveSinglePageApplicationInstance
        liveEnv.liveDc.liveWebNode.liveWebServer.liveWebApplicationInstance
        liveEnv.liveDc.liveWebSocketNode.liveWebServer.liveWebSocketApplicationInstance
        liveEnv.liveDc.liveDbNode.primaryDatabaseServer.livePrimaryDatabaseInstance
        liveEnv.liveDc.liveFailover.secondaryDatabaseServer.liveSecondaryDatabaseInstance
    }
    autoLayout
    description "An example live deployment scenario for the Cosmic Master Ticket system."
}

dynamic ticketingWebsite.web "ViewSeatsState" "Seats state are:\n- Available\n- Soft locked\n- Locked" {
    user -> ticketingWebsite.spa "View available seats"
    ticketingWebsite.spa -> ticketingWebsite.web.seatsController "HTTP request for available seats"
    ticketingWebsite.web.seatsController -> ticketingWebsite.database "Request available seats (Not bought seats)"
    ticketingWebsite.database -> ticketingWebsite.web.seatsController "Send available seats"
    ticketingWebsite.spa -> ticketingWebsite.webSocketServer "Open web socket connection"
    ticketingWebsite.spa -> ticketingWebsite.webSocketServer "Request soft locked seats and locked (for payment) seats"
    ticketingWebsite.webSocketServer -> ticketingWebsite.spa "Send available seats"
    ticketingWebsite.spa -> user "Display state of seats"

    autoLayout
}

dynamic ticketingWebsite.web "SelectSeats" "Allow user to select seats" {
    user -> ticketingWebsite.spa "Select the seat(s)"
    ticketingWebsite.spa -> ticketingWebsite.web.seatsController "Request to select seats"
    ticketingWebsite.web.seatsController -> ticketingWebsite.webSocketServer "Open WebSocket connection"
    ticketingWebsite.web.seatsController -> ticketingWebsite.webSocketServer "Send selected seats"
    // ticketingWebsite.webSocketServer -> ticketingWebsite.spa "Notify other users about seat selection"
    // ticketingWebsite.spa -> user "Confirm seat soft lock"

    autoLayout
}

dynamic ticketingWebsite.web "PayTicket" "User pays for the ticket" {
    user -> ticketingWebsite.spa "Go to payment step"
    ticketingWebsite.spa -> ticketingWebsite.webSocketServer "Hard lock selected seats"
    ticketingWebsite.webSocketServer -> ticketingWebsite.spa "Notify all users with those selected seats"
    ticketingWebsite.spa -> user "Notify user with seat locks and ask for change the selected seats"
    ticketingWebsite.spa -> user "Redirect to payment gateway for payment"

    user -> paymentService "Pay for the ticket"    
    paymentService -> ticketingWebsite.web.paymentController "Payment confirmation"
    ticketingWebsite.web.paymentController -> ticketingWebsite.database "Create purchase record"
    ticketingWebsite.web.paymentController -> ticketingWebsite.webSocketServer "Send payment confirmation to unlock seats"

    ticketingWebsite.web.paymentController -> ticketingWebsite.spa "Success payment response"
    ticketingWebsite.spa -> user "Notify user with success payment"

    autoLayout
}
