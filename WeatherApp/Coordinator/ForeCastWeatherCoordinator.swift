
import SwiftUI
import Combine

enum ForeCastWeatherViewRoute {
    case foreCastWeatherHomeView(String)
    case foreCastWeatherOtherScreen
}

final class ForeCastWeatherCoordinator: ObservableObject, Hashable {
    @Published var route: ForeCastWeatherViewRoute
    private var id: UUID
    private var cancellables = Set<AnyCancellable>()
    let pushCoordinator = PassthroughSubject<ForeCastWeatherCoordinator, Never>()
    
    init(route: ForeCastWeatherViewRoute) {
        id = UUID()
        self.route = route
    }
    
    @ViewBuilder
    func build() -> some View {
        switch self.route {
        case .foreCastWeatherHomeView(let city):
            forecastWeatherView(city: city)
        case .foreCastWeatherOtherScreen:
            Text("ForeCast Weather Other Page")
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ForeCastWeatherCoordinator, rhs: ForeCastWeatherCoordinator) -> Bool {
        return lhs.id == rhs.id
    }
    
    private func forecastWeatherView(city:String) -> some View {
        let viewModel = WeatherViewModel(apiService: DataTaskAPIService.shared, city: city)
        let forecastWeatherView = ForecastWeatherView(viewModel:viewModel)
        bind(view: forecastWeatherView)
        return forecastWeatherView
    }
    
    private func bind(view: ForecastWeatherView) {
        view.didClickRoute
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] route in
                switch route {
                case .foreCastWeatherOtherScreen:
                    self?.otherPage(for: route)
                default:
                    break
                }
            })
            .store(in: &cancellables)
    }
}


extension ForeCastWeatherCoordinator {
    private func otherPage(for route: ForeCastWeatherViewRoute) {
        pushCoordinator.send(ForeCastWeatherCoordinator( route: route))
    }
}
