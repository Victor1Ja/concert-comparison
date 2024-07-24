user = person "User" {
    description  "A user of the ticketing website"
}
businessOwner = person "Business Owner" {
    description  "Concert organizers and ticketing companies."
}

paymentService = softwaresystem "Payment Service"{
    description  "A payment service that allows users to pay for tickets."
}

ticketingWebsite = softwaresystem "Cosmic Master Ticket" {
    !docs concert-comparison/docs/src
    !adrs concert-comparison/adrs

    spa = container "Single Page Application" "React"
    database = container "Database" "PostgreSQL" "" "Database"

    webSocketServer = container "Web Socket Server" "Node.js" {
        description "A server that allows users to see the availability of seats in real time. Sends updates to the SPA when a seat is taken and when a seat is released."
    }
    
    web = container "Web Server" "A server that serves the SPA and provides an API for the SPA to interact with the database." "Python and FastAPI" {
        seatsController = component "Seats Controller" "Allows users to see the availability of seats and reserve seats." "FastAPI Controller"
        seatsController -> database "Reads from and writes to" "SQL/TCP"
        spa -> seatsController "" "HTTP"
        seatsController -> webSocketServer "Sends updates to the web socket server" "Web Socket"

        securityComponent = component "Security" "Provides security for the web server." "FastAPI Middleware"
        securityComponent -> database "Reads from and writes to" "SQL/TCP"

        paymentController = component "Payment Controller" "Connects to the payment service to allow users to pay for tickets." "FastAPI Controller"
        paymentController -> database "Reads from and writes to" "SQL/TCP"
        paymentService -> paymentController "Recieves payment response" "HTTP"
        paymentController -> webSocketServer "Sends updates to the web socket server" "Web Socket"
        paymentController -> spa "Sends payment response" "HTTP"
    }
    

    spa -> web "HTTP"
    web -> database 
    web -> webSocketServer
    spa -> webSocketServer "Web Socket"
}

user -> ticketingWebsite.spa "Interact with the website" "https"
user -> paymentService "Pay for the ticket" "https"
paymentService -> ticketingWebsite.web "Interact with payment service" "https"
businessOwner -> ticketingWebsite.web "Manage Concerts" "https"
