//
//  ThemesViewControllerDelegate.h
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 19.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>
-(void)themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;
@end
