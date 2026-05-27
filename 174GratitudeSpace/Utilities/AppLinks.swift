import Foundation

enum AppLink {
    case privacyPolicy
    case termsOfUse

    var title: String {
        switch self {
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfUse:
            return "Terms of Use"
        }
    }

    var urlString: String {
        switch self {
        case .privacyPolicy:
            return "https://www.termsfeed.com/live/a026a55a-7a4a-4ddc-b647-e59352ea5507"
        case .termsOfUse:
            return "https://www.termsfeed.com/live/816826c8-8b54-48d1-9937-3282062af58e"
        }
    }

    var url: URL? {
        URL(string: urlString)
    }
}
