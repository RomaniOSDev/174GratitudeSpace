import UIKit

enum ImageStorage {
    private static var directoryURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("GratitudePhotos", isDirectory: true)
    }

    static func fileName(for entryId: UUID) -> String {
        "\(entryId.uuidString).jpg"
    }

    @discardableResult
    static func saveJPEG(_ image: UIImage, entryId: UUID, compression: CGFloat = 0.82) -> String? {
        guard let data = image.jpegData(compressionQuality: compression) else { return nil }
        return saveData(data, entryId: entryId)
    }

    @discardableResult
    static func saveData(_ data: Data, entryId: UUID) -> String? {
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            let name = fileName(for: entryId)
            let url = directoryURL.appendingPathComponent(name)
            try data.write(to: url, options: .atomic)
            return name
        } catch {
            return nil
        }
    }

    static func load(fileName: String?) -> UIImage? {
        guard let fileName, !fileName.isEmpty else { return nil }
        let url = directoryURL.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func delete(fileName: String?) {
        guard let fileName, !fileName.isEmpty else { return }
        let url = directoryURL.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
    }
}
