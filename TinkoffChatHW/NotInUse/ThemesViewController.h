//
//  ThemesViewController.h
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 18.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

@interface ThemesViewController : UIViewController

@property (assign, getter = getDelegate, setter = setDelegate:) id<ThemesViewControllerDelegate> delegate;
@property (retain, getter = getModel, setter=setModel:) Themes* model;
-(void)dealloc;
@end
