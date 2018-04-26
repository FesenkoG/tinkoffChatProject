//
//  ThemesViewController.m
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 18.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *colorOne = [[UIColor alloc] initWithRed:148.0f/255.0f green:17.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    UIColor *colorTwo = [[UIColor alloc] initWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    UIColor *colorThree = [[UIColor alloc] initWithRed:255.0f/255.0f green:147.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    Themes *model = [[Themes alloc] initWithColorOne: colorOne ColorTwo: colorTwo colorThree: colorThree];
    
    [self setModel:model];
    [model release];
    
}

- (IBAction)changeThemeBtnWasPressed:(UIButton*)sender {
    NSString *title = sender.titleLabel.text;
    
    if ([title isEqualToString:@"Theme 1"]) {
        UIColor *theme1 = [[self getModel] getTheme1];
        
        [self.delegate themesViewController:self didSelectTheme: theme1];
        self.view.backgroundColor = theme1;
        
    } else if ([title isEqualToString:@"Theme 2"]) {
        UIColor *theme2 = [[self getModel] getTheme2];
        
        [self.delegate themesViewController:self didSelectTheme: theme2];
        self.view.backgroundColor = theme2;
    } else if ([title isEqualToString:@"Theme 3"]) {
        UIColor *theme3 = [[self getModel] getTheme3];
        
        [self.delegate themesViewController:self didSelectTheme: theme3];
        self.view.backgroundColor = theme3;
    }
    
}

- (IBAction)backBtnWasPressed:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)dealloc {
    [_model release];
    [super dealloc];
}

@end

