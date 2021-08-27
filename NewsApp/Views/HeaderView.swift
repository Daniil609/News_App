//
//  HeaderView.swift
//  NewsApp
//
//  Created by Tomashchik Daniil on 23/08/2021.
//

import UIKit
class HeaderView: UIView {
    
    private var fontSize:CGFloat
    private lazy var headingLAbel:UILabel={
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "News"
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        return label
    }()
    
    init(fontSize:CGFloat){
        self.fontSize = fontSize
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView()  {
        addSubview(headingLAbel)
        setupConstraints()
    }
    
    func setupConstraints()  {
        NSLayoutConstraint.activate([
            headingLAbel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headingLAbel.topAnchor.constraint(equalTo: topAnchor),
            headingLAbel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headingLAbel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
