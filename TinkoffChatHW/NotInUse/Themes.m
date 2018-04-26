//
//  Themes.m
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 19.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

#import "Themes.h"

@implementation Themes
-(instancetype) initWithColorOne: (UIColor *) colorOne ColorTwo: (UIColor *) colorTwo colorThree: (UIColor *) colorThree {
    self = [super init];
    if(self) {
        _theme1 = colorOne;
        _theme2 = colorTwo;
        _theme3 = colorThree;
    }
    
    return self;
}
-(void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    
    [super dealloc];
}
@end
