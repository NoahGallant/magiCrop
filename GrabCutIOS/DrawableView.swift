import Foundation
import UIKit

class DrawableView: UIView, UIGestureRecognizerDelegate {
    
    var path=UIBezierPath()
    var previousPoint:CGPoint
    var lineWidth:CGFloat=4.0
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override init(frame: CGRect) {
        previousPoint=CGPoint()
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        previousPoint=CGPoint()
        super.init(coder: aDecoder)!
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.green.setStroke()
        UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15).setFill()
        path.fill()
        path.stroke()
        path.lineWidth=lineWidth
    }
    
    @IBAction func pan(_ gestureRecognizer : UIPanGestureRecognizer) {
        let currentPoint=gestureRecognizer.location(in: self)
        let midPoint=self.midPoint(p0: previousPoint, p1: currentPoint)
        
        if gestureRecognizer.state == .began
        {
            path = UIBezierPath()
            path.move(to: currentPoint)
        }
        else if gestureRecognizer.state == .changed
        {
            path.addQuadCurve(to: midPoint,controlPoint: previousPoint)
        }
        
        previousPoint=currentPoint
        self.setNeedsDisplay()
    }
    
    @IBAction func clear(){
        path = UIBezierPath()
    }
    
    func midPoint(p0:CGPoint,p1:CGPoint)->CGPoint
    {
        let x=(p0.x+p1.x)/2
        let y=(p0.y+p1.y)/2
        return CGPoint(x: x, y: y)
    }
    
}
