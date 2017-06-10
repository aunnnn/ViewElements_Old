//
//  MediumArticleViewController+Components.swift
//  TryViewElements
//
//  Created by Wirawit Rueopas on 5/31/2560 BE.
//  Copyright © 2560 Wirawit Rueopas. All rights reserved.
//

import ViewElements

struct MediumArticleUserInfo {
    let img: UIImage
    let name: String
    let detail: String?
    let dateAndReadTime: String
    let hr: HeartsAndResponses
}

typealias HeartsAndResponses = (Int, Int)
typealias EntityModel = (UIImage, String, String, String)

enum MediumArticleComponent {
    
    static func Image(img: UIImage) -> ElementOfView {
        return ElementOfImageView(props: img).styles { (imv) in
            imv.al_aspectRatio(ofImage: img)
            imv.contentMode = .scaleAspectFill
        }
    }
    
    static func Title(s: String) -> ElementOfView {
        return ElementOfLabel(props: s).styles { (lb) in
            lb.font = UIFont.boldSystemFont(ofSize: 26)
        }
    }
    
    static func Header(s: String) -> ElementOfView {
        return ElementOfLabel(props: s).styles({ (lb) in
            lb.font = UIFont.boldSystemFont(ofSize: 24)
        })
    }
    
    static func Paragraph(s: String, italic: Bool) -> ElementOfView {
        return ElementOfLabel(props: s).styles({ (lb) in
            lb.font = italic ? UIFont.italicSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 18)
        })
    }
    
    static func OuterSectionHeader(s: String) -> ElementOfView {
        return ElementOfLabel(props: s).styles({ (lb) in
            lb.textColor = .gray
            lb.font = UIFont.systemFont(ofSize: 15)
        })
    }
    
    class AuthorInfo: ComponentOf<MediumArticleUserInfo> {
        override func shouldElementUpdate(oldProps: MediumArticleUserInfo, newProps: MediumArticleUserInfo) -> Bool {
            return oldProps.name != newProps.name
        }
        
        override func render() -> StackProps {
            let elImv = ElementOfImageView(props: props.img).styles { (imv) in
                imv.al_fixedSize(width: 40, height: 40)
                imv.cornerRadius(20)
            }
            
            let lbStyle: (Label) -> Void = { lb in
                lb.textColor = .gray
                lb.font = UIFont.systemFont(ofSize: 12)
                lb.numberOfLines = 2
            }
            
            let elAuthor = ElementOfLabel(props: props.name).styles { (lb) in
                lb.textColor = MediumTheme.green
                lb.font = UIFont.systemFont(ofSize: 14)
            }
            
            let elDetail = ElementOfLabel(props: props.detail ?? "").styles(lbStyle)
            let elDate = ElementOfLabel(props: props.dateAndReadTime).styles(lbStyle)
            let elFollowButton = ElementOfButton(props: "Follow").styles { (bttn) in
                bttn.setTitleColor(MediumTheme.green, for: .normal)
                bttn.setTitleColor(MediumTheme.green.withAlphaComponent(0.6), for: .highlighted)
                bttn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                bttn.cornerRadius(4).border(width: 1, color: MediumTheme.green)
                bttn.al_fixedWidth(width: 88)
            }
            return
                HorizontalStack(
                    distribute: .fill,
                    align: .top,
                    spacing: 8, [
                        elImv,
                        VerticalStack(
                            distribute: .fill,
                            align: .leading,
                            spacing: 4, [
                                elAuthor,
                                elDetail,
                                elDate,
                                ]),
                        elFollowButton,
                        ])
        }
    }
    
    class ActionPanel: ComponentOf<HeartsAndResponses> {
        override func shouldElementUpdate(oldProps: HeartsAndResponses, newProps: HeartsAndResponses) -> Bool {
            return oldProps != newProps
        }
        
        override func render() -> StackProps {
            let s1: (Button) -> Void = { bttn in
                bttn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                bttn.setTitleColor(.darkGray, for: .normal)
            }
            let elHeart = ElementOfButton(props: "Heart").styles(s1)
            let elShare = ElementOfButton(props: "Share").styles(s1)
            let elBookmark = ElementOfButton(props: "Bookmark").styles(s1)
            
            
            let s2: (Button) -> Void = { bttn in
                bttn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                bttn.setTitleColor(.gray, for: .normal)
            }
            let elHeartCount = ElementOfButton(props: "H \(self.props.0)").styles(s2)
            let elResponseCount = ElementOfButton(props: "R \(self.props.1)").styles(s2)
            
            return HorizontalStack(
                distribute: .fill,
                align: .center,
                spacing: 8, [
                    elHeart,
                    elShare,
                    elBookmark,
                    FlexibleSpace(),
                    elHeartCount,
                    elResponseCount,
                    ])
        }
    }
    
    class EntityDetail: ComponentOf<EntityModel> {
        override func shouldElementUpdate(oldProps: EntityModel, newProps: EntityModel) -> Bool {
            return oldProps != newProps
        }
        
        override func render() -> StackProps {
            let elImg = ElementOfImageView(props: self.props.0).styles { (imv) in
                imv.al_fixedSize(width: 60, height: 60)
                imv.cornerRadius(30)
            }
            
            let elTitle = ElementOfLabel(props: self.props.1).styles { (lb) in
                lb.font = UIFont.boldSystemFont(ofSize: 12)
                lb.textColor = .gray
            }
            
            let elAuthor = ElementOfLabel(props: self.props.2).styles { (lb) in
                lb.font = UIFont.systemFont(ofSize: 16)
                lb.textColor = .black
            }
            
            let elDetail = ElementOfLabel(props: self.props.3).styles { (lb) in
                lb.font = UIFont.systemFont(ofSize: 14)
                lb.textColor = .gray
            }
            
            let elFollowButton = ElementOfButton(props: "Follow").styles { (bttn) in
                bttn.setTitleColor(MediumTheme.green, for: .normal)
                bttn.setTitleColor(MediumTheme.green.withAlphaComponent(0.6), for: .highlighted)
                bttn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                bttn.cornerRadius(4).border(width: 1, color: MediumTheme.green)
                bttn.al_fixedWidth(width: 100)
            }
            
            return HorizontalStack.init(
                distribute: .fill,
                align: .top,
                spacing: 12, [
                    elImg,
                    VerticalStack.init(
                        distribute: .fill,
                        align: .leading,
                        spacing: 4, [
                            elTitle,
                            elAuthor,
                            elDetail,
                            elFollowButton,
                            ])
                ])
        }
    }
}
