import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var appCoordinator = AppCoordinator(path: NavigationPath())
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            appCoordinator.build()
                .navigationDestination(for: CurrentWeatherCoordinator.self) { coordinator in
                    coordinator.build()
                }
                .navigationDestination(for: ForeCastWeatherCoordinator.self) { coordinator in
                    coordinator.build()
                }
        }
    }
}

#Preview {
    AppCoordinatorView()
}
