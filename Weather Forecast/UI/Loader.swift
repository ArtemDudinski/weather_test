import UIKit
import SnapKit

class SimplyLoader {
   
    static let activityIndicatorView: ViewFirstLoader = {
        let v = ViewFirstLoader(frame: CGRect(
                x: UIScreen.main.bounds.size.width / 2.0 - 50.0,
                y: UIScreen.main.bounds.size.height / 2.0 - 50.0,
                width: 100.0,
                height: 100.0))
        v.prepare()

        return v
    }()

    static let mainView: UIView = {
        let result = UIView(frame: UIScreen.main.bounds)
        result.addSubview(SimplyLoader.activityIndicatorView)
        result.backgroundColor = .black.withAlphaComponent(0.15)
        return result
    }()

    static func start() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(mainView)
                activityIndicatorView.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.mainView.alpha = 1.0
                })
            }
        }
    }

    static func stop() {
        DispatchQueue.main.async {
            mainView.alpha = 0.0
            activityIndicatorView.stopAnimating()
            mainView.removeFromSuperview()
        }
    }
}

private struct ViewFirstLoaderConstants {
    static let lineWidth: CGFloat = 6.0
}


class ViewFirstLoader: UIView {
   
    private var isLocked = false
  
    private let shapeLayerMain: CAShapeLayer = {
        let l = CAShapeLayer()
        l.fillColor = UIColor.clear.cgColor
        l.strokeColor = UIColor.clear.cgColor
        l.lineWidth = ViewFirstLoaderConstants.lineWidth
        l.lineCap = CAShapeLayerLineCap.round

        return l
    }()

    private let shapeLayerOver: CAShapeLayer = {
        let l = CAShapeLayer()
        l.strokeColor = UIColor.systemBlue.cgColor
        l.lineWidth = ViewFirstLoaderConstants.lineWidth
        l.fillColor = UIColor.clear.cgColor
        l.lineCap = CAShapeLayerLineCap.round
        l.strokeStart = 0
        l.strokeEnd = 1
        return l
    }()

    private var overStart: CGFloat = 0.0
    private var overEnd: CGFloat = .pi / 6
    private var radius: CGFloat = 0.0
    private var centerPoint: CGPoint = .zero
    private var duration: CGFloat = 5.0

    func work() {
        guard !isLocked else { return }
        prepare()
        startAnimating()
    }

    func prepare() {
        isLocked = true

        radius = bounds.width / 2
        centerPoint = CGPoint(x: bounds.width / 2, y: bounds.height / 2)

        shapeLayerMain.path = UIBezierPath(
                arcCenter: centerPoint,
                radius: radius,
                startAngle: CGFloat(0.0),
                endAngle: CGFloat(Double.pi * 2),
                clockwise: true).cgPath

        shapeLayerOver.path = UIBezierPath(
                arcCenter: centerPoint,
                radius: radius,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true).cgPath

        layer.addSublayer(shapeLayerMain)
        layer.addSublayer(shapeLayerOver)
        shapeLayerOver.frame = bounds
    }

    func startAnimating() {
        UIView.animate(withDuration: 0.3, animations: { [weak self]() -> Void in
            self?.alpha = 1.0
            self?.animateGroup()
        }, completion: { (finished: Bool) -> Void in })
    }

    func stopAnimating() {
        alpha = 0.0
        shapeLayerOver.removeAllAnimations()
    }

    private func animateStrokeEnd() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        return animation
    }

    private func animateStrokeStart() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = CFTimeInterval(duration / 2.0)
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        return animation
    }

    private func animateRotation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = Float.infinity

        return animation
    }

    private func animateGroup() {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animateStrokeEnd(), animateStrokeStart(), animateRotation(), animateColors()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = CAMediaTimingFillMode.both
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = Float.infinity
        shapeLayerOver.add(animationGroup, forKey: "loading")
    }

    private func animateColors() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.duration = CFTimeInterval(duration)
        animation.keyTimes = [0]
        animation.values = [UIColor.systemBlue.cgColor]
        animation.repeatCount = Float.infinity
        return animation
    }
}
