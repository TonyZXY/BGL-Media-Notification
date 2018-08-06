//
//  PullToRefreshKit.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/11.
//  I refer a lot logic for MJRefresh https://github.com/CoderMJLee/MJRefresh ,thanks to this lib and all contributors.
//  Copyright © 2016年 Leo. All rights reserved.

import Foundation
import UIKit
import ObjectiveC

// MARK: - Header API  -

@objc class AttachObject:NSObject{
    init(closure:@escaping ()->()) {
        onDeinit = closure
        super.init()
    }
    var onDeinit:()->()
    deinit {
        onDeinit()
    }
}

@objc public enum RefreshResult:Int{
    case success = 200
    case failure = 400
    case none = 0
}

public enum HeaderRefresherState {
    case refreshing //刷新中
    case normal(RefreshResult,TimeInterval)//正常状态
    case removed //移除
}

public extension UIScrollView{
    public func invalidateRefreshControls(){
        let tags = [PullToRefreshKitConst.headerTag,
                    PullToRefreshKitConst.footerTag,
                    PullToRefreshKitConst.leftTag,
                    PullToRefreshKitConst.rightTag]
        tags.forEach { (tag) in
            let oldContain = self.viewWithTag(tag)
            oldContain?.removeFromSuperview()
        }
    }
    func configAssociatedObject(object:AnyObject){
        guard objc_getAssociatedObject(object, &AssociatedObject.key) == nil else{
            return;
        }
        let attach = AttachObject { [weak self] in
            self?.invalidateRefreshControls()
        }
        objc_setAssociatedObject(object, &AssociatedObject.key, attach, .OBJC_ASSOCIATION_RETAIN)
    }
}

struct AssociatedObject {
    static var key:UInt8 = 0
}

public extension UIScrollView{
    
    public func configRefreshHeader(with refrehser:UIView & RefreshableHeader = DefaultRefreshHeader.header(),
                                    container object: AnyObject,
                                    action:@escaping ()->()){
        let oldContain = self.viewWithTag(PullToRefreshKitConst.headerTag)
        oldContain?.removeFromSuperview()
        let containFrame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
        let containComponent = RefreshHeaderContainer(frame: containFrame)
        if let endDuration = refrehser.durationOfHideAnimation?(){
            containComponent.durationOfEndRefreshing = endDuration
        }
        containComponent.tag = PullToRefreshKitConst.headerTag
        containComponent.refreshAction = action
        self.addSubview(containComponent)
        containComponent.delegate = refrehser
        refrehser.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let refreshHeight = refrehser.heightForHeader()
        let bounds = CGRect(x: 0,y: containFrame.height - refreshHeight,width: self.frame.width,height: refreshHeight)
        refrehser.frame = bounds
        containComponent.addSubview(refrehser)
        configAssociatedObject(object: object)
    }
    
    public func switchRefreshHeader(to state:HeaderRefresherState){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        switch state {
        case .refreshing:
            header?.beginRefreshing()
        case .normal(let result, let delay):
            header?.endRefreshing(result,delay: delay)
        case .removed:
            header?.removeFromSuperview()
        }
    }
}

// MARK: - Footer API  -

public enum FooterRefresherState {
    case refreshing //刷新中
    case normal //正常状态，转换到这个状态会结束刷新
    case noMoreData //没有数据，转换到这个状态会结束刷新
    case removed //移除
}


public extension UIScrollView{
    public func configRefreshFooter(with refrehser:UIView & RefreshableFooter = DefaultRefreshFooter.footer(),
                                    container object: AnyObject,
                                    action:@escaping ()->()){
        let oldContain = self.viewWithTag(PullToRefreshKitConst.footerTag)
        oldContain?.removeFromSuperview()
        let containComponent = RefreshFooterContainer(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: refrehser.heightForFooter()))
        containComponent.tag = PullToRefreshKitConst.footerTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, at: 0)
        containComponent.delegate = refrehser
        refrehser.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        refrehser.frame = containComponent.bounds
        containComponent.addSubview(refrehser)
        configAssociatedObject(object: object)
    }
    
    public func switchRefreshFooter(to state:FooterRefresherState){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        switch state {
            
        case .refreshing:
            footer?.beginRefreshing()
        case .normal:
            footer?.endRefreshing()
            footer?.resetToDefault()
        case .noMoreData:
            footer?.endRefreshing()
            footer?.updateToNoMoreData()
        case .removed:
            footer?.removeFromSuperview()
        }
    }
}


