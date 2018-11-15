//
//  RankTableCellV2.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 1/11/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankTableViewCell : UITableViewCell{
    public static let registerID = "rankTableViewCell"
    
    let factor = UIScreen.main.bounds.width/375
    
    var rankViewModel : RankObjectViewModel?{
        didSet{
            let attributes : [NSAttributedString.Key:Any] = [NSAttributedStringKey.font: UIFont.semiBoldFont(CGFloat(fontSize+4)),
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.strokeWidth : -1.0,
                NSAttributedStringKey.strokeColor : ThemeColor().themeWidgetColor()]
            
//            self.nicknameLabel.text = rankViewModel?.nickname ?? ""
//            self.rankNumberLabel.text = rankViewModel?.ranknumberString ?? ""
//            self.rankNumberLabel.text = rankViewModel?.statString ?? ""
            
            self.nicknameLabel.attributedText = NSAttributedString(string: rankViewModel?.nickname ?? "", attributes: attributes)
            self.rankNumberLabel.attributedText = NSAttributedString(string: rankViewModel?.ranknumberString ?? "", attributes: attributes)
            self.statLabel.attributedText = NSAttributedString(string: rankViewModel?.statString ?? "", attributes: attributes)
            configCellBorder()
            configCellMedalIcon()
            configCellColor()
        }
    }
    
    lazy var baseView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8 * factor
        return view
    }()
    
    // this is used to keep shadow while clip the content inside the cell
    lazy var cellContainer : GradientView = {
        let view = GradientView()
        view.layer.cornerRadius = 8 * factor
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.clipsToBounds = true
        return view
    }()
    
    private func configCellColor(){
        if let model = rankViewModel{
            switch model.ranknumber{
            case 1:
                let color1 = ThemeColor().walletCellcolor() + ThemeColor().goldColor() * 0.15
                let color2 = ThemeColor().walletCellcolor()
                cellContainer.gradientLayer.colors = [color1.cgColor,color2.cgColor]
                cellContainer.gradientLayer.gradient = GradientPoint.bottomRightTopLeft.draw()
                rankNumberLabel.layer.backgroundColor = ThemeColor().goldColor().cgColor
                rankNumberLabel.layer.shadowColor = ThemeColor().goldColor().cgColor
                break
            case 2:
                let color1 = ThemeColor().walletCellcolor() + ThemeColor().silverColor() * 0.15
                let color2 = ThemeColor().walletCellcolor()
                cellContainer.gradientLayer.colors = [color1.cgColor,color2.cgColor]
                cellContainer.gradientLayer.gradient = GradientPoint.bottomRightTopLeft.draw()
                rankNumberLabel.layer.backgroundColor = ThemeColor().silverColor().cgColor
                rankNumberLabel.layer.shadowColor = ThemeColor().silverColor().cgColor
                break
            case 3:
                let color1 = ThemeColor().walletCellcolor() + ThemeColor().bronzeColor() * 0.15
                let color2 = ThemeColor().walletCellcolor()
                cellContainer.gradientLayer.colors = [color1.cgColor,color2.cgColor]
                cellContainer.gradientLayer.gradient = GradientPoint.bottomRightTopLeft.draw()
                rankNumberLabel.layer.backgroundColor = ThemeColor().bronzeColor().cgColor
                rankNumberLabel.layer.shadowColor = ThemeColor().bronzeColor().cgColor
                break
            default:
                let color1 = ThemeColor().walletCellcolor() + ThemeColor().themeWidgetColor() * 0.1
                let color2 = ThemeColor().walletCellcolor()
                cellContainer.gradientLayer.colors = [color1.cgColor,color2.cgColor]
                cellContainer.gradientLayer.gradient = GradientPoint.bottomRightTopLeft.draw()
                rankNumberLabel.layer.backgroundColor = ThemeColor().themeWidgetColor().cgColor
            }
        }
    }
    
    private func configCellMedalIcon(){

        
        if let model = rankViewModel{
            switch model.ranknumber{
            case 1:
                medalIcon.image = UIImage(named: "first")
                medalIcon.isHidden = false
                break
            case 2:
                medalIcon.image = UIImage(named: "second")
                medalIcon.isHidden = false
                break
            case 3:
                medalIcon.image = UIImage(named: "third")
                medalIcon.isHidden = false
                break
            default:
                medalIcon.isHidden = true
                break
            }
        }
    }
    
    private func configCellBorder(){
//        view.layer.borderWidth = 3*factor
        if let model = rankViewModel{
            switch model.ranknumber{
                case 1:
//                    view.layer.borderColor = ThemeColor().goldColor().cgColor
                    baseView.layer.shadowColor = ThemeColor().goldColor().cgColor
                    baseView.layer.shadowOpacity = 1
                    baseView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    baseView.layer.shadowRadius = 3 * factor
          
                    break
                case 2:
//                    view.layer.borderColor = ThemeColor().silverColor().cgColor
                    baseView.layer.shadowColor = ThemeColor().silverColor().cgColor
                    baseView.layer.shadowOpacity = 1
                    baseView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    baseView.layer.shadowRadius = 3 * factor
                    break
                case 3:
//                    view.layer.borderColor = ThemeColor().bronzeColor().cgColor
                    baseView.layer.shadowColor = ThemeColor().bronzeColor().cgColor
                    baseView.layer.shadowOpacity = 1
                    baseView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    baseView.layer.shadowRadius = 3 * factor
                    break
                default:
//                    view.layer.borderColor = (ThemeColor().walletCellcolor()*0.8).cgColor
                    baseView.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
                    baseView.layer.shadowOpacity = 1
                    baseView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    baseView.layer.shadowRadius = 3 * factor
                    break
            }

        }else{
            baseView.layer.borderColor = ThemeColor().themeWidgetColor().cgColor
            rankNumberLabel.backgroundColor = ThemeColor().themeWidgetColor()
        }
    }
    
    let medalIcon : UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var rankNumberLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
//        label.textColor = .white
//        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
//        label.text = ""
        label.layer.cornerRadius = 5 * factor
        label.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 1
        label.textAlignment = .center
        return label
    }()
    
    var nicknameLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  2
//        label.textColor = .white
//        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
//        label.text = ""
        return label
    }()
    
    var statLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
//        label.textColor = .white
//        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
//        label.text = ""
        label.textAlignment = .right
        return label
    }()
    
    func setupView(){
        backgroundColor = UIColor.white.withAlphaComponent(0)
        
        addSubview(baseView)
        addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]-\(10*factor)-|", views: baseView)
        addConstraintsWithFormat(format: "V:|-\(3*factor)-[v0]-\(3*factor)-|", views: baseView)
        
        baseView.addSubview(cellContainer)
        baseView.addConstraintsWithFormat(format: "H:|[v0]|", views: cellContainer)
        baseView.addConstraintsWithFormat(format: "V:|[v0]|", views: cellContainer)
        
        cellContainer.addSubview(rankNumberLabel)
        cellContainer.addSubview(nicknameLabel)
        cellContainer.addSubview(statLabel)
        
        cellContainer.addSubview(medalIcon)
        cellContainer.addConstraintsWithFormat(format: "H:[v0]-\(10*factor)-[v1(\(20*factor))]", views: rankNumberLabel,medalIcon)
        medalIcon.centerYAnchor.constraint(equalTo: cellContainer.centerYAnchor).isActive = true
        medalIcon.heightAnchor.constraint(equalToConstant: 20*factor).isActive = true
        
        // center alignment for vertical direction
        addConstraint(NSLayoutConstraint(item: rankNumberLabel, attribute: .centerY, relatedBy: .equal, toItem: cellContainer, attribute: .centerY, multiplier: 1, constant: 0))
//        cellContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: rankNumberLabel)
        addConstraint(NSLayoutConstraint(item: nicknameLabel, attribute: .centerY, relatedBy: .equal, toItem: cellContainer, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: statLabel, attribute: .centerY, relatedBy: .equal, toItem: cellContainer, attribute: .centerY, multiplier: 1, constant: 0))
        
        cellContainer.addConstraintsWithFormat(format: "H:|-\(14*factor)-[v0(\(30*factor))]-(\(40 * factor))-[v1(\(200*factor))]", views: rankNumberLabel,nicknameLabel)
        rankNumberLabel.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        cellContainer.addConstraintsWithFormat(format: "H:[v0(\(100*factor))]-(\(14 * factor))-|", views: statLabel)
    }
}
