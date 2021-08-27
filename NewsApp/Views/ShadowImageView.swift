import UIKit
final class ShadowImageView:UIView{
    
    var image:UIImage?{
        didSet{
            imageView.image = image
        }
    }
    private lazy var imageView:UIImageView={
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var baseView:UIView={
        let baseView = UIView()
        baseView.layer.masksToBounds = false
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.5
        baseView.layer.shadowOffset = CGSize(width: 5, height: 5)
        baseView.layer.cornerRadius = 20
        return baseView
    }()
    
    init(){
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView()  {
        addSubview(baseView)
        baseView.addSubview(imageView)
        setupConstraints()
    }
    
    func setupConstraints()  {
        [baseView,imageView].forEach { view in
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
                view.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
                view.topAnchor.constraint(equalTo: topAnchor,constant: 16),
                view.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -16)
            ])
           
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.layer.shadowPath = UIBezierPath(roundedRect: baseView.bounds,cornerRadius: 10).cgPath
        baseView.layer.shouldRasterize = true
        baseView.layer.rasterizationScale = UIScreen.main.scale
    }
}
