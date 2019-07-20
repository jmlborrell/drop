//
//  LibraryViewController.swift
//  drop
//
//  Created by Jose Borrell on 2019-05-25.
//  Copyright © 2019 Jose Borrell. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class LibraryViewController : UIViewController {
    
    let viewControllers = [UIViewController(),SongViewController(), UIViewController()]
    let nowPlayingController = NowPlayingMinimizedViewController()
    let disposeBag = DisposeBag()
    let header : UILabel = UILabel(frame: CGRect(x: 16, y: 65, width: 150, height: 40))
    let tabScroll = UIScrollView(frame: CGRect(x: 16, y: 120, width: 343, height: 40))
    let gradient : CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        gradient.colors = [UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1).cgColor,UIColor(red: 175/255, green: 82/255, blue: 222/255, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.cornerRadius = 5.0
        
        gradient.shadowColor = UIColor.black.cgColor
        gradient.shadowRadius = 5
        gradient.shadowOffset = CGSize(width: 0, height: 0)
        gradient.shadowOpacity = 0.2
        
        return gradient
    }()
    
    var buttons : [UIButton] = []
    var prevSelectedButton : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButtons()
        
        tabScroll.alwaysBounceHorizontal = true
        tabScroll.showsHorizontalScrollIndicator = false
        tabScroll.isScrollEnabled = true
        tabScroll.contentSize = CGSize(width: 555,height: tabScroll.frame.size.height)
        
        for button in buttons {
            tabScroll.addSubview(button)
        }
        
        self.view.addSubview(tabScroll)
        
        attachViewController(controller: viewControllers[0])
        
        (viewControllers[1] as! SongViewController).update.subscribe(onNext: { song in
            self.nowPlayingController.update()
        }).disposed(by: disposeBag)
        
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .white
        
        header.text = "Library"
        header.font = UIFont.boldSystemFont(ofSize: 34)
        self.view.addSubview(header)
        
        self.addChild(nowPlayingController)
        self.view.addSubview(nowPlayingController.view)
        nowPlayingController.didMove(toParent: self)
        
        nowPlayingController.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_leftMargin).offset(0)
            make.right.equalTo(self.view.snp_rightMargin).offset(0)
            make.top.equalTo(self.view.snp_topMargin).offset(657)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-34)
        }
    }
    
    func configureNavigationButtons() {
        let titles : [String] = ["Recent","Songs","Albums","Playlists","Artists","Genres","Podcasts"]
        
        var x = 0.0
        
        for title in titles {
            
            let button : UIButton = UIButton(frame: CGRect(x: x, y: 0, width: 80, height: 40))
            
            button.setTitle(title, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.layer.cornerRadius = 5.0
            button.layer.borderWidth = 1.0
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            
            button.animateWhenPressed(disposeBag: self.disposeBag)
            button.rx.tap.subscribe { _ in
                self.buttons[self.prevSelectedButton].layer.borderWidth = 1.0
                self.buttons[self.prevSelectedButton].isSelected = false
                self.gradient.removeFromSuperlayer()
                button.isSelected = true
                button.layer.borderWidth = 0.0
                button.layer.insertSublayer(self.gradient, at: 0)
                let next : Int = self.buttons.firstIndex(of: button)!
                self.changeViewControllers(from: self.prevSelectedButton, to: next)
                self.prevSelectedButton = next
                }.disposed(by: disposeBag)
            
            buttons.append(button)
            
            x += 95
        }
        
        buttons[0].isSelected = true
        buttons[0].layer.borderWidth = 0.0
        buttons[0].layer.insertSublayer(self.gradient, at: 0)
    }
    
    func changeViewControllers(from: Int, to: Int) {
        let prevViewController = self.viewControllers[from]
        removeViewController(controller: prevViewController)
        
        let nextViewController = self.viewControllers[to]
        attachViewController(controller: nextViewController)
        
    }
    
    func removeViewController(controller : UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    func attachViewController(controller : UIViewController) {
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        controller.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view.snp_leftMargin).offset(-16)
            make.right.equalTo(self.view.snp_rightMargin).offset(16)
            make.top.equalTo(self.view.snp_topMargin).offset(133)
            make.bottom.equalTo(self.view.snp_bottomMargin).offset(-95)
        }
    }
}

extension UIButton {
    
    func animateWhenPressed(disposeBag: DisposeBag) {
        let pressDownTransform = rx.controlEvent([.touchDown, .touchDragEnter])
            .map({ CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) })
        
        let pressUpTransform = rx.controlEvent([.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
            .map({ CGAffineTransform.identity })
        
        Observable.merge(pressDownTransform, pressUpTransform)
            .distinctUntilChanged()
            .subscribe(onNext: animate(_:))
            .disposed(by: disposeBag)
    }
    
    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        self.transform = transform
        }, completion: nil)
    }
    
}
