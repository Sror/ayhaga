//
//  BookmarkViewController.m
//  AePubReader
//
//  Created by Ahmed Aly on 8/7/12.
//
//

#import "BookmarkViewController.h"
#import "Constants.h"
@interface BookmarkViewController ()

@end

@implementation BookmarkViewController
@synthesize epubViewController,tableData,indexData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(400, 600);
    self.title=@"المؤشرات";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textAlignment=UITextAlignmentRight;
    if ([[[tableData objectAtIndex:indexPath.row] objectForKey:CHAPTER_KEY] intValue]== 0) {
        cell.textLabel.text =[NSString stringWithFormat:@"غلاف الكتاب"];
    }else if ([[[tableData objectAtIndex:indexPath.row] objectForKey:CHAPTER_KEY] intValue]== 1) {
        cell.textLabel.text =[NSString stringWithFormat:@"العنوان"];
    }else if ([[[tableData objectAtIndex:indexPath.row] objectForKey:CHAPTER_KEY] intValue]== 2) {
        cell.textLabel.text =[NSString stringWithFormat:@"صفحة التعريف"];
    }else if ([[[tableData objectAtIndex:indexPath.row] objectForKey:CHAPTER_KEY] intValue]== 3) {
        cell.textLabel.text =[NSString stringWithFormat:@"حقوق الملكية"];
    }else{
        cell.textLabel.text =[NSString stringWithFormat:@"%@- صفحة %d",[[[indexData objectAtIndex:[[[tableData objectAtIndex:indexPath.row] objectForKey:CHAPTER_KEY] intValue]-4] objectForKey:@"navLabel"] objectForKey:@"text"],[[[tableData objectAtIndex:indexPath.row] objectForKey:TOTAL_NUMBER] intValue]+1];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [epubViewController loadSpine:[[[tableData objectAtIndex:indexPath.row] objectForKey:CHAPTER_KEY] intValue] atPageIndex:[[[tableData objectAtIndex:indexPath.row] objectForKey:PAGE_KEY] intValue] WithFontSize:[[[tableData objectAtIndex:indexPath.row] objectForKey:FONT_SIZE] intValue] ];
}

@end
