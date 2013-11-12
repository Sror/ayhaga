//
//  ViewController.m
//  WebScroll
//
//  Created by Marwa Aman on 11/19/12.
//  Copyright (c) 2012 Zein. All rights reserved.
//

#import "ArticleViewController.h"
#import "XMLReader.h"
#import "UIImageView+AFNetworking.h"
#import "UIDevice.h"
@interface ArticleViewController ()

@end


@implementation ArticleViewController
@synthesize webViewArray,imgViewArray, scrollView,categoryArray,toolBar,issueName,Begin,indexView,issueTitle,yearTitle,homeButton;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self ;
}
- (void)viewDidLoad
{
    
    // date Setup
   
    /*
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(pauseTimer)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
     
     
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(resumeTimer)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
     
     */
    
    
    startTime = [[NSDate date] retain];
    endTime = [[NSDate date] retain];
    NSLog(@"%@  , %@",startTime ,endTime);
   
    
    // REGISTER IN ENTER FOREGROUND NOTIFICATION

    articleAdded = NO ;

    // first and last pages
    indexPrevPage = self.categoryArray.count-1 ;
    
    Begin = YES ;
    webViewArray = [[NSMutableArray alloc]init];
    imgViewArray = [[NSMutableArray alloc]init];
    indexImgArray = [[NSMutableArray alloc]init];
    
    refPage = 0;
    currentPage = 0;
    ChangesRight = NO ;
    lastOffset = 0 ;
    ChangesLeft = NO ;
    
    start = 0 ;
    end = 6 ;
   
   // timerStep = 1 ;
    
    self.indexView.alpha = 1 ;
    if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina) {
        self.indexView.frame = CGRectMake(384-self.categoryArray.count*11, 0, self.categoryArray.count*22, 100);
    }else
        self.indexView.frame = CGRectMake(160-self.categoryArray.count*6, 0, self.categoryArray.count*12, 100);
    
    self.navigationController.navigationBar.hidden = YES ;
    
    DQueue = dispatch_queue_create("com.Hindawi.queue", NULL);
    
    //self.backButton.backgroundColor=[UIColor colorWithRed:122.0/255 green:122.0/255 blue:122.0/255 alpha:1];
    self.scrollView.showsHorizontalScrollIndicator = NO ;
    if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina)
        [self.scrollView setContentSize:CGSizeMake(769*[self.categoryArray count], 1024) ];
    else
        [self.scrollView setContentSize:CGSizeMake(321*[self.categoryArray count], [UIScreen mainScreen].bounds.size.height) ];
    
    [self.scrollView setDelaysContentTouches:NO];
    [self.scrollView setMultipleTouchEnabled:NO];
    [self.scrollView setDirectionalLockEnabled:YES];
    // self.scrollView.decelerationRate = 100.0;
    
    UITapGestureRecognizer *Tapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    Tapped.numberOfTapsRequired = 1;
    Tapped.delegate = self;
    [self.scrollView addGestureRecognizer:Tapped];
    
    


    [self loadNewPage:0];
    
    
    for(int i = 0 ; i < [self.categoryArray count]; i++)
    {
        int offset =self.categoryArray.count-1- i ;
        int imgHeight =[[[self.categoryArray objectAtIndex:i] objectForKey:@"bodyHeight"] integerValue]-1000;
        if (imgHeight<0) {
            imgHeight=0;
        }
        UIImageView *indexImageView;
        if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina)
             indexImageView=[[UIImageView alloc] initWithFrame:CGRectMake(( offset )*22, 0, 20, 5+ (imgHeight/150))];
        else
            indexImageView=[[UIImageView alloc] initWithFrame:CGRectMake(( offset )*12, 0, 10, 5+ (imgHeight/400))];
        
        if(i== 0)
            [indexImageView setImage:[UIImage imageNamed:@"pagingHighlight.png"]];
        else
            [indexImageView setImage:[UIImage imageNamed:@"pagingNormal.png"]];
        
        [self.indexView addSubview:indexImageView];
        [indexImgArray addObject:indexImageView];
        [indexImageView release];
        
    }
    
    int offset = self.categoryArray.count-1 ;
    if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina)
        [self.scrollView setContentOffset:CGPointMake(769*(offset), 0)];
    else
        [self.scrollView setContentOffset:CGPointMake(321*(offset), 0)];
    self.scrollView.scrollEnabled = NO ;
    lastOffset = self.scrollView.contentOffset.x;
    prevPage = 0 ;
    

    timerArray = [[NSMutableArray alloc] init];
    savedDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:issueName,@"issueID",timerArray ,@"timeArray" ,nil];
    
   // [self startTimer];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [UIView animateWithDuration:3 animations:^{ self.indexView.alpha = 1 ;  }
                     completion:^(BOOL finished){[UIView animateWithDuration:2 animations:^{self.indexView.alpha = 0 ; }];}];
    
    if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina){
        self.scrollView.frame = CGRectMake(0, 0, 769, 1024);
        self.toolBar.frame = CGRectMake(0, -50, 768, 40);
    }else{
        self.scrollView.frame = CGRectMake(0, 0, 321, [UIScreen mainScreen].bounds.size.height);
        self.toolBar.frame = CGRectMake(0, -50, 320, 40);

    }
    
}




-(void)loadNewPage:(int)articleIndex {
    int offset =self.categoryArray.count-1- articleIndex ;
    UIImageView *backgroundImageView=nil;
    UIWebView *pageWebView=nil;
    if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina){
        backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(( offset )*769, 0, 768, 1024)];
        pageWebView=[[UIWebView alloc] initWithFrame:CGRectMake((offset)*769, 0, 768, 1024)];
    }else{
        backgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(( offset )*321, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        pageWebView=[[UIWebView alloc] initWithFrame:CGRectMake((offset)*321, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    }
    NSString * articleID = [[[self.categoryArray objectAtIndex:articleIndex] objectForKey:@"article"] objectForKey:@"item.number" ] ;
    NSString *imgPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:issueName ] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@c.jpg",articleID]] ;
    
   
    pageWebView.scrollView.delegate = self ; 
    [self.scrollView addSubview:backgroundImageView];
    [self.imgViewArray addObject:backgroundImageView];
    [self.webViewArray addObject:pageWebView];
    [self.scrollView addSubview:pageWebView];
    [pageWebView release];
    [backgroundImageView release];
    
    if(articleIndex == 0 )
    {
        pageWebView.tag = 5 ;
        if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina)
             pageWebView.frame = CGRectMake(pageWebView.frame.origin.x, 281,768, 743) ;
        else
            pageWebView.frame = CGRectMake(pageWebView.frame.origin.x, 100,320, [UIScreen mainScreen].bounds.size.height-100) ;
        NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:issueName ]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *documentPath = [NSString stringWithFormat:@"%@/",path];
        NSURL *baseUrl=[NSURL URLWithString:documentPath];
        pageWebView.opaque = NO;
        pageWebView.backgroundColor = [UIColor clearColor];
        pageWebView.delegate=self;
        pageWebView.hidden =YES;
        pageWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        NSDictionary *articleObject = [self.categoryArray objectAtIndex:articleIndex];
        NSString *body =  [[articleObject objectForKey:@"article"] objectForKey:@"html"];
        NSString *html ;
        
        if(articleIndex == 0 )
            html = body ;
        
        else{
            
            
            
            if([UIDevice deviceType]== iPad || [UIDevice deviceType] == iPadRetina)
                html=[NSString stringWithFormat:@"<html><head><script>function testSp(){window.location.href = 'finish';}window.onload=testSp;</script><link rel=\"stylesheet\" type=\"text/css\" href=\"./style.css\">/head><body style = 'padding:%fpx 0px 24px 0px; opacity:0.95;' >%@</body></html>",(([UIScreen mainScreen].bounds.size.height-20)-[[[self.categoryArray objectAtIndex:articleIndex] objectForKey:@"headerHeight"] integerValue]),body];
            else
                html=[NSString stringWithFormat:@"<html><head><script>function testSp(){window.location.href = 'finish';}window.onload=testSp;</script><link rel=\"stylesheet\" type=\"text/css\" href=\"./style.css\"></head><body style = 'padding:%fpx 0px 12px 0px; opacity:0.95;' >%@</body></html>",(([UIScreen mainScreen].bounds.size.height-20)-[[[self.categoryArray objectAtIndex:articleIndex] objectForKey:@"headerHeight"] integerValue]),body];
        
        
                  
        }
        
        
        for (UIView* subView in [pageWebView subviews])
        {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView* shadowView in [subView subviews])
                {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        [shadowView setHidden:YES];
                    }
                }
            }
        }
        
        [pageWebView loadHTMLString:html baseURL:baseUrl];
        
 
    }

        
    backgroundImageView.image = [UIImage imageWithContentsOfFile:imgPath];
    
    
}

-(void)loadHtml:(UIWebView *)pageWebView article:(int)articleIndex
{
    
    
    NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:issueName ]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *documentPath = [NSString stringWithFormat:@"%@/",path];
    NSURL *baseUrl=[NSURL URLWithString:documentPath];
    pageWebView.opaque = NO;
    pageWebView.backgroundColor = [UIColor clearColor];
    pageWebView.delegate=self;
    pageWebView.hidden =YES;
    pageWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    
    NSDictionary *articleObject = [self.categoryArray objectAtIndex:articleIndex];
    NSString *body =  [[articleObject objectForKey:@"article"] objectForKey:@"html"];

    NSString *html ;
    if(articleIndex == 0 )
        html = body ;
    
    else{
        if([UIDevice deviceType]== iPad || [UIDevice deviceType] == iPadRetina)
             html=[NSString stringWithFormat:@"<html><head><script>function testSp(){window.location.href = 'finish';}window.onload=testSp;</script><link rel=\"stylesheet\" type=\"text/css\" href=\"./style.css\"></head><body style = 'padding:%fpx 0px 24px 0px; opacity:0.95;' >%@</body></html>",([UIScreen mainScreen].bounds.size.height-20)-[[[self.categoryArray objectAtIndex:articleIndex] objectForKey:@"headerHeight"] integerValue],body];
        else
             html=[NSString stringWithFormat:@"<html><head><script>function testSp(){window.location.href = 'finish';}window.onload=testSp;</script><link rel=\"stylesheet\" type=\"text/css\" href=\"./style.css\"></head><body style = 'padding:%fpx 0px 12px 0px; opacity:0.95;' >%@</body></html>",([UIScreen mainScreen].bounds.size.height-20)-[[[self.categoryArray objectAtIndex:articleIndex] objectForKey:@"headerHeight"] integerValue],body];
   
    
    
        
        

    }
    for (UIView* subView in [pageWebView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
    
    [pageWebView loadHTMLString:html baseURL:baseUrl];
    

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    

    
   // toolBar.frame  = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  -44) ;
    self.indexView.hidden = YES ;
    if(toolBar.frame.origin.y  <0)
    {
        [UIView animateWithDuration:0.2  animations:^{ self.toolBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40); }];
        toolBar.hidden = NO ; 
    
    }
    else
        [UIView animateWithDuration:0.2  animations:^{ self.toolBar.frame = CGRectMake(0, -44, [UIScreen mainScreen].bounds.size.width, 40); }];
    self.toolBar.hidden = NO ;
    [self.view bringSubviewToFront:self.toolBar];
    homeButton.hidden = NO ;

    

}






-(void)SaveData
{
    
  if(prevPage != 0 && articleAdded)
  {
    endTime = [NSDate date] ;
      
      NSTimeInterval interval = [endTime timeIntervalSinceDate:startTime];
    NSDictionary *articleTime = [[NSDictionary alloc] initWithObjectsAndKeys:[[[self.categoryArray objectAtIndex:prevPage]  objectForKey:@"article" ]objectForKey:@"item.number"] ,@"articleID",[NSString stringWithFormat:@"%d",(int)interval ],@"timeSpentReading",startTime,@"timeOpened", nil];
    
    [timerArray addObject:articleTime];
      articleAdded = NO ;
      [articleTime release];
  }
    
    
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
    
    
    [savedDict setObject:timerArray forKey:@"timeArray"];
    
    [usageData addObject:savedDict];
    [usageData writeToFile:path atomically:YES];
    [timerArray removeAllObjects];

    [usageData release] ;
}


-(IBAction)back:(id)sender
{
    //[timer invalidate];
    
    
       dispatch_suspend(DQueue);
       for (int i = 0 ; i < webViewArray.count ; i++)
       {
          UIWebView *web = (UIWebView *)[self.webViewArray objectAtIndex:i];
          [web stopLoading];
          [web setDelegate:nil];
        
       }
       [self.navigationController popViewControllerAnimated:YES];
   
}



- (void) webViewDidFinishLoad:(UIWebView*)webView
{
    if(webView.tag == 5 )
    {
        webView.tag = 2 ;
        for (int index = 1 ; index <7 ; index ++ )
        {
            if (index ==[categoryArray count]) {
                
                break;
            }
            [self loadNewPage:index];
        }
        
        scrollView.scrollEnabled = YES;
        for(int index = 1 ; index <7 ; index++)
        {
            
            if (index ==[categoryArray count]) {
                break;
            }
            UIWebView *pageWebView = (UIWebView *)[webViewArray objectAtIndex:index];
            dispatch_async(DQueue, ^(void){ [self loadHtml:pageWebView article:index]; });
        }
    }
    
    
    
   [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function remove() {var i;var els = document.getElementsByTagName(\"a\");for(i=0 ; i<els.length ; i++){els[i].removeAttribute(\"href\"); }}"]];
    
    [webView stringByEvaluatingJavaScriptFromString:@"remove();"];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function test() {var i;var els = document.getElementsByClassName(\"image_itself\");for(i=0 ; i<els.length ; i++){els[i].addEventListener(\"click\",function(){window.location.href =this.src+'.png' ;});}}"]];
    
    [webView stringByEvaluatingJavaScriptFromString:@"test();"];
  
    //  [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"function anchor() {var i;var els = document.getElementsByTagName(\"a\");for(i=0 ; i<els.length ; i++){els[i].addEventListener(\"click\",function(){window.location.href =this.href+'.png' ;});  }}"]];
    // [webView stringByEvaluatingJavaScriptFromString:@"anchor();"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *theAnchor = [[request URL] absoluteString];
     NSLog(@"%@",theAnchor);
    if ([theAnchor rangeOfString:@"finish"].location !=NSNotFound) {
        if( webView.tag==0){
            webView.hidden=NO;
            return NO;
        }
        else if(webView.tag == 2)
        {
            webView.hidden = NO ;
            double paddingValue=([UIScreen mainScreen].bounds.size.width*0.52)*.7025;
            NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
            NSLog(@"%f",paddingValue);
            if ([UIDevice deviceType]==iPad || [UIDevice deviceType]==iPadRetina)
                webView.frame = CGRectMake(webView.frame.origin.x, paddingValue,768, 743) ;
           // else if( [UIDevice deviceType]==iPhone)
             //   webView.frame = CGRectMake(webView.frame.origin.x, paddingValue ,320, [UIScreen mainScreen].bounds.size.height-paddingValue) ;
            else 
                webView.frame = CGRectMake(webView.frame.origin.x, 140 ,320, [UIScreen mainScreen].bounds.size.height-140) ;
            
            webView.tag = 0 ;
            return NO ;
        }
        
    }
    
    else if ([[[request URL] absoluteString] rangeOfString:@".png" options:NSRegularExpressionSearch].location != NSNotFound || [[[request URL] absoluteString] rangeOfString:@".jpg" options:NSRegularExpressionSearch].location != NSNotFound || [[[request URL] absoluteString] rangeOfString:@".svg" options:NSRegularExpressionSearch].location != NSNotFound){
        //[self hideBars:isBarsHidden isRoladed:NO];
       // NSString *CSS=[[NSString alloc] initWithData:[UserDefaults getDataWithName:@"style.css" inRelativePath:nil inDocument:NO] encoding:NSUTF8StringEncoding];
        NSString *imageHtml=[NSString stringWithFormat:@"<html class=\"pop_image\"><head><style></style></head><body><img src=\"%@\" /></body></html>",[[[request URL] absoluteString] substringToIndex:[[[request URL] absoluteString] length]-4]];
        
        //[CSS release];
        //NSLog(@"%@",imageHtml);

        
    }
     
    else{
        return YES;
    }
    
    return YES;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)ascrollView
{
  if([ascrollView superview].class != [UIWebView class])
  {
    float currentPosition = self.scrollView.contentOffset.x;
    
    currentPage = nearbyintf(currentPosition/([UIScreen mainScreen].bounds.size.width+1));
    
    int currentIndex = self.categoryArray.count -1-currentPage ;
    self.indexView.hidden = NO ;
    [UIView animateWithDuration:0.2 animations:^{self.indexView.alpha = 1 ; } ];
    toolBar.frame = CGRectMake(0, -44, [UIScreen mainScreen].bounds.size.width, 40);
    
    if(currentPage != refPage)
    {
        if(prevPage != 0 && articleAdded== YES )
        {
            endTime = [NSDate date] ;
            NSTimeInterval interval = [endTime timeIntervalSinceDate:startTime];
            
          NSDictionary *articleTime = [[NSDictionary alloc] initWithObjectsAndKeys:[[[self.categoryArray objectAtIndex:prevPage]  objectForKey:@"article" ]objectForKey:@"item.number"] ,@"articleID",[NSString stringWithFormat:@"%d",(int)interval],@"timeSpentReading",startTime,@"timeOpened", nil] ;
        
         // float executionTime = (clock()-(float)startClock) / CLOCKS_PER_SEC;
           
            
          NSLog(@"time ------- %d",(int)interval) ;
          [timerArray addObject:articleTime];
            
            articleAdded = NO ;
            [articleTime release] ; 
        }
        
 
        int diff = abs(prevPage-currentIndex) ;
        if(diff > 1 )
        {
            if(lastOffset > self.scrollView.contentOffset.x)
            {
                for(int x = prevPage+1 ; x< currentIndex ; x++)
                {
                    lastOffset = (x+(diff*6)) *([UIScreen mainScreen].bounds.size.width+1) ;
                    [self replaceHiddenWeb:x ];
                    lastOffset = (x+(diff*6)) *([UIScreen mainScreen].bounds.size.width+1) ;
                }
            }
            
            else if(lastOffset<self.scrollView.contentOffset.x)
            {
                for(int x = prevPage-1 ; x>currentIndex ; x--)
                {
                    lastOffset = (x-(diff*6)) *([UIScreen mainScreen].bounds.size.width+1) ;
                    [self replaceHiddenWeb:x ];
                    lastOffset = (x-(diff*6)) *([UIScreen mainScreen].bounds.size.width+1) ;
                }
            }
            
            
        }
        
        UIImageView *indexImgPrev = (UIImageView *)[indexImgArray objectAtIndex:[self.categoryArray count]-1-refPage];
        [indexImgPrev setImage:[UIImage imageNamed:@"pagingNormal.png"]];
        UIImageView *indexImg = (UIImageView *)[indexImgArray objectAtIndex:[self.categoryArray count]-1-currentPage];
        [indexImg setImage:[UIImage imageNamed:@"pagingHighlight.png"]];
       
        //lastOffset = prevPage *769 ;
        prevPage = currentIndex ;
        refPage = currentPage;
        [self replaceHiddenWeb:currentIndex ];
    
        
        startTime = [[NSDate date] retain] ;
      //  startClock = clock();
    
    }
  }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollVieww
{
    if([scrollVieww superview].class == [UIWebView class] && !articleAdded)
            articleAdded = YES ;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollVieww
{
    
    if([scrollVieww superview].class != [UIWebView class])
    [UIView animateWithDuration:1 animations:^{self.indexView.alpha = 0 ; } completion:^(BOOL finished){self.indexView.hidden = YES ; }];
}


- (void)replaceHiddenWeb :(int)currentIndex
{
    // update page
    if(lastOffset > self.scrollView.contentOffset.x )
    {
        lastOffset = self.scrollView.contentOffset.x ;
        if(currentIndex >= self.categoryArray.count-3 || currentIndex <= 3)
            return ;
        dispatch_sync( DQueue, ^(void) {  [self addWebatIndex:currentIndex+3 inArray:start];});
        ChangesRight = YES  ;
    }
    
    else if(lastOffset < self.scrollView.contentOffset.x)
    {
        
        lastOffset = self.scrollView.contentOffset.x ;
        if(currentIndex <= 2  || currentIndex >= self.categoryArray.count-4 )
            return ;
        ChangesLeft = YES ;
        //dispatch_sync( DQueue, ^(void) {
        
        [self addWebatIndex:currentIndex-3 inArray:end];//});
    }
    
    
    // update refrence
    if(ChangesRight)
    {
        if(start < 6 )
        {
            start++ ;
            if(end < 6 )
                end ++ ;
            else end = 0 ;
        }
        else
        {
            start = 0 ;
            end ++ ;
        }
        ChangesRight = NO ;
        
    }
    
    if(ChangesLeft)
    {
        ChangesLeft = NO ;
        if(start > 0 )
        {
            start -- ;
            if(end>0)
                end -- ;
            else
                end = 6   ;
        }
        else
        {
            start = 6 ;
            end -- ;
        }
    }
}

-(void)addWebatIndex :(int) articleIndex  inArray:(int)arrayIndex
{
    
    UIWebView *web = (UIWebView *)[self.webViewArray objectAtIndex:arrayIndex];
    
    web.tag = 0 ;
    
    int offSet = self.categoryArray.count-1-articleIndex ;
    NSDictionary *articleObject = [self.categoryArray objectAtIndex:articleIndex];
    
    
    web.hidden = YES ;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [web stopLoading];
    web.delegate = nil ;
    
    NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:issueName ]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *documentPath = [NSString stringWithFormat:@"%@/",path];
    NSURL *baseUrl=[NSURL URLWithString:documentPath];
 
    NSString *body =  [[articleObject objectForKey:@"article"] objectForKey:@"html"];
    NSString *html=nil ;
    NSString * articleID = [[articleObject objectForKey:@"article"] objectForKey:@"item.number" ];
    
    UIImageView *img = (UIImageView *)[self.imgViewArray objectAtIndex:arrayIndex];
    
    NSString *imgPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]  stringByAppendingPathComponent:issueName ] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@c.jpg",articleID]] ;
    img.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width+1)* offSet, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    img.image = [UIImage imageWithContentsOfFile:imgPath];

    
    if(articleIndex == 0)
        html = body ;
    
    else{
        
        
             
        
        if([UIDevice deviceType]== iPad || [UIDevice deviceType] == iPadRetina)
             html=[NSString stringWithFormat:@"<html><head><script>function testSp(){window.location.href = 'finish';}window.onload=testSp;</script><link rel=\"stylesheet\" type=\"text/css\" href=\"./style.css\"></head><body style = 'padding:%fpx 0px 24px 0px;opacity:0.95; ' >%@</body></html>",([UIScreen mainScreen].bounds.size.height-20)-[[[self.categoryArray objectAtIndex:articleIndex] objectForKey:@"headerHeight"] integerValue],body];
        else
             html=[NSString stringWithFormat:@"<html><head><script>function testSp(){window.location.href = 'finish';}window.onload=testSp;</script><link rel=\"stylesheet\" type=\"text/css\" href=\"./style.css\"></head><body style = 'padding:%fpx 0px 12px 0px;opacity:0.95; ' >%@</body></html>",([UIScreen mainScreen].bounds.size.height-20)-[[[self.categoryArray objectAtIndex:articleIndex] objectForKey:@"headerHeight"] integerValue],body];
        
        
    }
    
    [web loadHTMLString:html baseURL:baseUrl];
    web.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width+1)*offSet, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    web.delegate = self ;
       
    web.hidden = YES ;
    if(articleIndex == 0 )
        web.tag = 2 ;
    else if(articleIndex == self.categoryArray.count-1)
        web.tag = 1 ;
    
}


/*
- (void)increaseTimerCount
{
    timerCount = timerStep+timerCount ;
    
   // NSLog(@"increase timer count %d",timerCount);
}

- (IBAction)startTimer
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
     timerCount = 0 ;
   // NSLog(@"start timer count %d",timerCount);

    
}
-(void)stopTimer
{
     // [timer invalidate];
    
       timerCount = 0 ;
}

-(void)pauseTimer
{
    timerStep = 0;
}

-(void)resumeTimer
{
    timerStep = 1 ;

}
 
 */
-(void)dealloc{
    
 //   timer = nil ;
  //  [timer release];
    [timerArray release] ;
    [savedDict release] ;
    //[usageData release] ;
    [scrollView release];
    [toolBar release];
    [imgViewArray release];
    [webViewArray release];
    [issueName release];
    [indexView release];
    [categoryArray release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self SaveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

@end