

#import "EPubViewController.h"
#import "ChapterListViewController.h"
#import "SearchResultsViewController.h"
#import "SearchResult.h"
#import "UIWebView+SearchWebView.h"
#import "Chapter.h"

#import "UserDefaults.h"
#import "GeneralWebViewController.h"
#import "XMLReader.h"
#import "Constants.h"
#import "BookmarkViewController.h"
#import "TransitionConstants.h"
#import "NetworkService.h"
#import "UsageData.h"
@interface EPubViewController()

- (void) gotoNextSpine;
- (void) gotoPrevSpine;
- (void) gotoNextPage;
- (void) gotoPrevPage;
- (int) getGlobalPageCount;
- (void) gotoPageInCurrentSpine: (int)pageIndex;
- (void) updatePagination;
- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex;

@end

@implementation EPubViewController

@synthesize optionButton;
@synthesize indexButton;
@synthesize bookmarkButton;
@synthesize bookSearchBar,bgColor;
@synthesize loadedEpub, toolbar, webView;
@synthesize chapterListButton;
@synthesize currentPageLabel, pageSlider, searching,_backView,bookId;
@synthesize currentSearchResult,chaptersArray,webViewLoaded,filePath,progressBar,bookmarksPopover,currentTextSize,headerView,footerView,bookIndex;


- (id)initWithUrl:(NSURL*) epubURL withID:(NSString *)bookID {
    self=[self init];
    if (self) {
        // NSLog(@"%@",[epubURL path]);
        self.filePath=[epubURL path];
        currentSpineIndex = 0;
        currentPageInSpineIndex = 0;
        pagesInCurrentSpineCount = 0;
        totalPagesCount = 0;
        searching = NO;
        // NSLog(@"%@",[epubURL path]);
        self.loadedEpub = [[EPub alloc] initWithEPubPath:[epubURL path]];
        self.bookId=bookID;
        isCashed=[UserDefaults checkForKey:bookId];
        self.chaptersArray=[NSMutableArray array];
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if([UsageData getiOSVersion] != 7)
      [self hideTabBar:self.tabBarController];
   
    
    if([UsageData getiOSVersion] == 7)
    {
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.44f);
        progressBar.transform =  CGAffineTransformRotate(transform, 3.14);
    }
    else
        progressBar.transform = CGAffineTransformMakeRotation(3.14);
    
  //  [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    transitionIndex=3;
    background_Color_Tag=1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPage) name:@"appDidBecomeActive" object:nil];
    currentTextSize = NORMAL_SIZE;
    self.bgColor=[NSString stringWithFormat:@"%@",WHILTE_COLOR];
    NSDictionary *lastPageDict=[UserDefaults getLastPageOpened:bookId];
    // webView.backgroundColor=[UIColor colorWithRed:(CGFloat)242/255.0 green:(CGFloat)242/255.0 blue:(CGFloat)242/255.0 alpha:1.0];
    // _backView.backgroundColor=[UIColor colorWithRed:(CGFloat)242/255.0 green:(CGFloat)242/255.0 blue:(CGFloat)242/255.0 alpha:1.0];
    if (lastPageDict) {
        currentPageInSpineIndex=[[lastPageDict objectForKey:PAGE] intValue];
        currentSpineIndex=[[lastPageDict objectForKey:CHAPTER] intValue];
        currentTextSize=[[lastPageDict objectForKey:ZOOM_LEVEL] intValue];
        background_Color_Tag=[[lastPageDict objectForKey:BACKGROUNT_COLOR_TAG] intValue];
        [self changeBackgroundColorClickedWithTag:background_Color_Tag];
    }
    [self isPageBookmarked];
    [self updatePagination];
    // [self sendCachedData];
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI);
    pageSlider.transform = trans;
    
    [pageSlider setBackgroundColor:[UIColor clearColor]];
    
	[webView setDelegate:self];
	
    
    UIScrollView* sv = nil;
	for (UIView* v in  webView.subviews) {
		if([v isKindOfClass:[UIScrollView class]]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = NO;
			sv.bounces = NO;
		}
	}
     
    
    
    
    
   [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    footerView.frame=CGRectMake(0, 1024, 768, 46);
    headerView.frame=CGRectMake(0, -46, 768, 46);
    footerView.hidden=NO;
    headerView.hidden=NO;
    isBarsHidden=NO;
    // [self hideBars:isBarsHidden isRoladed:NO];
    //[self performSelector:@selector(hideBars:)];
    
	searchResViewController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:[NSBundle mainBundle]];
	searchResViewController.epubViewController = self;
    
    startTime = [[NSDate date] retain];
    endTime = [[NSDate date] retain];
}
-(void)viewWillAppear:(BOOL)animated{
    UISwipeGestureRecognizer* rightSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPrevPage)] autorelease];
    [rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    UISwipeGestureRecognizer* leftSwipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNextPage)] autorelease];
    [leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(controlBars)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    
    
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    [self.view addGestureRecognizer:leftSwipeRecognizer];
    [self.view addGestureRecognizer:tapRecognizer];
    // webView.userInteractionEnabled=NO;
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    
}
-(void)SaveData
{
    
    endTime = [NSDate date] ;
    NSTimeInterval interval = [endTime timeIntervalSinceDate:startTime];
    
   
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"plist.plist"] ];
        usageData = [[NSMutableArray alloc] init];
    }
    
    else
        usageData = [[NSMutableArray alloc] initWithContentsOfFile: path];
    
    
    NSDictionary *savedDict=[NSDictionary dictionaryWithObjectsAndKeys:bookId,@"itemnumber",[NSString stringWithFormat:@"%d",(int)interval ],@"timespentreading",startTime,@"timeOpened",[NSString stringWithFormat:@"%d",[self getGlobalPageCount]],@"lastpage",[NSString stringWithFormat:@"%d",currentTextSize],@"fontsize", nil];
    
    [usageData addObject:savedDict];
    [usageData writeToFile:path atomically:YES];
    
    
    [usageData release] ;
}

- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 1024, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 1024)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 975, view.frame.size.width, 49)];
            NSLog(@"%f",view.frame.size.height);
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 975)];
             NSLog(@"%f",view.frame.size.height);
        }
    }
    
    [UIView commitAnimations];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self hideBars];
}
- (void)controlBars{
    [self hideBars:isBarsHidden isRoladed:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(IBAction)backView{
    if ( !searching) {
        [self SaveData];
        if ([chaptersPopover isPopoverVisible]) {
            [chaptersPopover dismissPopoverAnimated:YES];
        }if ([searchResultsPopover isPopoverVisible]) {
            [searchResultsPopover dismissPopoverAnimated:YES];
        }
        if ([bookmarksPopover isPopoverVisible]) {
            [bookmarksPopover dismissPopoverAnimated:YES];
        }
        [UserDefaults setLastPageOpened:bookId withPage:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",currentSpineIndex],CHAPTER,[NSString stringWithFormat:@"%d",currentPageInSpineIndex],PAGE,[NSString stringWithFormat:@"%d",currentTextSize],ZOOM_LEVEL,[NSString stringWithFormat:@"%d",background_Color_Tag],BACKGROUNT_COLOR_TAG ,nil]];
        [queue setSuspended:YES];
        
            if([UsageData getiOSVersion] != 7)
        [self showTabBar:self.tabBarController];
        

        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (int) getGlobalPageCount{
    
    
	int pageCount = 0;
	for(int i=0; i<currentSpineIndex; i++){
		pageCount+= [[loadedEpub.spineArray objectAtIndex:i] pageCount];
	}
	pageCount+=currentPageInSpineIndex+1;
	return pageCount;
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex {
	[self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex highlightSearchResult:(SearchResult*)theResult{
	
	webView.hidden = YES;
	self.currentSearchResult = theResult;
    [self setFullScreenMode];
    if (spineIndex != 0) {
        
        NSURL* url = [NSURL fileURLWithPath:[[loadedEpub.spineArray objectAtIndex:spineIndex] spinePath]];
        // NSLog(@"%@",url);
        NSURLRequest *request =[[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:100.0];
        [webView loadRequest:request];
        [request release];
    }else{
        webView.hidden = NO;
        [self loadCover];
    }
	currentPageInSpineIndex = pageIndex;
	currentSpineIndex = spineIndex;
     [self isPageBookmarked];
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
	}
    
}

- (void) loadSpine:(int)spineIndex atPageIndex:(int)pageIndex WithFontSize:(int)fontSize{
    if (fontSize==currentTextSize) {
        [self loadSpine:spineIndex atPageIndex:pageIndex highlightSearchResult:nil];
    }else{
        currentPageInSpineIndex = pageIndex;
        currentSpineIndex = spineIndex;
        currentTextSize=fontSize;
        [self updatePagination];
        [self setFullScreenMode];
    }
}

-(void)setFullScreenMode
{
    [bookSearchBar resignFirstResponder];
	[chaptersPopover dismissPopoverAnimated:YES];
	[searchResultsPopover dismissPopoverAnimated:YES];
    [bookmarksPopover dismissPopoverAnimated:YES];
    [fontPopover dismissPopoverAnimated:YES];
    if (isBarsHidden) {
        [self hideBars:isBarsHidden isRoladed:NO];
    }
    
}
- (void) gotoPageInCurrentSpine:(int)pageIndex{
    
    [bookSearchBar resignFirstResponder];
	if(pageIndex>=pagesInCurrentSpineCount){
		pageIndex = pagesInCurrentSpineCount - 1;
		currentPageInSpineIndex = pagesInCurrentSpineCount - 1;
	}
	
	float pageOffset =pageIndex*webView.bounds.size.width;
	NSString* goToOffsetFunc = [NSString stringWithFormat:@"function pageScroll(xOffset){ window.scroll(xOffset,0); } "];
	NSString* goTo =[NSString stringWithFormat:@"pageScroll(%f);", pageOffset];
	
	[webView stringByEvaluatingJavaScriptFromString:goToOffsetFunc];
	[webView stringByEvaluatingJavaScriptFromString:goTo];
	
	if(!paginating){
		[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
		[pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
	}
	
	webView.hidden = NO;
	
}

-(void)loadTransitionWithDimention:(BOOL)isRight{
    
    switch (transitionIndex) {
        case 1:{
            if (isRight){
                TRAN_PUSH_RIGHT
            }
            else{
                TRAN_PUSH_LEFT
            }
        }
            break;
        case 2:{
            TRAN_FADE
        }
            break;
        case 3:{
            if (isRight){
                TRAN_REVEAL_RIGHT
            }
            else{
                TRAN_REVEAL_LEFT
            }}
            break;
        case 4:{
            if (isRight){
                TRAN_Ripple_RIGHT
            }
            else{
                TRAN_Ripple_LEFT
            }}
            break;
        case 5:{
            if (isRight){
                TRAN_CUPE_RIGHT
            }
            else{
                TRAN_CUPE_LEFT
            }}
            break;
        case 6:{
            if (isRight){
                TRAN_FLIP_RIGHT
            }
            else{
                TRAN_FLIP_LEFT
            }}
            break;
        case 7:{
            if (isRight){
                TRAN_ROTATE_RIGHT
            }
            else{
                TRAN_ROTATE_LEFT
            }}
            break;
        default:
            break;
    }
    
}
-(void) gotoNextSpine {
    if (isBarsHidden) {
        [self hideBars:isBarsHidden isRoladed:NO];
    }
    if(currentSpineIndex+1<[loadedEpub.spineArray count]){
        [self loadSpine:++currentSpineIndex atPageIndex:0];
        [self loadTransitionWithDimention:NO];
        
        
    }
}

- (void) gotoPrevSpine {
    if(currentSpineIndex-1>0){
        [self loadSpine:--currentSpineIndex atPageIndex:0];
    }
    
}


- (void) gotoNextPage {
    /*
     if (isFootnotePressed) {
     int scrollPosition = [[webView stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
     currentPageInSpineIndex=scrollPosition/webView.bounds.size.width;
     isFootnotePressed=NO;
     }
     */
    if (isBarsHidden) {
        [self hideBars:isBarsHidden isRoladed:NO];
    }
    if(currentPageInSpineIndex+1<pagesInCurrentSpineCount){
        [self gotoPageInCurrentSpine:++currentPageInSpineIndex];
        [self loadTransitionWithDimention:NO];
    }
    else {
        [self gotoNextSpine];
    }
     [self isPageBookmarked];
    [UserDefaults setLastPageOpened:bookId withPage:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",currentSpineIndex],CHAPTER,[NSString stringWithFormat:@"%d",currentPageInSpineIndex],PAGE,[NSString stringWithFormat:@"%d",currentTextSize],ZOOM_LEVEL,[NSString stringWithFormat:@"%d",background_Color_Tag],BACKGROUNT_COLOR_TAG ,nil]];
}

- (void) gotoPrevPage {
    
    /*
     if (isFootnotePressed) {
     int scrollPosition = [[webView stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
     currentPageInSpineIndex=scrollPosition/webView.bounds.size.width;
     isFootnotePressed=NO;
     }
     */
    if (isBarsHidden) {
        [self hideBars:isBarsHidden isRoladed:NO];
    }
    if(currentPageInSpineIndex-1>=0){
        [self gotoPageInCurrentSpine:--currentPageInSpineIndex];
        [self loadTransitionWithDimention:YES];
    } else {
        if(currentSpineIndex!=0){
            [self loadTransitionWithDimention:YES];
            int targetPage = [[loadedEpub.spineArray objectAtIndex:(currentSpineIndex-1)] pageCount];
            [self loadSpine:--currentSpineIndex atPageIndex:targetPage-1];
        }
        
    }
    [self isPageBookmarked];
    
    [UserDefaults setLastPageOpened:bookId withPage:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",currentSpineIndex],CHAPTER,[NSString stringWithFormat:@"%d",currentPageInSpineIndex],PAGE,[NSString stringWithFormat:@"%d",currentTextSize],ZOOM_LEVEL,[NSString stringWithFormat:@"%d",background_Color_Tag],BACKGROUNT_COLOR_TAG ,nil]];
}

#pragma Font Delegate.....
- (void) changeTextSizeClickedWithTag:(int)tag{
    switch (tag) {
        case 1:
            currentTextSize=SMALL_SIZE;
            break;
        case 2:
            currentTextSize=NORMAL_SIZE;
            break;
        case 3:
            currentTextSize=LARGE_SIZE;
            break;
        default:
            break;
    }
    [self isPageBookmarked];
    [self updatePagination];
    [self setFullScreenMode];
}
- (void) changeBackgroundColorClickedWithTag:(int)tag{
    background_Color_Tag=tag;
    switch (tag) {
        case 1:
            bgColor=WHILTE_COLOR;
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"white\";"]];
            
            ///[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.color = 'black';"]];
            
            //[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.html.style.background = '%@';",bgColor]];
            //  [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.div.style.background = '%@';",bgColor]];
            
            webView.backgroundColor=[UIColor whiteColor];
            _backView.backgroundColor=[UIColor whiteColor];
            self.view.backgroundColor=[UIColor whiteColor];
            break;
        case 2:
            bgColor=BLACK_COLOR;
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"black\";"]];
            //[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.background = '%@';",bgColor]];
            //[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.color = 'white';"]];
            // [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.html.style.background = '%@';",bgColor]];
            // [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.div.style.background = '%@';",bgColor]];
            
            webView.backgroundColor=[UIColor blackColor];
            _backView.backgroundColor=[UIColor blackColor];
            self.view.backgroundColor=[UIColor blackColor];
            break;
        case 3:
            bgColor=SEPIA_COLOR;
            [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"beig\";"]];
            //[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.background = '%@';",bgColor]];
            //[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.color = 'black';"]];
            // [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.html.style.background = '%@';",bgColor]];
            // [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.div.style.background = '%@';",bgColor]];
            
            webView.backgroundColor=[UIColor colorWithRed:(CGFloat)250/255.0 green:(CGFloat)235/255.0 blue:(CGFloat)215/255.0 alpha:1.0];
            _backView.backgroundColor=[UIColor colorWithRed:(CGFloat)250/255.0 green:(CGFloat)235/255.0 blue:(CGFloat)215/255.0 alpha:1.0];
            self.view.backgroundColor=[UIColor colorWithRed:(CGFloat)250/255.0 green:(CGFloat)235/255.0 blue:(CGFloat)215/255.0 alpha:1.0];
            
            break;
        default:
            break;
    }
    [self setFullScreenMode];
}
- (void) setBrightnessWithRate:(float)rate{
    [[UIScreen mainScreen] setBrightness:rate];
}
- (void)setTranstionWithIndex:(int)index{
    transitionIndex=index;
    [self setFullScreenMode];
}

- (IBAction) changeTextSizeClicked:(UIButton *)sender{
	
    //if(fontPopover==nil){
        FontViewController* fontViewController = [[FontViewController alloc] init];
        //fontViewController.fontSize=18;
        fontViewController.delegate=self;
        fontViewController.fontSize=currentTextSize;
        fontViewController.background_color_tag=background_Color_Tag;
        UINavigationController *navbar = [[UINavigationController alloc] initWithRootViewController:fontViewController];
        [fontViewController release];
        navbar.contentSizeForViewInPopover = CGSizeMake(321, 214);
		fontPopover = [[UIPopoverController alloc] initWithContentViewController:navbar];
        fontPopover.popoverContentSize = CGSizeMake(321, 214);
        [navbar release];
        
   if ([fontPopover isPopoverVisible]) {
		[fontPopover dismissPopoverAnimated:YES];
	}else{
		[fontPopover presentPopoverFromRect:CGRectMake(optionButton.frame.origin.x, optionButton.frame.origin.y+27, optionButton.frame.size.width, optionButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (void)userDidTapWebView:(id)tapPoint{
    
    [self hideBars:isBarsHidden isRoladed:NO];
}


-(void) hideBars:(BOOL)hide isRoladed:(BOOL)isReloaded{
    if (self.imageView.hidden) {
        
        
        int headmovement;
        int tailmovement;
        
        if (!isReloaded) {
            headmovement = (hide ? self.view.frame.origin.x-66: 20);
            tailmovement = (hide ? 1024 : 978);
        }else{
            headmovement = (hide ? self.view.frame.origin.x-66: 0);
            tailmovement = (hide ? 1024: 958);
        }
        
        
        [UIView animateWithDuration:0.4 animations:^{
            headerView.frame=CGRectMake(self.view.frame.origin.x, headmovement, 768, 46);
            footerView.frame=CGRectMake(self.view.frame.origin.x, tailmovement, 768, 46);
           [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:UIStatusBarAnimationSlide];
        } completion:^(BOOL finished){
            
        }];
        isBarsHidden=!isBarsHidden;
    }
}

-(void) hideBars{
    if (self.imageView.hidden) {
        
        
        int headmovement;
        int tailmovement;
        
        
        headmovement =  self.view.frame.origin.x-66;
        tailmovement =  1024;
        
        
        
        //  [UIView animateWithDuration:0.4 animations:^{
        headerView.frame=CGRectMake(self.view.frame.origin.x, headmovement, 768, 46);
        footerView.frame=CGRectMake(self.view.frame.origin.x, tailmovement, 768, 46);
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        //  } completion:^(BOOL finished){
        
        //  }];
        isBarsHidden=NO;
    }
}




- (IBAction) slidingStarted:(id)sender{
    int targetPage = ((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	[currentPageLabel setText:[NSString stringWithFormat:@"%d/%d", targetPage, totalPagesCount]];
}

- (IBAction) slidingEnded:(id)sender{
	int targetPage = (int)((pageSlider.value/(float)100)*(float)totalPagesCount);
    if (targetPage==0) {
        targetPage++;
    }
	int pageSum = 0;
	int chapterIndex = 0;
	int pageIndex = 0;
	for(chapterIndex=0; chapterIndex<[loadedEpub.spineArray count]; chapterIndex++){
		pageSum+=[[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount];
		if(pageSum>=targetPage){
			pageIndex = [[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount] - 1 - pageSum + targetPage;
			break;
		}
	}
    pagesInCurrentSpineCount=[[loadedEpub.spineArray objectAtIndex:chapterIndex] pageCount];
	[self loadSpine:chapterIndex atPageIndex:pageIndex];
}

- (IBAction) showChapterIndex:(id)sender{
    
    if(chaptersPopover==nil){
        ChapterListViewController* chapterListView = [[ChapterListViewController alloc] initWithNibName:@"ChapterListViewController" bundle:[NSBundle mainBundle]];
        chapterListView.tableData=[self.loadedEpub getIndex];
        UINavigationController *navbar = [[UINavigationController alloc] initWithRootViewController:chapterListView];
        [chapterListView release];
        navbar.contentSizeForViewInPopover = CGSizeMake(400, 600);
        [chapterListView setEpubViewController:self];
		chaptersPopover = [[UIPopoverController alloc] initWithContentViewController:navbar];
        chaptersPopover.popoverContentSize = CGSizeMake(400, 600);
        [navbar release];
        
    }if ([chaptersPopover isPopoverVisible]) {
		[chaptersPopover dismissPopoverAnimated:YES];
	}else{
		[chaptersPopover presentPopoverFromRect:CGRectMake(indexButton.frame.origin.x, indexButton.frame.origin.y+27, indexButton.frame.size.width, indexButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}


- (IBAction) showBookmarks:(id)sender{
    
   // if(self.bookmarksPopover==nil){
        BookmarkViewController* bookmarkViewController = [[BookmarkViewController alloc] initWithNibName:@"BookmarkViewController" bundle:[NSBundle mainBundle]];
        bookmarkViewController.tableData=[UserDefaults getBookmarkPages:bookId forFontSize:currentTextSize];
        bookmarkViewController.indexData=[self.loadedEpub getIndex];
        [bookmarkViewController setEpubViewController:self];
    
       
        UINavigationController *navbar = [[UINavigationController alloc] initWithRootViewController:bookmarkViewController];
        [BookmarkViewController release];
        navbar.contentSizeForViewInPopover = CGSizeMake(400, 600);
		bookmarksPopover = [[UIPopoverController alloc] initWithContentViewController:navbar];
        bookmarksPopover.popoverContentSize = CGSizeMake(400, 600);
        [navbar release];
        
    if ([bookmarksPopover isPopoverVisible]) {
		[bookmarksPopover dismissPopoverAnimated:YES];
	}else{
		 [self.bookmarksPopover presentPopoverFromRect:CGRectMake(self.bookmarkResultButton.frame.origin.x, self.bookmarkResultButton.frame.origin.y+27, self.bookmarkResultButton.frame.size.width, self.bookmarkResultButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    
    
    /*
    if ([self.bookmarksPopover isPopoverVisible]) {
        [self.bookmarksPopover dismissPopoverAnimated:YES];
    }else{
        BookmarkViewController* bookmarkViewController = [[BookmarkViewController alloc] initWithNibName:@"BookmarkViewController" bundle:[NSBundle mainBundle]];
       
        
        self.bookmarksPopover = [[UIPopoverController alloc] initWithContentViewController:bookmarkViewController];
        [self.bookmarksPopover presentPopoverFromRect:CGRectMake(bookmarkButton.frame.origin.x, bookmarkButton.frame.origin.y+27, bookmarkButton.frame.size.width, bookmarkButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

      //  [self.bookmarksPopover presentPopoverFr:bookmarkButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [bookmarkViewController release];
    }
     */
}



- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    BOOL loadRequest = YES;
    //  NSLog(@"%@",[[request URL] absoluteString]);
    if (self.webViewLoaded) {
        if ([[[request URL] absoluteString] rangeOfString:@"mailto" options:NSRegularExpressionSearch].location != NSNotFound) {
            loadRequest = NO;
			if ([MFMailComposeViewController canSendMail]) {
				MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
				mailViewController.mailComposeDelegate = self;
				[mailViewController setToRecipients:[NSArray arrayWithObject:[[[request URL] absoluteString] substringFromIndex:7]]];
				
				[self presentModalViewController:mailViewController animated:YES];
				[mailViewController release];
			} else {
				//SHOW_ALERT(@"Email service not available",@"ok");
			}
		}else if ([[[request URL] absoluteString] rangeOfString:@"tel" options:NSRegularExpressionSearch].location != NSNotFound){
            loadRequest = NO;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: [[request URL] absoluteString]]];
        }else if ([[[request URL] absoluteString] rangeOfString:@"http" options:NSRegularExpressionSearch].location != NSNotFound){
            // GeneralWebViewController *generalWebViewController=[[GeneralWebViewController alloc] initWithUrl:[[request URL] absoluteString]];
            // [self presentModalViewController:generalWebViewController animated:YES];
            // [generalWebViewController release];
            loadRequest = NO;
        }else if ([[[request URL] absoluteString] rangeOfString:@".png" options:NSRegularExpressionSearch].location != NSNotFound || [[[request URL] absoluteString] rangeOfString:@".jpg" options:NSRegularExpressionSearch].location != NSNotFound || [[[request URL] absoluteString] rangeOfString:@".svg" options:NSRegularExpressionSearch].location != NSNotFound){
            [self hideBars];
            NSString *CSS=[[NSString alloc] initWithData:[UserDefaults getDataWithName:@"style.css" inRelativePath:@"/books" inDocument:YES] encoding:NSUTF8StringEncoding];
            NSString *imageHtml=[NSString stringWithFormat:@"<html class=\"pop_image\"><head><style>%@</style></head><body><img src=\"%@\" /></body></html>",CSS,[[request URL] absoluteString]];
            
            [CSS release];
            //  NSLog(@"%@",imageHtml);
            self.imageView.frame=CGRectMake(0, 1024, 0, 0);
            [self.imageWebview loadHTMLString:imageHtml baseURL:nil];
            self.imageView.hidden=NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.imageView.frame=CGRectMake(0, 0, 768  , 1024);
            }];
            loadRequest=NO;
            //  GeneralWebViewController *generalWebViewController=[[GeneralWebViewController alloc] initWithUrl:[[request URL] absoluteString]];
            // [self presentModalViewController:generalWebViewController animated:NO];
            //  [generalWebViewController release];
            // [theWebView reloadInputViews];
            // isFootnotePressed=YES;
        }
        
	} else {
		self.webViewLoaded = YES;
	}
	
	return loadRequest;
}
-(IBAction)closeImageView{
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.frame=CGRectMake(0, 1024, 768, 1024);
        self.imageView.hidden=YES;
    }];
    //
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView{
    if (theWebView == webView) {
        //[DELEGATE startActivity];
        indicatorView.hidden=NO;
        [indicatorProgress startAnimating];
        
    }
    
}

- (void)renderWebView:(UIWebView *)theWebView
{
    // NSLog(@"%d",currentSpineIndex);
    if([bgColor isEqualToString: WHILTE_COLOR])
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"white\";"]];
    else if([bgColor isEqualToString: BLACK_COLOR])
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"black\";"]];
    else if([bgColor isEqualToString: SEPIA_COLOR])
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"html\")[0];element.className =  \"beig\";"]];
    
    
    if(currentTextSize == SMALL_SIZE)
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"body\")[0];element.className += \"   \" + \"small\";"]];
    else if(currentTextSize == NORMAL_SIZE)
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var element = document.getElementsByTagName(\"body\")[0];element.className += \"   \" + \"normal\";"]];
    else if(currentTextSize == LARGE_SIZE)
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
    //  NSLog(@"%f",theWebView.frame.size.width);
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', ' -webkit-column-gap: 0px; -webkit-column-width: %fpx;')", theWebView.frame.size.width];
    NSString *setImageRule = [NSString stringWithFormat:@"addCSSRule('img', 'max-width: %fpx; max-height:%fpx;')", theWebView.frame.size.width *0.75,theWebView.frame.size.height * 0.75];
    [theWebView stringByEvaluatingJavaScriptFromString:addCSSRule];
    [theWebView stringByEvaluatingJavaScriptFromString:varMySheet];
    
    [theWebView stringByEvaluatingJavaScriptFromString:insertRule1];
    
    if (currentSpineIndex !=2) {
        [theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function test() {var i;var els = document.getElementsByTagName(\"img\");for(i=0 ; i<els.length ; i++){els[i].addEventListener(\"click\",function(){window.location.href =this.src ;});}}"]];
        [theWebView stringByEvaluatingJavaScriptFromString:@"test();"];
    }
    
    
    if(currentSearchResult!=nil){
        [theWebView highlightAllOccurencesOfString:currentSearchResult.originatingQuery];
    }
    [theWebView stringByEvaluatingJavaScriptFromString:setImageRule];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView{
    theWebView.frame=CGRectMake(0, 0, 768, 1024);
    if (theWebView == webView) {
        if (currentSpineIndex !=0) {
            //  theWebView.frame=CGRectMake(0, 0, 768, 1024);
            [self renderWebView:theWebView];
            int totalWidth = [[theWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
            pagesInCurrentSpineCount = (int)((float)totalWidth/theWebView.bounds.size.width);
            [self gotoPageInCurrentSpine:currentPageInSpineIndex];
        }
    }else{
        [self renderWebView:theWebView];
        int totalWidth = [[theWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
        ((Chapter *)[loadedEpub.spineArray objectAtIndex:ChapterIndex]).pageCount=(int)((float)totalWidth/theWebView.bounds.size.width);
        
        // NSLog(@"%@",((Chapter *)[loadedEpub.spineArray objectAtIndex:ChapterIndex]).spinePath);
        [self chapterDidFinishLoad:[loadedEpub.spineArray objectAtIndex:ChapterIndex]];
    }
    
    // [DELEGATE stopActivity];
    indicatorView.hidden=YES;
    [indicatorProgress stopAnimating];
}
- (BOOL)checkOperationLive{
    if ([queue isSuspended]) {
        return NO;
    }
    return YES;
}

-(void)loadCover{
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *documentPath = [NSString stringWithFormat:@"%@/books/",path];
    NSURL *baseUrl=[NSURL URLWithString:documentPath];
    
    NSString *coverHtml=[NSString stringWithFormat:@"<html></head><body><img STYLE=\"position:absolute; TOP:0px; LEFT:0px; WIDTH:768px; HEIGHT:1024px\" src=\"%@c.jpg\" /></body></html>",bookId];
    [webView loadHTMLString:coverHtml baseURL:baseUrl];
}

- (void) updatePagination
{
    [queue setSuspended:YES];
    self.chaptersArray=[NSMutableArray array];
    paginating = YES;
    totalPagesCount=0;
    [self loadSpine:currentSpineIndex atPageIndex:currentPageInSpineIndex];
    ///////////////////////////////////////////////
    
    NSString *bookCSSID=[UserDefaults getCSSIDforBookID:bookId];
    NSString *latestCSSID=[UserDefaults getStringWithKey:CSSID];
    
    if ([bookCSSID isEqualToString:latestCSSID]) {
        NSArray *currentChaptersArray=[NSArray arrayWithArray:[UserDefaults getNumOfPages:bookId withFontSize:currentTextSize]];
        
        if (currentChaptersArray && currentChaptersArray.count >0) {
            [self fillupChaptersWithArray:currentChaptersArray];
            [self updateBottomBar];
        }
        else
        {
            [self startProcessingWithServer];
        }
    }else{
        [self startProcessingWithServer];
    }
    
    
    
    ///////////////////////////////////////////////
    /*
     if (isCashed) {
     NSMutableArray *currentChaptersArray=[NSMutableArray arrayWithArray:[UserDefaults getNumOfPages:bookId withFontSize:currentTextSize]];
     for (int i=0; i<[currentChaptersArray count]; i++) {
     totalPagesCount +=[[currentChaptersArray objectAtIndex:i] intValue];
     Chapter *currentChapter=[loadedEpub.spineArray objectAtIndex:i];
     currentChapter.pageCount=[[currentChaptersArray objectAtIndex:i] intValue];
     }
     }
     if (!totalPagesCount) {
     
     queue = [[NSOperationQueue alloc] init];
     loadBookOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(startCounter)
     object:self];
     
     [queue addOperation:loadBookOperation];
     [queue setSuspended:NO];
     pageSlider.hidden=YES;
     progressBar.hidden=NO;
     [progressBar setProgress:0 animated:NO];
     progressRate= 1/(float)[loadedEpub.spineArray count];
     [currentPageLabel setText:@"تحميل ..."];
     }else {
     
     [currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
     [pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
     paginating = NO;
     progressRate=0;
     progressBar.hidden=YES;
     pageSlider.hidden=NO;
     
     }
     */
    
	
}
-(void)startProcessingWithServer{
    NSString *latestCSSID=[UserDefaults getStringWithKey:CSSID];
    if ([[NetworkService getObject] checkInternetWithData]) {
        NSArray *returnArray=[self getNumberOfPagesFromServer];
        if (returnArray) {
            [self fillupChaptersWithArray:returnArray];
            [UserDefaults setNumOfPages:bookId withPagesNumbers:returnArray withFontSize:currentTextSize];
            [UserDefaults setCSSIDforBookID:bookId withCSSID:latestCSSID];
            [self updateBottomBar];
        }else{
            [self startPagination];
        }
    }else{
        [self startPagination];
    }
    
}
-(void)startPagination{
    queue = [[NSOperationQueue alloc] init];
    loadBookOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(startCounter)
                                                               object:self];
    
    [queue addOperation:loadBookOperation];
    [queue setSuspended:NO];
    pageSlider.hidden=YES;
    progressBar.hidden=NO;
    [progressBar setProgress:0 animated:NO];
    progressRate= 1/(float)[loadedEpub.spineArray count];
    [currentPageLabel setText:@"تحميل ..."];
}
-(void)fillupChaptersWithArray:(NSArray *)currentChaptersArray{
    for (int i=0; i<[currentChaptersArray count]; i++) {
        totalPagesCount +=[[currentChaptersArray objectAtIndex:i] intValue];
        Chapter *currentChapter=[loadedEpub.spineArray objectAtIndex:i];
        currentChapter.pageCount=[[currentChaptersArray objectAtIndex:i] intValue];
    }
}
-(NSArray *)getNumberOfPagesFromServer{
    NSString *latestCSSID=[UserDefaults getStringWithKey:CSSID];
    NSDictionary *returnDict=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"get/%@/%@/%d/",bookId,latestCSSID,currentTextSize]];
    // NSLog(@"%@",returnDict);
    NSArray *returnArray=[[[returnDict objectForKey:@"plist"] objectForKey:@"array"] objectForKey:@"string"];
    //  NSLog(@"%@",returnArray);
    if (returnArray) {
        return returnArray;
    }
    
    return nil;
}
-(void)sendCachedDataWithArray:(NSArray *)array{
    
    NSString *latestCSSID=[UserDefaults getStringWithKey:CSSID];
    [NetworkService getDataInDictionaryWithBody:[NSDictionary dictionaryWithObjectsAndKeys:array,@"datafile", nil] methodIsPost:YES andBaseURL:[NSString stringWithFormat:@"set/%@/%@/%d/",bookId,latestCSSID,currentTextSize]];
    // NSLog(@"%@",returnDict);
}


-(void)updateBottomBar{
    [currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
    [pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
    paginating = NO;
    progressRate=0;
    progressBar.hidden=YES;
    pageSlider.hidden=NO;
}

- (void) chapterDidFinishLoad:(Chapter *)chapter{
    if (![queue isSuspended]) {
        totalPagesCount+=chapter.pageCount;
        
        [progressBar setProgress:progressBar.progress+progressRate animated:YES];
        [self.chaptersArray addObject:[NSString stringWithFormat:@"%d", chapter.pageCount]];
        
        if(chapter.chapterIndex + 1 < [loadedEpub.spineArray count]){
            ChapterIndex++;
            NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:((Chapter *)[loadedEpub.spineArray objectAtIndex:ChapterIndex]).spinePath]];
            [_chaptersWebview loadRequest:urlRequest];
            
        } else {
            [currentPageLabel setText:[NSString stringWithFormat:@"%d/%d",[self getGlobalPageCount], totalPagesCount]];
            [pageSlider setValue:(float)100*(float)[self getGlobalPageCount]/(float)totalPagesCount animated:YES];
            paginating = NO;
            
            [UserDefaults setNumOfPages:bookId withPagesNumbers:chaptersArray withFontSize:currentTextSize];
            NSString *latestCSSID=[UserDefaults getStringWithKey:CSSID];
            [UserDefaults setCSSIDforBookID:bookId withCSSID:latestCSSID];
            
            
            isCashed=YES;
            progressRate=0;
            progressBar.hidden=YES;
            pageSlider.hidden=NO;
            if ([[NetworkService getObject] checkInternetWithData]) {
                // NSLog(@"%@",chaptersArray);
                [NSThread detachNewThreadSelector:@selector(sendCachedDataWithArray:) toTarget:self withObject:chaptersArray];
            }
            self.chaptersArray=[NSMutableArray array];
        }
    }
    
}


-(void)startCounter{
    
    ChapterIndex=0;
    Chapter *currentChapter=[loadedEpub.spineArray objectAtIndex:ChapterIndex];
    // NSLog(@"%@",[NSURL fileURLWithPath:currentChapter.spinePath]);
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:currentChapter.spinePath]];
    [_chaptersWebview loadRequest:urlRequest];
}

-(IBAction)searchButtonClicked{
    if(searchResultsPopover==nil){
        
        UINavigationController *navbar = [[UINavigationController alloc] initWithRootViewController:searchResViewController];
        navbar.contentSizeForViewInPopover = CGSizeMake(300, 600);
        searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:navbar];
        searchResultsPopover.popoverContentSize = CGSizeMake(300, 600);
        [navbar release];
        
    }if ([searchResultsPopover isPopoverVisible]) {
		[searchResultsPopover dismissPopoverAnimated:YES];
	}else{
        [searchResultsPopover presentPopoverFromRect:CGRectMake(_searchButton.frame.origin.x, _searchButton.frame.origin.y+20, _searchButton.frame.size.width, _searchButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(searchResultsPopover !=nil){
        [searchResultsPopover presentPopoverFromRect:searchBar.bounds inView:searchBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.bookSearchBar resignFirstResponder];
	if(searchResultsPopover==nil){
		searchResultsPopover = [[UIPopoverController alloc] initWithContentViewController:searchResViewController];
		[searchResultsPopover setPopoverContentSize:CGSizeMake(400, 600)];
	}
	if (![searchResultsPopover isPopoverVisible]) {
		[searchResultsPopover presentPopoverFromRect:searchBar.bounds inView:searchBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    if(!searching){
		searching = YES;
		[searchResViewController searchString:bookSearchBar.text];
        
	}else {
        searching=NO;
    }
}

-(BOOL)isPageBookmarked{
    NSArray *bookmarkArray=[UserDefaults getBookmarkPages:bookId forFontSize:currentTextSize];
    for (int i=0; i<bookmarkArray.count; i++) {
        if (currentSpineIndex== [[[bookmarkArray objectAtIndex:i] objectForKey:CHAPTER_KEY] intValue] && currentPageInSpineIndex== [[[bookmarkArray objectAtIndex:i] objectForKey:PAGE_KEY] intValue] && currentTextSize== [[[bookmarkArray objectAtIndex:i] objectForKey:FONT_SIZE] intValue]) {
            [self.bookmarkButton setImage:[UIImage imageNamed:@"bookmark1.png"] forState:UIControlStateNormal];
            return YES;
        }
    }
    [self.bookmarkButton setImage:[UIImage imageNamed:@"bookmark0.png"] forState:UIControlStateNormal];
    return NO;
}


-(IBAction)bookmarkClicked{
    
    NSDictionary *currentPageDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",currentSpineIndex],CHAPTER_KEY,[NSString stringWithFormat:@"%d",currentPageInSpineIndex],PAGE_KEY,[NSString stringWithFormat:@"%d",currentTextSize],FONT_SIZE,[NSString stringWithFormat:@"%d",[self getGlobalPageCount]-1],TOTAL_NUMBER, nil];
    if ([UserDefaults isBookmarkNotExist:bookId withPage:currentPageDict]) {
        [UserDefaults addBookmark:bookId withPage:currentPageDict];
        [self.bookmarkButton setImage:[UIImage imageNamed:@"bookmark1.png"] forState:UIControlStateNormal];
       
    }else{
        [UserDefaults removeBookmark:bookId withPage:currentPageDict];
        [self.bookmarkButton setImage:[UIImage imageNamed:@"bookmark0.png"] forState:UIControlStateNormal];
    }
    
    
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return NO;
}



#pragma mark
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)reloadPage{
    footerView.frame=CGRectMake(0, 958, 768, 46);
    headerView.frame=CGRectMake(0, 0, 768, 46);
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    isBarsHidden=YES;
    [self hideBars:isBarsHidden isRoladed:YES];
    // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideBars:) userInfo:nil repeats:NO];
    
}



- (void)viewDidUnload {
    [self setBookmarkResultButton:nil];
    [self setBookmarkButton:nil];
    [self setImageWebview:nil];
    [self setImageView:nil];
    [self setSearchButton:nil];
    
    [self setChaptersWebview:nil];
    [self setFooterView:nil];
    [self setHeaderView:nil];
    [self setIndexButton:nil];
    
    [self setBookSearchBar:nil];
    [self setBookmarkButton:nil];
    
    progressBar = nil;
	self.toolbar = nil;
	self.webView = nil;
	self.chapterListButton = nil;
    
	self.pageSlider = nil;
	self.currentPageLabel = nil;
    self.loadedEpub=nil;
}

- (void)dealloc {
    
    [_backView release];
    [_chaptersWebview release];
    [footerView release];
    // self.toolbar = nil;
	//self.webView = nil;
	
    [loadedEpub release];
    [chaptersPopover release];
    [searchResultsPopover release];
    [searchResViewController release];
    [currentSearchResult release];
    // [webView release];
    [progressBar release];
    [bookmarkButton release];
    
    [bookSearchBar release];
    
    [optionButton release];
    [indexButton release];
    [headerView release];
    
    [webView release];
    
    [toolbar release];
    [chapterListButton release];
    [decTextSizeButton release];
    [incTextSizeButton release];
    [currentPageLabel release];
    
    [pageSlider release];
    [currentPageLabel release];
    [chaptersArray release];
    
    [bookmarksPopover release];
    [queue release];
    // [mWindow release];
    [_searchButton release];
    [indicatorView release];
    [indicatorProgress release];
    [_imageView release];
    [_imageWebview release];

    [_bookmarkResultButton release];
    [super dealloc];
    
}

@end
