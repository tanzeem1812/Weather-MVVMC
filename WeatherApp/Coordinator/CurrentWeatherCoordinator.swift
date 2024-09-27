
import SwiftUI
import Combine

enum CurrentWeatherViewRoute {
    case currentWeatherHomeView(String)
    case currentWeatherOtherScreen
}

final class CurrentWeatherCoordinator: ObservableObject, Hashable {
    @Published var route: CurrentWeatherViewRoute
    private var id: UUID
    private var cancellables = Set<AnyCancellable>()
    let pushCoordinator = PassthroughSubject<CurrentWeatherCoordinator, Never>()
    
    init(route: CurrentWeatherViewRoute) {
        id = UUID()
        self.route = route
    }
    
    @ViewBuilder
    func build() -> some View {
        switch self.route {
        case .currentWeatherHomeView(let city):
            currentWeatherView(city: city)
        case .currentWeatherOtherScreen:
            Text("Current Weather Other Page")
        }
    }
    
    // MARK: Required methods for class to conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CurrentWeatherCoordinator, rhs: CurrentWeatherCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    private func currentWeatherView(city:String) -> some View {
        let viewModel = WeatherViewModel(apiService: DataTaskAPIService.shared, city: city)
        let currentWeatherView = CurrentWeatherView(viewModel:viewModel)
        bind(view: currentWeatherView)
        return currentWeatherView
    }
    
    // MARK: View Bindings
    private func bind(view: CurrentWeatherView) {
        view.didClickRoute
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] route in
                switch route {
                case .currentWeatherOtherScreen:
                    self?.otherPage(for: route)
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
}

extension CurrentWeatherCoordinator {
    private func otherPage(for route: CurrentWeatherViewRoute) {
        pushCoordinator.send(CurrentWeatherCoordinator(route: route))
    }
}
