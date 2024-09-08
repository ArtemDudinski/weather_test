import UIKit

class ForecastCell: UITableViewCell {

    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    private var onChangeValueBlock: ((Int)->())?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        selectionStyle = .none
        
        addSubview(firstLabel)
        firstLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8.scalable)
            $0.bottom.equalToSuperview().offset(8.scalable)
            $0.left.equalToSuperview().offset(24)
        }
        
        addSubview(secondLabel)
        secondLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    func configure(item: ForecastTableViewDataSource) {
        switch item {
        case .firstCell(let dateTitle, let temperatureTitle):
            firstLabel.text = dateTitle
            firstLabel.font = .boldSystemFont(ofSize: 16.scalable)
            
            secondLabel.text = temperatureTitle
            secondLabel.font = .boldSystemFont(ofSize: 16.scalable)
        case .valueCell(let dateValue, let temperatureValue):
            firstLabel.text = dateValue
            firstLabel.font = .systemFont(ofSize: 14.scalable)
            
            secondLabel.text = "\(temperatureValue)°C"
            secondLabel.font = .systemFont(ofSize: 14.scalable)
        }
    }
}
