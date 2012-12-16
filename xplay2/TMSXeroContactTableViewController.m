//
//  TMSXeroContactTableViewController.m
//  xplay2
//
//  Created by Kevin Alcock on 15/12/12.
//  Copyright (c) 2012 Kevin Alcock. All rights reserved.
//

#import "TMSXeroContactTableViewController.h"



@interface TMSXeroContactTableViewController ()

@end



@implementation TMSXeroContactTableViewController

@synthesize contactList;
@synthesize consumer;
@synthesize accessToken;
@synthesize xeroParser;
@synthesize contact;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self getXeroContacts];
    //[self.tableView reloadData];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    //refreshControl.tintColor = [UIColormagentaColor];
    [refreshControl addTarget: self action:@selector(changeSorting) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return xeroParser.contactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    contact = [xeroParser.contactList objectAtIndex: indexPath.row];
    cell.textLabel.text = contact.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) getXeroContacts {
    
    if (!self.contactList) {
        self.contactList = [[NSMutableArray alloc] init];
    } else {
        [self.contactList removeAllObjects];
    }

    
    if (!accessToken) {
        NSLog(@"accessToken is nil");
        return;
    }
    
    if (xeroParser) {
        xeroParser = nil;
    }
        
    NSURL *url = [NSURL URLWithString:@"https://api.xero.com/api.xro/2.0/Contacts"];
    OAMutableURLRequest *orequest = [[OAMutableURLRequest alloc] initWithURL:url
                                                                        consumer:consumer
                                                                           token:accessToken
                                                                           realm:nil
                                                               signatureProvider:nil];
        
        
    [orequest setParameters:@[]];
        
    [orequest setHTTPMethod:@"GET"];
        
    [orequest prepare];
        
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:orequest
                         delegate:self
                didFinishSelector:@selector(apiContact:didFinishWithData:)
                  didFailSelector:@selector(apiContact:didFailWithError:)];

    
}


- (void)apiContact:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSLog(@"apiContact Sucess");
        
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", responseBody);
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
        
        if (!xeroParser) {
        
            xeroParser = [[XeroParser alloc] initParser: self];
            [xmlParser setDelegate:xeroParser];
        }
        
        
        
        
        [xmlParser parse];
        
        NSLog(@"Contact count = %d", [xeroParser.contactList count]);
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        
    }
}

- (void)apiContact:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


- (void) changeSorting {
    
    [self getXeroContacts];
    
    
    
}

@end
