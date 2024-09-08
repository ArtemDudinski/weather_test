import UIKit

class TabBarItemFactory {
    
    static var mainItem: UITabBarItem {
        let image = UIImage(systemName: "house.fill")
        
        return .init(
            title: "Main",
            image: image,
            tag: 0
        )
    }
    
    static var forecsstItem: UITabBarItem {
        let image = UIImage(systemName: "table")
        
        return .init(
            title: "Forecast",
            image: image,
            tag: 0
        )
    }
}
