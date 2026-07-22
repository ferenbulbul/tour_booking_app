import UserNotifications
import OneSignalExtension

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.receivedRequest = request
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // OneSignal resmi (ios_attachments) indirip bildirime ekler
            OneSignalExtension.didReceiveNotificationExtensionRequest(
                self.receivedRequest,
                with: bestAttemptContent,
                withContentHandler: self.contentHandler!
            )
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Süre dolarsa eldeki en iyi içerikle bildirimi göster
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            OneSignalExtension.serviceExtensionTimeWillExpireRequest(
                self.receivedRequest,
                with: bestAttemptContent
            )
            contentHandler(bestAttemptContent)
        }
    }
}
