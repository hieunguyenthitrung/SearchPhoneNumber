//
//  MainViewController.h
//  SearchPhoneNumber
//
//  Created by Hieu Nguyen Thi Trung on 6/13/14.
//
//

#import <UIKit/UIKit.h>

@class CountryPicker;
@interface MainViewController : UIViewController
{
    IBOutlet UITextField * numberTextField;
    IBOutlet UIWebView * contentWebView;
    IBOutlet CountryPicker * countryPicker;
}

- (IBAction)searching;
@end
