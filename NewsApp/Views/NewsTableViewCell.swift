
import Foundation
import UIKit

class NewsTableViewCell:UITableViewCell{
    
    let showMoreText = "Show more"
    var newsVM : NewsViewModel?{
        didSet{
            if let newsVM = newsVM{
                let boldAttribute = [
                    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!
                   ]
                let boldText = NSAttributedString(string: newsVM.title,attributes: boldAttribute)
                titleLabel.attributedText = boldText
                descriptionLabel.font.withSize(15)
                descriptionLabel.text = newsVM.description
                if newsVM.description.count * 15  > Int(UIScreen.main.bounds.width) * descriptionLabel.numberOfLines * 2 {
                    showLabel.textColor = .blue
                }else{
                    showLabel.textColor = .clear
                }
                APICaller.shared.getImage(urlString: newsVM.urlToImage) { data in
                    guard let data = data else{return}
                    DispatchQueue.main.async {
                        self.newsImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    var newsImageData:Data?{
        didSet{
            if let data = newsImageData{
                newsImage.image = UIImage(data: data)
            }
        }
    }
    
    private lazy var newsImage:ShadowImageView={
        let shadowView = ShadowImageView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        return shadowView
    }()
    
    private lazy var titleLabel:UILabel={
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel:UILabel={
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var showLabel:UILabel={
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = showMoreText
        label.textColor = .blue
        return label
    }()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView()  {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(newsImage)
        addSubview(showLabel)
        setupConstraints()
    }
    
    func setupConstraints()  {
        NSLayoutConstraint.activate([
            newsImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImage.topAnchor.constraint(equalTo:  topAnchor),
            newsImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            titleLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor,constant: -150),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor,constant: 80),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            showLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            showLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            showLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor,constant: 140),
            showLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -20)
        ])
    }
}
