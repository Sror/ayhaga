

#import "SearchResultsViewController.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"
#import "Constants.h"

@interface SearchResultsViewController()

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index;

@end


@implementation SearchResultsViewController
@synthesize activityIndicator,moreTweetActivityIndicator;

@synthesize resultsTableView, epubViewController, currentQuery, results;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListCustomCell" owner:self options:nil] objectAtIndex:0];
    }
	
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *metaDataLabel = (UILabel *)[cell viewWithTag:2];
    
    SearchResult* hit=nil;
    if (indexPath.row < [results count]){
        hit = (SearchResult*)[results objectAtIndex:[indexPath row]];
        contentLabel.text = [NSString stringWithFormat:@"%@", hit.neighboringText];
        metaDataLabel.text = [NSString stringWithFormat:@"الفصل %d - صفحة %d", hit.chapterIndex, hit.pageIndex+1];
    }else{
        if ([results count]>0) {
          
            if ((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count]) 
                 contentLabel.text = [NSString stringWithFormat:@"أضغط للمزيد من النتائج"];
            else
                contentLabel.text = [NSString stringWithFormat:@"لا يوجد نتائج أخري"];
            contentLabel.textColor=[UIColor blueColor];
            contentLabel.font=[UIFont boldSystemFontOfSize:18];
            contentLabel.textAlignment=NSTextAlignmentCenter;
        }
    }
    
    // cell.textLabel.textAlignment=UITextAlignmentRight;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([results count] == 0) {
        return 0;
    }else  if((currentChapterIndex)>[epubViewController.loadedEpub.spineArray count]){
        return [results count];
    }
    return [results count]+1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [results count]){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        SearchResult* hit = (SearchResult*)[results objectAtIndex:[indexPath row]];
        [epubViewController loadSpine:hit.chapterIndex atPageIndex:hit.pageIndex highlightSearchResult:hit];
    }else{
        [self performSelector:@selector(loadMore)];
    }
}
/*
 - (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if ([results count] != 0) {
 if (indexPath.row == [results count]) {
 if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count]){
 moreTweetActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 
 moreTweetActivityIndicator.frame = CGRectMake(cell.frame.size.width/2, cell.frame.size.height/4, 20, 20);
 [cell addSubview:moreTweetActivityIndicator];
 // [moreTweetActivityIndicator release];
 [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex+1)];
 [moreTweetActivityIndicator startAnimating];
 }
 }
 }
 }
 */
-(void)loadMore{
    if ((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count]) {
        _loadingView.hidden=NO;
        [_indicator startAnimating];
        [self searchString:currentQuery inChapterAtIndex:(currentChapterIndex+1)];
    }  
   
}

- (void) searchString:(NSString*)query{
    //  activityIndicator.hidden=NO;
    //  [activityIndicator startAnimating];
    self.results = [[NSMutableArray alloc] init];
    [resultsTableView reloadData];
    self.currentQuery=query;
    [self searchString:query inChapterAtIndex:0];
}

- (void) searchString:(NSString *)query inChapterAtIndex:(int)index{
    
    currentChapterIndex = index;
    
    Chapter* chapter = [epubViewController.loadedEpub.spineArray objectAtIndex:index];
    // NSLog(@"%@",chapter.text);
    NSRange range = NSMakeRange(0, chapter.text.length);
    range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
    int hitCount=0;
    while (range.location != NSNotFound) {
        range = NSMakeRange(range.location+range.length, chapter.text.length-(range.location+range.length));
        range = [chapter.text rangeOfString:query options:NSCaseInsensitiveSearch range:range locale:nil];
        hitCount++;
    }
    
    if(hitCount!=0){
        // NSLog(@"x=%f,y=%f,w=%f,h=%f",chapter.windowSize.origin.x,chapter.windowSize.origin.y,chapter.windowSize.size.width ,chapter.windowSize.size.height);
        UIWebView* webView = [[UIWebView alloc] initWithFrame:[self getWindowSize]];
        [webView setDelegate:self];
        
        NSURL* url = [NSURL fileURLWithPath:chapter.spinePath];
        NSURLRequest *request =[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:100.0];
        [webView loadRequest:request];
        //if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count] && currentSearchCount<10){
          //  [self loadMore];
       // }else
         //   currentSearchCount=0;
    }
    
    else {
        if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count] && currentSearchCount<10){
           [self loadMore];
        } else {
            currentSearchCount=0;
            _loadingView.hidden=YES;
            [_indicator stopAnimating];
            epubViewController.searching = NO;
            [resultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
    }
     
    
}

-(CGRect)getWindowSize{
    
    return CGRectMake(0, 0, 768, 1024);
    
}


- (void)reloadTableViewDataSource {
    
    [self performSelector:@selector(doneLoadingTableViewData)];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //NSLog(@"%@", error);
    [webView release];
}

- (void) webViewDidFinishLoad:(UIWebView*)theWebView{
    /////////////////////
    
    if([epubViewController.bgColor isEqualToString: WHILTE_COLOR])
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"white\";"]];
    else if([epubViewController.bgColor isEqualToString: BLACK_COLOR])
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"black\";"]];
    else if([epubViewController.bgColor isEqualToString: SEPIA_COLOR])
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"beig\";"]];

    if(epubViewController.currentTextSize == SMALL_SIZE)
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"body\")[0];element.className += \"   \" + \"small\";"]];
    else if(epubViewController.currentTextSize == NORMAL_SIZE)
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"body\")[0];element.className += \"   \" + \"normal\";"]];
    else if(epubViewController.currentTextSize == LARGE_SIZE)
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"body\")[0];element.className += \"   \" + \"large\";"]];
    
    
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
    NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
    "if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
    "} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
    "}";
   // NSLog(@"%f",theWebView.frame.size.height);
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', ' -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", theWebView.frame.size.width];
    NSString *setImageRule = [NSString stringWithFormat:@"addCSSRule('img', 'max-width: %fpx; max-height:%fpx;')", theWebView.frame.size.width *0.75,theWebView.frame.size.height * 0.75];
    [theWebView stringByEvaluatingJavaScriptFromString:varMySheet];
    [theWebView stringByEvaluatingJavaScriptFromString:addCSSRule];

    [theWebView stringByEvaluatingJavaScriptFromString:insertRule1];
    [theWebView stringByEvaluatingJavaScriptFromString:setImageRule];
    
      
   
    

    
    ////////////////////
    
    [theWebView highlightAllOccurencesOfString:currentQuery];
  
    NSString* foundHits = [theWebView stringByEvaluatingJavaScriptFromString:@"results"];
    NSMutableArray* objects = [[NSMutableArray alloc] init];
    NSArray* stringObjects = [foundHits componentsSeparatedByString:@";"];
    for(int i=0; i<[stringObjects count]; i++){
        NSArray* strObj = [[stringObjects objectAtIndex:i] componentsSeparatedByString:@","];
        if([strObj count]==3){
            [objects addObject:strObj];
        }
    }

    NSArray* orderedRes = [objects sortedArrayUsingComparator:^(id obj1, id obj2){
        int x1 = [[obj1 objectAtIndex:0] intValue];
        int x2 = [[obj2 objectAtIndex:0] intValue];
        int y1 = [[obj1 objectAtIndex:1] intValue];
        int y2 = [[obj2 objectAtIndex:1] intValue];
        if(y1<y2){
            return NSOrderedAscending;
        } else if(y1>y2){
            return NSOrderedDescending;
        } else {
            if(x1<x2){
                return NSOrderedAscending;
            } else if (x1>x2){
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }];
    
    [objects release];
    for(int i=0; i<[orderedRes count]; i++){
      
        NSArray* currObj = [orderedRes objectAtIndex:i];
       // NSLog(@"%d",[[currObj objectAtIndex:1] intValue]);
        SearchResult* searchRes = [[SearchResult alloc] initWithChapterIndex:currentChapterIndex pageIndex:([[currObj objectAtIndex:1] intValue]/847) hitIndex:0 neighboringText:[theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"unescape('%@')", [currObj objectAtIndex:2]]] originatingQuery:currentQuery];
        [results addObject:searchRes];
        [searchRes release];
    }
    currentSearchCount +=[orderedRes count];
    
    if((currentChapterIndex+1)<[epubViewController.loadedEpub.spineArray count] && currentSearchCount<10){
        [self loadMore];
    } else {
        currentSearchCount=0;
        _loadingView.hidden=YES;
        [_indicator stopAnimating];
        epubViewController.searching = NO;
        [resultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
   // epubViewController.searching = NO;
   // [moreTweetActivityIndicator stopAnimating];
  //  moreTweetActivityIndicator.hidden=YES;
    // activityIndicator.hidden=YES;
    //  [activityIndicator stopAnimating];
 //   _loadingView.hidden=YES;
 //   [_indicator stopAnimating];
 //   [resultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [theWebView dealloc];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.resultsTableView = nil;
    [results release];
    [currentQuery release];
    [activityIndicator release];
    [_loadingView release];
    [_indicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 40)] autorelease];
    searchBar.placeholder=@"بحث";
    searchBar.delegate=self;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:searchBar] autorelease];
    self.epubViewController.searching = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if(! self.epubViewController.searching){
		self.epubViewController.searching = YES;
        NSString *query = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        query=[NSString stringWithFormat:@" %@ ",query];
		[self searchString:query];
        
	}else {
        self.epubViewController.searching=NO;
    }
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setLoadingView:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.resultsTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
