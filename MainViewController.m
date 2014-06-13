//
//  MainViewController.m
//  SearchPhoneNumber
//
//  Created by Hieu Nguyen Thi Trung on 6/13/14.
//
//

#import "MainViewController.h"
#import "NBPhoneNumberUtil.h"
#import "CountryPicker.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "NBPhoneNumber.h"

@interface MainViewController ()<CountryPickerDelegate>{
    NBPhoneNumberUtil *phoneUtil;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        phoneUtil = [NBPhoneNumberUtil sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNumber *countryCallingCode = [phoneUtil getCountryCodeForRegion:countryPicker.selectedCountryCode];
    numberTextField.placeholder = [NSString stringWithFormat:@"+ %@",countryCallingCode];
    
    contentWebView.backgroundColor = [UIColor clearColor];
    contentWebView.opaque = NO;
    contentWebView.userInteractionEnabled = YES;
    
    //clean the webview otherwise we have border !!
    for(UIView * wview in [[[contentWebView subviews] objectAtIndex:0] subviews])
    {
        if([wview isKindOfClass:[UIImageView class]])
        {
            wview.hidden = YES;
        }
    }
    [[[contentWebView subviews] lastObject] setScrollEnabled:YES];
    //NSLog(@"%@,%@",countryCallingCode,countryPicker.selectedCountryCode);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searching{
    [numberTextField resignFirstResponder];
    NSError *error = nil;
    NBPhoneNumber *phoneNumber = [phoneUtil parse:numberTextField.text defaultRegion:@"US" error:&error];
    NSString * html = [NSString stringWithFormat:@
                     "<html><body style=\"background-color:transparent\"><div ALIGN=left style=\"font-family:Arial;font-size:17px;color:black;-webkit-user-select:none\">"
                     "<br/><b>The number is valid : %@</b>"
                     "<br/><b>The number is posible number : %@</b>"
                     "<br/><b>The region code of number is %@</b>"
                     "</div></body></html>", [phoneUtil isValidNumber:phoneNumber] ? @"YES":@"NO", [phoneUtil isPossibleNumber:phoneNumber error:&error] ? @"YES" : @"NO", [phoneUtil getRegionCodeForNumber:phoneNumber]];
    
    [contentWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    [countryPicker setSelectedCountryCode:[phoneUtil getRegionCodeForNumber:phoneNumber] animated:YES];
  
}

- (void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code{
    NSLog(@"- getRegionCodeForNumber [%@,%@]", name, code);
    NSNumber *countryCallingCode = [phoneUtil getCountryCodeForRegion:code];
    numberTextField.placeholder = [NSString stringWithFormat:@"+ %@",countryCallingCode];
    numberTextField.text = @"";
    [contentWebView loadHTMLString:@"" baseURL:nil];
}
@end
