//
//  TMSViewController.m
//  xplay2
//
//  Created by Kevin Alcock on 4/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//
#import "OAuthConsumer.h"
#import "TMSViewController.h"
#import "TMSPersonViewController.h"
#import "TMSXeroContactTableViewController.h"

/* old key, secret
#define CONSUMER_KEY @"AZQCJOGK74IO6TI1MW56CQ09ILTX6G"
#define CONSUMER_SECRET @"VC8CVODAFW8C0ECYGME5ALFAJKB8GI"
*/

#define CONSUMER_KEY @"3AZPDPKSDGXXSHC2HZF1CQTQ28DIMX"
#define CONSUMER_SECRET @"AYT966EU8AFZV9WK6TNNWJXHQKEM5A"

@interface TMSViewController () 
{
    //OAToken *requestToken;
    OAConsumer *consumer;
    OAToken *accessToken;
    OAMutableURLRequest *request;
    NSMutableString *currentStringValue;
}
@end

@implementation TMSViewController
@synthesize welcomeLabel;
@synthesize instructionLabel;
@synthesize xeroParser;
@synthesize xeroContactButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.welcomeLabel.text = @"";
    if (!accessToken) {
        self.orgButton.hidden = YES;
        self.findPersonButton.hidden = YES;
        self.xeroContactButton.hidden = YES;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) connectToXero:(id)sender
{
    [self getToken];
}

- (void) getToken {
    if (!consumer) {
        consumer = [[OAConsumer alloc] initWithKey:CONSUMER_KEY
                                            secret:CONSUMER_SECRET];
    }
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.xero.com/oauth/RequestToken"];
    
    request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}


- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        NSLog(@"token = %@", accessToken);
        
        NSURL *url = [NSURL URLWithString:@"https://api.xero.com/oauth/Authorize"];
        
        request = [[OAMutableURLRequest alloc] initWithURL:url
                                                   consumer:consumer
                                                      token:accessToken
                                                      realm:nil
                                          signatureProvider:nil];
        
        
        OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                    value:accessToken.key];
        NSArray *params = [NSArray arrayWithObject:p0];
        [request setParameters:params];
        [request prepare];
        
        AuthorizeWebViewController *vc;
        vc = [[AuthorizeWebViewController alloc] initWithNibName:@"AuthorizeWebViewController" bundle:nil];
        vc.delegate = self;
        
        
        [self presentViewController: vc animated:YES completion:^() {
            NSLog(@"completed web view load");
        }];
       
        [vc.webView loadRequest:request];

    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark AuthorizeWebViewControllerDelegate Methods

- (void)successfulAuthorizationWithPin:(NSString *)pin {
    NSLog(@"successfulAuthorizationWithPin:%@", pin);
    OAMutableURLRequest *xrequest;
    OADataFetcher *fetcher;
    
    if (!accessToken) {
        NSLog(@"accessToken is nil");
        return;
    }
    
    NSLog(@"accessToken=%@", accessToken);
    accessToken.verifier = pin;
    
    NSURL *url = [NSURL URLWithString:@"https://api.xero.com/oauth/AccessToken"];
    
    xrequest = [[OAMutableURLRequest alloc] initWithURL:url
                                               consumer:consumer
                                                  token:accessToken
                                                  realm:nil
                                      signatureProvider:nil];
    
    /*
    OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                value:accessToken.key];
    OARequestParameter *p1 = [[OARequestParameter alloc] initWithName:@"oauth_verifier"
                                                                value:pin];
    NSArray *params = [NSArray arrayWithObjects:p0, p1, nil];
    [xrequest setParameters:params];
     */
    [xrequest setHTTPMethod:@"GET"];
    [xrequest prepare];
    
    fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:xrequest
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
    
    
    
    
}

- (void)failedAuthorization {
    NSLog(@"failedAuthorization");
}



- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSLog(@"accessTokenSuccess");
        
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        if (accessToken != nil) {
            //[self.accessToken release];
            accessToken = nil;
        }
        
        NSLog(@"%@", responseBody);
        
        accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        //[responseBody release];
        
        //[self.accessToken storeInUserDefaultsWithServiceProviderName:kAppProviderName
        //                                                      prefix:kAppPrefix];
        
        //[self showOrg:Nil];
        
        self.xeroContactButton.hidden = NO;
        self.findPersonButton.hidden = NO;
        self.instructionLabel.hidden = YES;
        self.connectToXero.hidden = YES;
        
    }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        /*
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
         */
        //NSLog(@"%@", responseBody);
       // [responseBody release];
    }
    
    
}



- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
}


- (IBAction)showXeroContacts:(id)sender {
    TMSXeroContactTableViewController *viewController = [[TMSXeroContactTableViewController alloc] init];
    
    viewController.accessToken = accessToken;
    viewController.consumer = consumer;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (IBAction)findAPerson:(id)sender {
    
    TMSPersonViewController *personViewController = [[TMSPersonViewController alloc] init];
    
    personViewController.accessToken = accessToken;
    personViewController.consumer = consumer;
    
    [self.navigationController pushViewController:personViewController animated:YES];

}

- (IBAction) showOrg:(id)sender {
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    UITabBarItem *peoplePickerTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    picker.tabBarItem = peoplePickerTabBarItem;
    
    TMSXeroContactTableViewController *viewController = [[TMSXeroContactTableViewController alloc] init];
    
    viewController.accessToken = accessToken;
    viewController.consumer = consumer;
    

    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    
   // UINavigationController *nvc = self.navigationController;
    
    
    UIBarButtonItem *uibbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTable)];
    viewController.navigationItem.rightBarButtonItem = uibbiCancel;
    viewController.title = @"Xero";
    UITabBarItem *nvcTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];
    nvc.tabBarItem = nvcTabBarItem;
    UITabBarController *tbc = [[UITabBarController alloc] init];
    NSArray *sections = [[NSArray alloc] initWithObjects:picker, nvc, nil];
    [tbc setViewControllers:sections];
    [self presentViewController:tbc animated:YES completion:Nil];
    
}

- (void) getOrgAndShow {
    NSLog(@"show org");
    
    if (!accessToken) {
        NSLog(@"accessToken is nil");
        return;
    }
    
    if (xeroParser) {
        xeroParser = nil;
    }
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.xero.com/api.xro/2.0/Organisation"];
    OAMutableURLRequest *orequest = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:accessToken
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    /*
    OARequestParameter *nameParam = [[OARequestParameter alloc] initWithName:@"title"
                                                                       value:@"My Page"];
    OARequestParameter *descParam = [[OARequestParameter alloc] initWithName:@"description"
                                                                       value:@"My Page Holds Text"];
    NSArray *params = [NSArray arrayWithObjects:nameParam, descParam, nil];
    [request setParameters:params];
    */
    
    [orequest setParameters:@[]];
    
    [orequest setHTTPMethod:@"GET"];
    
    [orequest prepare];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:orequest
                         delegate:self
                didFinishSelector:@selector(apiOrg:didFinishWithData:)
                  didFailSelector:@selector(apiOrg:didFailWithError:)];
    
}

- (void)apiOrg:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSLog(@"apiOrg Sucess");
        
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", responseBody);
       
        /*
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData: [responseBody dataUsingEncoding: [NSString defaultCStringEncoding] ]];
        
        [parser setDelegate: (id)self];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        
        NSError *parseError = [parser parserError];
        if(parseError) {
 
            NSLog(@"parserError = %@", parseError);
        }
         
     */
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
        
        if (!xeroParser) {
            
            xeroParser = [[XeroParser alloc] initParser: self];
            [xmlParser setDelegate:xeroParser];
        }
        
        [xmlParser parse];
        
        NSLog(@"Organisation count = %d", [xeroParser.response.organisationList count]);
        
        if (xeroParser.response.organisationList) {
            XeroOrganisation *org = xeroParser.response.organisationList[0];
            welcomeLabel.text = org.name;
        }
        
    }
}

- (void)apiOrg:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    NSLog(@"person=%@", person);
    
    //[self showPerson:person];
    
    
    TMSPersonViewController *personViewController = [[TMSPersonViewController alloc] init];
    
    personViewController.myPerson = &person;
    personViewController.accessToken = accessToken;
    personViewController.consumer = consumer;
    
    [self.navigationController pushViewController:personViewController animated:YES];

    
    
    
    
    
	return NO;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
					property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
	return NO;
}




@end
