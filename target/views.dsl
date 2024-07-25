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
        ticketingWebsite.web.seatsController
        ticketingWebsite.web.paymentController
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

dynamic ticketingWebsite "ViewSeatsState" "Seats state are:\n- Available\n- Soft locked\n- Locked" {
    user -> ticketingWebsite.spa "View available seats"
    ticketingWebsite.spa -> ticketingWebsite.web "HTTP request for available seats"
    ticketingWebsite.web -> ticketingWebsite.database "Request available seats (Not bought seats)"
    ticketingWebsite.database -> ticketingWebsite.web "Send available seats"
    ticketingWebsite.spa -> ticketingWebsite.webSocketServer "Open web socket connection"
    ticketingWebsite.spa -> ticketingWebsite.webSocketServer "Request soft locked seats and locked (for payment) seats"
    ticketingWebsite.webSocketServer -> ticketingWebsite.spa "Send available seats"
    ticketingWebsite.spa -> user "Display state of seats"

    autoLayout
}

dynamic ticketingWebsite "SelectSeats" "Allow user to select seats" {
    user -> ticketingWebsite.spa "Select the seat(s)"
    ticketingWebsite.spa -> ticketingWebsite.web "Request to select seats"
    ticketingWebsite.web -> ticketingWebsite.webSocketServer "Open WebSocket connection"
    ticketingWebsite.web -> ticketingWebsite.webSocketServer "Send selected seats"
    // ticketingWebsite.webSocketServer -> ticketingWebsite.spa "Notify other users about seat selection"
    // ticketingWebsite.spa -> user "Confirm seat soft lock"

    autoLayout
}

dynamic ticketingWebsite "PayTicket" "User pays for the ticket" {
    user -> ticketingWebsite.spa "Go to payment step"
    ticketingWebsite.spa -> ticketingWebsite.webSocketServer "Hard lock selected seats"
    ticketingWebsite.webSocketServer -> ticketingWebsite.spa "Notify all users with those selected seats"
    ticketingWebsite.spa -> user "Notify user with seat locks and ask for change the selected seats"
    ticketingWebsite.spa -> user "Redirect to payment gateway for payment"

    user -> paymentService "Pay for the ticket"    
    paymentService -> ticketingWebsite.web "Payment confirmation"
    ticketingWebsite.web -> ticketingWebsite.database "Create purchase record"
    ticketingWebsite.web -> ticketingWebsite.webSocketServer "Send payment confirmation to unlock seats"

    ticketingWebsite.web -> ticketingWebsite.spa "Success payment response"
    ticketingWebsite.spa -> user "Notify user with success payment"

    autoLayout
}

dynamic ticketingWebsite "CancelTicket" "" {
    user -> ticketingWebsite.spa "Go to cancel ticket step"
    ticketingWebsite.spa -> ticketingWebsite.web "Request to cancel ticket"
    ticketingWebsite.web -> ticketingWebsite.database "Cancel ticket and unlock seats"
    ticketingWebsite.web -> ticketingWebsite.spa "Notify user with success cancel ticket"
    autoLayout
}

dynamic ticketingWebsite "ViewTickets" "" {
    user -> ticketingWebsite.spa "Go to view tickets step"
    ticketingWebsite.spa -> ticketingWebsite.web "Request to view tickets"
    ticketingWebsite.web -> ticketingWebsite.database "Get tickets"
    ticketingWebsite.web -> ticketingWebsite.spa "Display tickets"
    ticketingWebsite.spa -> user "Display tickets"
    autoLayout
}

dynamic ticketingWebsite "AddConcert" "" {
    businessOwner -> ticketingWebsite.spa "Go to add concert step"
    ticketingWebsite.spa -> ticketingWebsite.web "Request to add concert"
    ticketingWebsite.web -> ticketingWebsite.database "Add concert"
    ticketingWebsite.web -> ticketingWebsite.spa "Notify business owner with success add concert"
    autoLayout
}

dynamic ticketingWebsite "CancelConcert" "" {
    businessOwner -> ticketingWebsite.spa "Go to cancel concert step"
    ticketingWebsite.spa -> ticketingWebsite.web "Request to cancel concert"
    ticketingWebsite.web -> ticketingWebsite.database "Get all tickets for the concert"
    ticketingWebsite.web -> user "Notify user with all tickets for the concert of canceling" "email"
    ticketingWebsite.web -> ticketingWebsite.database "Cancel all tickets for the concert"
    ticketingWebsite.web -> ticketingWebsite.database "Cancel concert"
    ticketingWebsite.web -> ticketingWebsite.spa "Notify business owner with success cancel concert"
    autoLayout
}

dynamic ticketingWebsite "ViewConcerts" "" {
    user -> ticketingWebsite.spa "Go to view concerts step"
    ticketingWebsite.spa -> ticketingWebsite.web "Request to view concerts"
    ticketingWebsite.web -> ticketingWebsite.database "Get concerts"
    ticketingWebsite.web -> ticketingWebsite.spa "Display concerts with seats state"
    ticketingWebsite.spa -> user "Display concerts"
    autoLayout
}
