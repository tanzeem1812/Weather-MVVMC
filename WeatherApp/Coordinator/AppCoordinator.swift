import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    @Published var path: NavigationPath
    private var cancellables = Set<AnyCancellable>()
    
    init(path: NavigationPath) {
        self.path = path
    }
    
    func build() -> some View {
        homeView()
    }
    
    private func push<T: Hashable>(_ coordinator: T) {
        path.append(coordinator)
    }
    
    private func homeView() -> some View {
        let weatherView = WeatherView()
        bind(view: weatherView)
        return weatherView
    }
    
    private func bind(view: WeatherView) {
        view.didClickHomeViewMenuItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] item in
                switch item {
                case .currentWeather(let city):
                    self?.currentWeatherViewFlow(city)
                case .forecastWeather(let city):
                    self?.foreCastWeatherViewFlow(city)
                }
            })
            .store(in: &cancellables)
    }
    
    private func currentWeatherViewFlow(_ city:String) {
        let coordinator = CurrentWeatherCoordinator(route: .currentWeatherHomeView(city))
        self.bind(coordinator: coordinator)
        self.push(coordinator)
    }
    
    private func foreCastWeatherViewFlow(_ city:String) {
        let coordinator = ForeCastWeatherCoordinator(route: .foreCastWeatherHomeView(city))
        self.bind(coordinator: coordinator)
        self.push(coordinator)
    }
    
    private func bind(coordinator: CurrentWeatherCoordinator) {
        coordinator.pushCoordinator
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinator in
                self?.push(coordinator)
            })
            .store(in: &cancellables)
    }
    
    private func bind(coordinator: ForeCastWeatherCoordinator) {
        coordinator.pushCoordinator
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinator in
                self?.push(coordinator)
            })
            .store(in: &cancellables)
    }
}
