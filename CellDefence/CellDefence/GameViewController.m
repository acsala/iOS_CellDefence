//
//  ViewController.m
//  CellDefence
//
//  Created by Attila Csala on 12/9/13.
//  Copyright (c) 2013 Attila Csala. All rights reserved.
//

#import "GameViewController.h"
#import "InGameScene.h"

@implementation GameViewController

- (void) viewWillAppear:(BOOL)animated{
    
}

// prompt the user to log in
- (void) viewDidAppear:(BOOL)animated{

    if (![KiiUser loggedIn]) {
        
        //show a login viewcontroller from KiiToolkit
        KTLoginViewController *loginViewController = [[KTLoginViewController alloc] init];
        
        loginViewController.titleImage.image = [UIImage imageNamed:@"player1"];
        
        KTRegistrationViewController *registrationView = loginViewController.registrationView;
        
        registrationView.titleImage.image = [UIImage imageNamed:@"player1"];
        
        KTForgotPasswordViewController *forgotView = loginViewController.forgotPasswordView;
        
        forgotView.titleImage.image = [UIImage imageNamed:@"player1"];
        
        [self presentViewController:loginViewController animated:TRUE completion:nil];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    InGameScene * scene = [InGameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.parentViewController = self;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
