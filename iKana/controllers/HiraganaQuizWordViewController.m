//
//  HiraganaQuizWordViewController.m
//  iKana
//
//  Created by Zian ZHOU on 2013-05-19.
//  Copyright (c) 2013 Zian ZHOU. All rights reserved.
//

#import "HiraganaQuizWordViewController.h"

@interface HiraganaQuizWordViewController ()

@end

@implementation HiraganaQuizWordViewController
{
    NSString *romaji;
    IBOutlet UILabel *romajiLabel;
    IBOutlet UIButton *showRomajiBtn;
    NSInteger attemptTimes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRomaji:(NSString *)Romaji
{
    if (self = [super init])
    {
        romaji = Romaji;
        romajiLabel.text = Romaji;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    romajiLabel.text = romaji;
    romajiLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideRomaji
{
    romajiLabel.hidden = YES;
    [showRomajiBtn setTitle:@"Show Romaji" forState:UIControlStateNormal];
}

- (IBAction)showRomajiPressed:(id)sender
{
    if (romajiLabel.isHidden)
    {
        romajiLabel.hidden = NO;
        [showRomajiBtn setTitle:@"Hide Romaji" forState:UIControlStateNormal];
    }
    else
    {
        romajiLabel.hidden = YES;
        [showRomajiBtn setTitle:@"Show Romaji" forState:UIControlStateNormal];
    }
}

- (IBAction)testMePressed:(id)sender
{
    if (!romajiLabel.isHidden)
    {
        romajiLabel.hidden = YES;
        [showRomajiBtn setTitle:@"Show Romaji" forState:UIControlStateNormal];
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Test!"
                                                      message:@"Please enter the correspond romaji"
                                                     delegate:self
                                            cancelButtonTitle:@"I don't know"
                                            otherButtonTitles:@"OK",nil];
    message.alertViewStyle = UIAlertViewStylePlainTextInput;
    attemptTimes = 0;
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        UITextField *romajiInput = [alertView textFieldAtIndex:0];
        if ([[romajiInput.text lowercaseString] isEqualToString:romaji])
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Correct!"
                                                              message:nil
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        else
        {
            attemptTimes++;
            
            if (attemptTimes >= 3)
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"You need try to remember first!"
                                                                  message:nil
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [message show];
                return;
            }
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Would you like try again?"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"NO"
                                                    otherButtonTitles:@"OK",nil];
            message.alertViewStyle = UIAlertViewStylePlainTextInput;
            [message show];
        }
        
    }
    else if([title isEqualToString:@"I don't know"])
    {
        romajiLabel.hidden = NO;
        [showRomajiBtn setTitle:@"Hide Romaji" forState:UIControlStateNormal];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)viewDidUnload {
    [self setHiraganaImageView:nil];
    [self setHiraganaImageView:nil];
    romajiLabel = nil;
    showRomajiBtn = nil;
    [super viewDidUnload];
}
@end
