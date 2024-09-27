struct AppDataStoreService {
    static let dataStore = PlistDataStore<AppData>(filename: "settings")
    
    static func getAppData() async -> AppData {
        return await dataStore.load() ?? AppData(city: "")
    }
    
    static func saveAppdata(appData: AppData) {
        Task {
            await dataStore.save(appData )
        }
    }
}
