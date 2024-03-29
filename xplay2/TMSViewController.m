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
@synthesize xeroParser;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.welcomeLabel.text = @"";
    
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
        
        [self presentViewController: vc animated:YES completion:nil];
        //[self presentViewController:pNewController animated:YES completion:nil];
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



@end
