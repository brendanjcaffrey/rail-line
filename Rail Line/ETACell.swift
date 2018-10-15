import UIKit

class ETACell: UITableViewCell {
    private let colorBlock = UIView()
    private let destinationLabel = UILabel()
    private let timeLabel = UILabel()

    private static let cellHeight = 44
    private static let colorSpacing = 1
    private static let colorHeight = cellHeight - colorSpacing
    private static let colorWidth = 20
    private static let spacing = 8
    private static let fontSize = 24.0 as CGFloat

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(colorBlock)
        addSubview(destinationLabel)
        addSubview(timeLabel)

        colorBlock.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.width.equalTo(ETACell.colorWidth)
            make.height.equalTo(ETACell.colorHeight)
            make.left.equalTo(self.snp.left)
        }
        destinationLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(ETACell.cellHeight)
            make.left.equalTo(colorBlock.snp.right).offset(ETACell.spacing)
        }
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(ETACell.cellHeight)
            make.right.equalTo(self.snp.right).offset(-1 * ETACell.spacing)
            make.left.equalTo(destinationLabel.snp.right)
        }

        destinationLabel.font = UIFont.systemFont(ofSize: ETACell.fontSize)
        timeLabel.font = UIFont.systemFont(ofSize: ETACell.fontSize)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(eta: ETA) {
        let color = Routes.mapColor(eta.getRoute())
        colorBlock.backgroundColor = color
        destinationLabel.text = eta.getDestination()
        destinationLabel.textColor = color
        timeLabel.text = eta.getTimeString()
        timeLabel.textColor = color
    }
}
