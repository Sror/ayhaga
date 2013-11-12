

#import "HorizontalTableCell.h"
#import "BookCell.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"
#import "UserDefaults.h"
#import "EPubViewController.h"
#import "NetworkService.h"
#import "ArabicConverter.h"
#import "UsageData.h"

@implementation HorizontalTableCell
@synthesize horizontalTableView = _horizontalTableView;
@synthesize booksArray,viewController,booksInDownloading,categoryName,categoryID,categoryIndex,styleUrl,titleLabel,seeMoreButton,CSSId;

- (id)initWithIsLastCategory:(BOOL)isLastCategory withBook:(NSArray *)books
{
    if ((self = [super init]))
    {
        
        self.booksArray=[NSArray arrayWithArray:books];
        // self.booksArray = [[books reverseObjectEnumerator] allObjects];
        UILabel *arrowLabel=[[UILabel alloc] initWithFrame:CGRectMake(725, 0, 15, 20)];
        arrowLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:27];
        arrowLabel.backgroundColor=[UIColor clearColor];
        arrowLabel.textColor=[UIColor colorWithRed:122.0/255 green:120.0/255 blue:5.0/255 alpha:1.0];
        arrowLabel.text=@"«";
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(597, 2, 125, 20)];
        titleLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:18];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=NSTextAlignmentRight;
        titleLabel.textColor=[UIColor whiteColor];
        
        NSString *ArabicString = @"مشاهدة الكل" ;
        ArabicConverter *converter = [[ArabicConverter alloc] init];
        if([UsageData getiOSVersion]<7)
           ArabicString = [converter convertArabic:ArabicString];
        
        //   categoryName=[converter convertArabic:categoryName];
        
        seeMoreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        seeMoreButton.titleLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:18];
        [seeMoreButton setTitle:ArabicString forState:UIControlStateNormal];
        seeMoreButton.frame=CGRectMake(32,2, 85, 20);
        [seeMoreButton setTitleColor:[UIColor colorWithRed:122.0/255 green:120.0/255 blue:5.0/255 alpha:1.0] forState:UIControlStateNormal];
        //  [seeMoreButton setTitleColor:[UIColor colorWithRed:50.0/255 green:100.0/255 blue:5.0/255 alpha:1.0] forState:UIControlStateHighlighted];
        [seeMoreButton addTarget:self.viewController action:@selector(openCategory:) forControlEvents:UIControlEventTouchUpInside];
        
        self.horizontalTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 36, 203, 768)] autorelease] ;
        self.horizontalTableView.showsVerticalScrollIndicator = NO;
        self.horizontalTableView.showsHorizontalScrollIndicator = NO;
        // self.horizontalTableView.style=UITableViewStylePlain;
        self.horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
        
        [self.horizontalTableView setFrame:CGRectMake(0, 36, 768, 203)];
        self.horizontalTableView.rowHeight = 184;
        
        self.horizontalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.horizontalTableView.separatorColor = [UIColor clearColor];
        
        self.horizontalTableView.backgroundColor=[UIColor clearColor];
        self.horizontalTableView.dataSource = self;
        self.horizontalTableView.delegate = self;
        //  self.horizontalTableView.bounces=YES;
        
        if (!isLastCategory) {
            UIImageView *tailImage=[[UIImageView alloc] initWithFrame:CGRectMake(32, 271, 704, 2)];
            tailImage.image=[UIImage imageNamed:@"shadow_sep.png"];
            [self addSubview:tailImage];
            [tailImage release];
        }
        [self addSubview:arrowLabel];
        [self addSubview:titleLabel];
        [self addSubview:seeMoreButton];
        [self addSubview:self.horizontalTableView];
        // [self.horizontalTableView release];
        [self.titleLabel release];
        
        if (!networkQueue) {
            networkQueue = [[ASINetworkQueue alloc] init];
        }
        [networkQueue reset];
        [networkQueue setRequestDidFinishSelector:@selector(imageFetchComplete:)];
        [networkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
        [networkQueue setShowAccurateProgress: YES];
        [networkQueue setDelegate:self];
        [networkQueue go];
        
        self.booksInDownloading=[NSMutableArray array];
        [converter release];
    }
    
    return self;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ArabicConverter *converter = [[ArabicConverter alloc] init];
     if([UsageData getiOSVersion]<7)
       titleLabel.text=[converter convertArabic:categoryName];
    else
        titleLabel.text=categoryName;
    [converter release];
    seeMoreButton.tag= categoryIndex;
    if ([self.booksArray count]< 10)
        seeMoreButton.hidden=YES;
    if ([self.booksArray count]<4) {
        isLessThan4=YES;
        tableView.scrollEnabled=NO;
        
        return 4;
    }
    return [self.booksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    
    __block BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[BookCell alloc] initWithFrame:CGRectMake(0, 0, kCellWidth_iPad, kCellHeight_iPad)] autorelease];
        
        // cell.tag=[[[self.booksArray objectAtIndex:indexPath.row] objectForKey:@"item.number"] intValue];
    }
    
    //cell.progressView.hidden=YES;
    
    if (!isLessThan4) {
        
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __block NSDictionary *currentBook = [self.booksArray objectAtIndex:indexPath.row];
                
                if ([UserDefaults isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]) {
                    cell.downloadedImage.hidden=YES;
                }else
                    cell.downloadedImage.hidden=NO;
                
                if ([self isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]) {
                    cell.progressView.hidden=NO;
                    cell.userInteractionEnabled=NO;
                }else{
                    cell.progressView.hidden=YES;
                    cell.userInteractionEnabled=YES;
                }
                
                if ([UserDefaults isBookInDwonloadingWithID:[currentBook objectForKey:@"item.number"]] && ![self isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]) {
                    cell.indicatorView.hidden=NO;
                    [cell.indicatorView startAnimating];
                    cell.userInteractionEnabled=NO;
                }else{
                    cell.indicatorView.hidden=YES;
                    [cell.indicatorView stopAnimating];
                    cell.userInteractionEnabled=YES;
                }
                NSData *thumbImg=[UserDefaults getDataWithName:[NSString stringWithFormat:@"%@t%@.jpg",[currentBook objectForKey:@"image.lastmodified.date"],[currentBook objectForKey:@"item.number"]] inRelativePath:@"/books" inDocument:YES];
                if (thumbImg) {
                    [cell.thumbnail setImage:[UIImage imageWithData:thumbImg]];
                }
                else
                    [cell.thumbnail setImageWithURL:[NSURL URLWithString:[[currentBook objectForKey:@"thumb.url"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]Date:[currentBook objectForKey:@"image.lastmodified.date"]];
                
                // NSURL *url=[NSURL URLWithString:[[currentBook objectForKey:@"thumb.url"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                // [cell.thumbnail setImageWithURL:url];
            });
        });
        
    }else if(4-indexPath.row <=[self.booksArray count])
    {
        
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __block NSDictionary *currentBook = [self.booksArray objectAtIndex:3-indexPath.row];
                if ([UserDefaults isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]) {
                    cell.downloadedImage.hidden=YES;
                }else
                    cell.downloadedImage.hidden=NO;
                
                if ([self isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]) {
                    cell.progressView.hidden=NO;
                    cell.userInteractionEnabled=NO;
                }else{
                    cell.progressView.hidden=YES;
                    cell.userInteractionEnabled=YES;
                }
                
                if ([UserDefaults isBookInDwonloadingWithID:[currentBook objectForKey:@"item.number"]] && ![self isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]) {
                    cell.indicatorView.hidden=NO;
                    [cell.indicatorView startAnimating];
                    cell.userInteractionEnabled=NO;
                }else{
                    cell.indicatorView.hidden=YES;
                    [cell.indicatorView stopAnimating];
                    cell.userInteractionEnabled=YES;
                }
                NSData *thumbImg=[UserDefaults getDataWithName:[NSString stringWithFormat:@"%@t%@.jpg",[currentBook objectForKey:@"image.lastmodified.date"],[currentBook objectForKey:@"item.number"]] inRelativePath:@"/books" inDocument:YES];
                if (thumbImg) {
                    [cell.thumbnail setImage:[UIImage imageWithData:thumbImg]];
                }
                else
                    [cell.thumbnail setImageWithURL:[NSURL URLWithString:[[currentBook objectForKey:@"thumb.url"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]Date:[currentBook objectForKey:@"image.lastmodified.date"]];
                
            });
        });
    }else
        cell.hidden=YES;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 184;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)] autorelease];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor blackColor]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *currentBook=nil;
    if (isLessThan4)
        currentBook = [self.booksArray objectAtIndex:3-indexPath.row];
    else
        currentBook = [self.booksArray objectAtIndex:indexPath.row];
    
    if (![UserDefaults isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]] && ![self isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]) {
        // BookCell *cell = (BookCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        int rowIndex=indexPath.row;
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"هل ترغب في تحميل كتاب %@؟",[currentBook objectForKey:@"title"]] delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم",nil];
        alertView.tag=rowIndex;
        [alertView show];
        [alertView release];
        
    }else if ([UserDefaults isBookDwonloadedWithID:[currentBook objectForKey:@"item.number"]]){
        [NSThread detachNewThreadSelector:@selector(showIndicator) toTarget:self.viewController withObject:nil];
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:@"/books"];
        NSString *dataPath = [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.epub",[currentBook objectForKey:@"item.number"]]];
        EPubViewController *ePubViewController=[[EPubViewController alloc] initWithUrl:[NSURL fileURLWithPath:dataPath] withID:[currentBook objectForKey:@"item.number"]];
        ePubViewController.bookId=[currentBook objectForKey:@"item.number"] ;
        
        if([UsageData getiOSVersion]==7)
        {
           self.viewController.hidesBottomBarWhenPushed = YES ;
            
              self.viewController.tabBarController.tabBar .hidden = YES ;
       
        }
        [self.viewController.navigationController pushViewController:ePubViewController animated:YES];
        [ePubViewController release];
        [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self.viewController withObject:nil];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        // NSLog(@"11111111");
        if ([[NetworkService getObject] checkInternetWithData]){
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:alertView.tag inSection:0];
            BookCell *cell=(BookCell *)[self.horizontalTableView cellForRowAtIndexPath:indexPath];
            cell.userInteractionEnabled=NO;
            cell.progressView.hidden=NO;
            
            int rowIndex=0;
            if (isLessThan4) {
                rowIndex=3-indexPath.row;
            }else
                rowIndex=indexPath.row;
            
            totalBytesReceived =0;
            NSDictionary *currentBook = [self.booksArray objectAtIndex:rowIndex];
            //  NSLog(@"%@",[currentBook objectForKey:@"download.url"]);
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[currentBook objectForKey:@"download.url"]]];
            request.delegate = self;
            NSString * bname = [[[[self.booksArray objectAtIndex:rowIndex] objectForKey:@"item.number"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByAppendingString:@".epub"];
            [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/books"] stringByAppendingPathComponent:bname]];
            [request setDownloadProgressDelegate:cell.progressView];
            [request setAllowResumeForFileDownloads:YES];
            [request setShouldContinueWhenAppEntersBackground:YES];
            //[request setTotalBytesRead:1000];
            [request setDidReceiveDataSelector:@selector(request:didReceiveBytes:)];


           /* NSLog(@"bytes - = %lld",request.totalBytesRead);
            
            [request setBytesReceivedBlock:^(unsigned long long length, unsigned long long total) {
                
                totalBytesReceived += length;
                NSLog(@"totalBytesReceived =%lli  , %lli",totalBytesReceived, total);
                if(totalBytesReceived >= 1000 )
                {
                    [self performSelector:@selector(imageFetchComplete:) withObject:nil];
                    [request clearDelegatesAndCancel];
                }
            }];*/
            [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",rowIndex] forKey:@"name"]];
            [networkQueue addOperation:request ];
            
            [self.booksInDownloading addObject:[currentBook objectForKey:@"item.number"]];
            [UserDefaults addDownloadingBookWithID:[currentBook objectForKey:@"item.number"]];
        }else{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"معذرة لا يمكنك تحميل الكتاب في الوقت الحالي؛ نظرًا لتعذر الاتصال بالإنترنت" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    
}

/*
 -(void)downloadBook:(UITableViewCell *)sender{
 BookCell *cell = (BookCell *)sender;
 cell.userInteractionEnabled=NO;
 cell.progressView.hidden=NO;
 int rowIndex=0;
 if (isLessThan4) {
 rowIndex=3-indexPath.row;
 }else
 rowIndex=indexPath.row;
 
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[currentBook objectForKey:@"download.url"]]];  //
 request.delegate = self;
 NSString * bname = [[[[self.booksArray objectAtIndex:rowIndex] objectForKey:@"item.number"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByAppendingString:@".epub"];
 [request setDownloadDestinationPath:[[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:bname]];
 [request setDownloadProgressDelegate:cell.progressView];
 [request setAllowResumeForFileDownloads:YES];
 [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"name"]];
 [networkQueue addOperation:request ];
 [self.booksInDownloading addObject:[[self.booksArray objectAtIndex:rowIndex] objectForKey:@"item.number"]];
 }
 */

-(BOOL)isBookDwonloadedWithID:(NSString *)bookID{
    for (int index=0; index<[booksInDownloading count]; index++) {
        if ([[booksInDownloading objectAtIndex:index] isEqualToString:bookID]) {
            return YES;
        }
    }
    return NO;
}
-(void)removeBookWithID:(NSString *)bookID{
    
    for (int index=0; index<[booksInDownloading count]; index++) {
        if ([[booksInDownloading objectAtIndex:index] isEqualToString:bookID]) {
            [booksInDownloading removeObjectAtIndex:index];
            break;
        }
    }
}





#pragma HTTP Delegates...........


- (void)imageFetchComplete:(ASIHTTPRequest *)request
{
    NSString *index=[request.userInfo objectForKey:@"name"];
    int currentIndexInRow=index.intValue;
    int indexInArray=currentIndexInRow;
    
    if (isLessThan4) {
        currentIndexInRow=3-currentIndexInRow;
    }
    
    NSDictionary *recordDict=[self.booksArray objectAtIndex:indexInArray];
    
    if ([request responseStatusCode] != 200) {
        [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"%@.epub",[recordDict objectForKey:@"item.number"]]];
    }
    [NSThread detachNewThreadSelector:@selector(downloadCoverWithRecord:) toTarget:self withObject:index];
}
-(IBAction)downloadGO {
    [networkQueue go];
}


/*- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    NSLog(@"%d",[data length]);
    
  
    
}*/
- (IBAction)fetchFileSizeFinished:(ASIHTTPRequest *)request
{
    //  NSLog(@"%llD",request.contentLength);
    
}
- (void)imageFetchFailed:(ASIHTTPRequest *)request
{
    int currentIndexInRow=[[request.userInfo objectForKey:@"name"] intValue];
    int indexInArray=currentIndexInRow;
    
    if (isLessThan4) {
        currentIndexInRow=3-currentIndexInRow;
    }
    
    NSDictionary *recordDict=[self.booksArray objectAtIndex:indexInArray];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentIndexInRow inSection:0];
    BookCell *cell = (BookCell *)[self.horizontalTableView cellForRowAtIndexPath:indexPath];
    cell.userInteractionEnabled=YES;
    cell.progressView.hidden=YES;
    [self removeBookWithID:[recordDict objectForKey:@"item.number"]];
    [UserDefaults removeDownloadingBookWithID:[recordDict objectForKey:@"item.number"]];
    [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
    
}

-(void)downloadCoverWithRecord:(NSString *)index{
    int currentIndexInRow=index.intValue;
    int indexInArray=currentIndexInRow;
    
    if (isLessThan4) {
        currentIndexInRow=3-currentIndexInRow;
    }
    
    NSDictionary *recordDict=[self.booksArray objectAtIndex:indexInArray];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentIndexInRow inSection:0];
    BookCell *cell = (BookCell *)[self.horizontalTableView cellForRowAtIndexPath:indexPath];
    
    NSData *book=[UserDefaults getDataWithName:[NSString stringWithFormat:@"%@.epub",[recordDict objectForKey:@"item.number"]] inRelativePath:@"/books" inDocument:YES];
    if (!book) {
        cell.userInteractionEnabled=YES;
        cell.progressView.hidden=YES;
        [self removeBookWithID:[recordDict objectForKey:@"item.number"]];
        [UserDefaults removeDownloadingBookWithID:[recordDict objectForKey:@"item.number"]];
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        return;
    }else{
        NSDictionary *bookSize=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"download.size/book/%@.epub",[recordDict objectForKey:@"item.number"]]];
        if (!bookSize || abs([[bookSize objectForKey:@"result"] intValue]-book.length)>20000) {
            cell.userInteractionEnabled=YES;
            cell.progressView.hidden=YES;
            [self removeBookWithID:[recordDict objectForKey:@"item.number"]];
            [UserDefaults removeDownloadingBookWithID:[recordDict objectForKey:@"item.number"]];
            [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
            return;
        }
    }
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[recordDict objectForKey:@"cover.url"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ]]];
    NSData *coverImg=[NSData dataWithContentsOfURL:url];
    if (coverImg) {
        [UserDefaults saveData:coverImg withName:[NSString stringWithFormat:@"%@c.jpg",[recordDict objectForKey:@"item.number"]] inRelativePath:@"/books" inDocument:YES];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.progressView setProgress:9.0f animated:NO];
            });
        });
    }else{
        cell.userInteractionEnabled=YES;
        cell.progressView.hidden=YES;
        [self removeBookWithID:[recordDict objectForKey:@"item.number"]];
        [UserDefaults removeDownloadingBookWithID:[recordDict objectForKey:@"item.number"]];
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    
    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[recordDict objectForKey:@"thumb.url"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ]]];
    coverImg=[NSData dataWithContentsOfURL:url];
    if (coverImg) {
        [UserDefaults saveData:coverImg withName:[NSString stringWithFormat:@"t%@.jpg",[recordDict objectForKey:@"item.number"]] inRelativePath:@"/books" inDocument:YES];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.progressView setProgress:1.0f animated:NO];
            });
        });
    }else{
        cell.userInteractionEnabled=YES;
        cell.progressView.hidden=YES;
        [self removeBookWithID:[recordDict objectForKey:@"item.number"]];
        [UserDefaults removeDownloadingBookWithID:[recordDict objectForKey:@"item.number"]];
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[styleUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ]]];
    coverImg=[NSData dataWithContentsOfURL:url];
    if (coverImg) {
        [UserDefaults deleteItemsAtPathFromCache:@"style.css"];
        [UserDefaults saveData:coverImg withName:[NSString stringWithFormat:@"style.css"] inRelativePath:@"/books" inDocument:YES];
        [UserDefaults addObject:CSSId withKey:CSSID ifKeyNotExists:NO];
        [UserDefaults setCSSIDforBookID:[recordDict objectForKey:@"item.number"] withCSSID:CSSId];
    }else{
        cell.userInteractionEnabled=YES;
        cell.progressView.hidden=YES;
        [self removeBookWithID:[recordDict objectForKey:@"item.number"]];
        [UserDefaults removeDownloadingBookWithID:[recordDict objectForKey:@"item.number"]];
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    
    [self saveDownloadUsageIWthIssuesID:[recordDict objectForKey:@"item.number"]];
    // cell.userInteractionEnabled=YES;
    // cell.progressView.hidden=YES;
    [self removeBookWithID:[recordDict objectForKey:@"item.number"]];
    [UserDefaults removeDownloadingBookWithID:[recordDict objectForKey:@"item.number"]];
    [UserDefaults addBookWithID:[recordDict objectForKey:@"item.number"]];
    
    //  UITabBarItem *barItem= [self.viewController.tabBarController.tabBar.items objectAtIndex:1];
    // barItem.badgeValue=[UserDefaults getBadgesNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:BOOKISDOWNLODED object:nil];
    // [self.horizontalTableView reloadData];
}
-(void)saveDownloadUsageIWthIssuesID:(NSString *)bookID{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"downloadedBooks.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *downloadedBooksArray ;
    
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"downloadedBooks.plist"] ];
        downloadedBooksArray = [[NSMutableArray alloc] init];
    }
    
    else
        downloadedBooksArray = [[NSMutableArray alloc] initWithContentsOfFile: path];
    //
    NSDictionary *downloadBooksDict = [NSDictionary dictionaryWithObjectsAndKeys:bookID,@"itemnumber",[NSDate date] ,@"time", nil];
    [downloadedBooksArray addObject:downloadBooksDict];
    [downloadedBooksArray writeToFile:path atomically:YES];
    [downloadedBooksArray release];
    
}

-(void)showAlert{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"معذرة، حدث خطأ في تحميل الكتاب، برجاء إعادة التحميل في وقت أخر" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

#pragma mark - Memory Management

- (NSString *) reuseIdentifier
{
    return @"HorizontalCell";
}

- (void)dealloc
{
    self.horizontalTableView = nil;
    self.booksArray = nil;
    
    [super dealloc];
}


@end