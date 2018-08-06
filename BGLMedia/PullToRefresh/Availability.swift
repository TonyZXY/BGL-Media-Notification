//
//  Availability.swift
//  PullToRefreshKit
//
//  Created by Leo on 2017/11/9.
//  Copyright © 2017年 Leo Huang. All rights reserved.
//
import UIKit
import Foundation

public protocol SetUp {}
public extension SetUp where Self: AnyObject {
    @discardableResult
    @available(*, deprecated, message: "This method will be removed at V 1.0.0")
    public func SetUp(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: SetUp {}


//Header
public extension UIScrollView{
    
    @discardableResult
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func setUpHeaderRefresh(_ action:@escaping ()->())->DefaultRefreshHeader{
        let header = DefaultRefreshHeader(frame:CGRect(x: 0,
                                                       y: 0,
                                                       width: self.frame.width,
                                                       height: PullToRefreshKitConst.defaultHeaderHeight))
        return setUpHeaderRefresh(header, action: action)
    }
    @discardableResult
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func setUpHeaderRefresh<T:UIView>(_ header:T,action:@escaping ()->())->T where T:RefreshableHeader{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.headerTag)
        oldContain?.removeFromSuperview()
        let containFrame = CGRect(x: 0, y: -self.frame.height, width: self.frame.width, height: self.frame.height)
        let containComponent = RefreshHeaderContainer(frame: containFrame)
        if let endDuration = header.durationOfHideAnimation?(){
            containComponent.durationOfEndRefreshing = endDuration
        }
        containComponent.tag = PullToRefreshKitConst.headerTag
        containComponent.refreshAction = action
        self.addSubview(containComponent)
        
        containComponent.delegate = header
        header.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let bounds = CGRect(x: 0,y: containFrame.height - header.frame.height,width: self.frame.width,height: header.frame.height)
        header.frame = bounds
        containComponent.addSubview(header)
        return header
    }
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
//    public func beginHeaderRefreshing(){
//        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
//        header?.beginRefreshing()
//    }
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public  func endHeaderRefreshing(_ result:RefreshResult = .none,delay:Double = 0.0){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.endRefreshing(result,delay: delay)
    }
}

//Footer
public extension UIScrollView{
    @discardableResult
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func setUpFooterRefresh(_ action:@escaping ()->())->DefaultRefreshFooter{
        let footer = DefaultRefreshFooter(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: self.frame.width,
                                                        height: PullToRefreshKitConst.defaultFooterHeight))
        return setUpFooterRefresh(footer, action: action)
    }
    @discardableResult
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func setUpFooterRefresh<T:UIView>(_ footer:T,action:@escaping ()->())->T where T:RefreshableFooter{
        let oldContain = self.viewWithTag(PullToRefreshKitConst.footerTag)
        oldContain?.removeFromSuperview()
        let frame = CGRect(x: 0,y: 0,width: self.frame.width, height: PullToRefreshKitConst.defaultFooterHeight)
        
        let containComponent = RefreshFooterContainer(frame: frame)
        containComponent.tag = PullToRefreshKitConst.footerTag
        containComponent.refreshAction = action
        self.insertSubview(containComponent, at: 0)
        
        containComponent.delegate = footer
        footer.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        footer.frame = containComponent.bounds
        containComponent.addSubview(footer)
        return footer
    }
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func beginFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        if footer?.state == .idle {
            footer?.beginRefreshing()
        }
    }
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func endFooterRefreshing(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func setFooterNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
    }
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public func resetFooterToDefault(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.resetToDefault()
    }
    @available(*, deprecated, message: "Use new API at PullToRefresh.Swift")
    public  func endFooterRefreshingWithNoMoreData(){
        let footer = self.viewWithTag(PullToRefreshKitConst.footerTag) as? RefreshFooterContainer
        footer?.endRefreshing()
        footer?.updateToNoMoreData()
    }
}




