//
//  CollectionViewController.m
//  Kalimat
//
//  Created by Staff on 4/21/13.
//  Copyright (c) 2013 Staff. All rights reserved.
//

#import "CollectionViewController.h"
#import "NetworkService.h"
#import "FourBooksCell.h"
#import "Constants.h"
#import "UserDefaults.h"
#import "ArabicConverter.h"
#import "UsageData.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController
@synthesize booksArray,reusableCells,categoryId,classType,categoryName;


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (classType == category) {
        self.title=categoryName;
    }
    self.arrowLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:27];
    self.backButton.titleLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:18];
    self.titleLabel.font = [UIFont fontWithName:@"Hacen Casablanca Light" size:18];
    
    ArabicConverter *converter = [[ArabicConverter alloc] init];
    if([UsageData getiOSVersion]<7){
       self.arrowLabel.text=[converter convertArabic:@"«"];
        self.titleLabel.text=[converter convertArabic:categoryName];
        [self.backButton setTitle:[converter convertArabic:@"رجوع"] forState:UIControlStateNormal];
    }
    else{
        self.arrowLabel.text=@"«";
        self.titleLabel.text=categoryName;
        [self.backButton setTitle:@"رجوع" forState:UIControlStateNormal];
    }
    
       
   // self.collectionTableView.backgroundColor=[UIColor blackColor];
   
    if (classType == search) {
        
        
       
        if ([UsageData getiOSVersion]<7) {
            [[[self.bookSearchBar subviews] objectAtIndex:0] setHidden:YES];
            self.bookSearchBar.tintColor=[UIColor clearColor];
            for (UIView *subview in self.bookSearchBar.subviews)
            {
                if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    [subview removeFromSuperview];
                    
                }
                
                /*
                 if ([subview isKindOfClass:[UITextField class]])
                 {
                 UITextField *text = (UITextField*)subview;
                 // text.textAlignment = NSTextAlignmentRight;
                 text.rightViewMode = UITextFieldViewModeAlways;
                 
                 UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                 text.leftView.frame = CGRectMake(10, 5, 19 , 20);
                 cancelButton.frame = CGRectMake(0, 5, 19 , 20);
                 cancelButton.backgroundColor = [UIColor clearColor];
                 [cancelButton setImage:[UIImage imageNamed:@"X_iPad.png"] forState:UIControlStateNormal];//your button image.
                 cancelButton.contentMode = UIViewContentModeScaleToFill;
                 [cancelButton addTarget:self action:@selector(xButtonPressed) forControlEvents:UIControlEventTouchUpInside];//This is the custom event
                 [text setLeftView:cancelButton];
                 [text setLeftViewMode:UITextFieldViewModeAlways];
                 
                 UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mag_iPad.png"]] ;
                 searchIcon.frame = CGRectMake(0, 0, 28, 19);
                 text.rightView.frame = CGRectMake(0, 0, 28, 19);
                 
                 text.rightView = searchIcon ;
                 text.leftView.hidden = YES ;
                 }*/
                
            }

        }
        
        self.arrowLabel.frame=CGRectMake(720, 274, 20, 20);
        self.titleLabel.frame=CGRectMake(523, 276, 200, 20);
        self.collectionTableView.frame=CGRectMake(0, 312, 768, 692);
        if([UsageData getiOSVersion]<7)
           self.titleLabel.text=[converter convertArabic:@"نتائج البحث"];
        else
             self.titleLabel.text=@"نتائج البحث";
        self.arrowLabel.hidden=YES;
        self.titleLabel.hidden=YES;
        self.backButton.hidden=YES;
    }
    
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBooks) name:BOOKISDOWNLODED object:nil];
    self.reusableCells=[NSMutableArray array];
    if (classType== category) {
        [self getBooksForCategory];
        self.bookSearchBar.hidden=YES;
    }else  if (classType== search){
        // self.collectionTableView.frame=CGRectMake(0, 45, 756, 960);
    }
    
    [converter release];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)backView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)xButtonPressed
{
    self.bookSearchBar.text = @"" ;
    
}
-(void)refreshBooks{
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
}
-(void)reload{
    for (int i = 0; i < [self.reusableCells count]; i++)
    {
        FourBooksCell *cell=(FourBooksCell *)[self.reusableCells objectAtIndex:i];
        [cell.horizontalTableView reloadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    //if (classType== category)
    //  [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.collectionTableView reloadData];
    
    
    if([UsageData getiOSVersion] == 7)
    {
        self.tabBarController.tabBar .hidden = NO ;
        self.hidesBottomBarWhenPushed = NO ;
        self.tabBarController.tabBar.backgroundColor = [UIColor blackColor];
        
    }
    
    //
    
}
-(void) viewWillDisappear:(BOOL)animated{
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
  
}

#pragma Searchbar Delegate......
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.bookSearchBar resignFirstResponder];
    self.arrowLabel.hidden=NO;
    self.titleLabel.hidden=NO;
    [NSThread detachNewThreadSelector:@selector(showIndicator) toTarget:self withObject:nil];
    [self getBooksWithText:searchBar.text];
    // [self performSelector:@selector(searchByBook:) withObject:searchBar.text];
}




-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for (UIView *subview in self.bookSearchBar.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *text = (UITextField*)subview;
            text.leftView.hidden = NO ;
        }
    }
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    for (UIView *subview in self.bookSearchBar.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]]) {
            UITextField *text = (UITextField*)subview;
            text.leftView.hidden = YES ;
        }
    }
}

-(void)showIndicator{
    // [self.activityView bringSubviewToFront:self.view];
    
    self.activityView.hidden = NO ;
    [self.indicatorView startAnimating];
}
-(void)hideIndicator{
    self.activityView.hidden = YES ;
    [self.indicatorView stopAnimating];
}
-(void)showAlert{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"معذرة لا يمكنك تحميل الصفحة في الوقت الحالي؛ نظرًا لتعذر الاتصال بالإنترنت" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self withObject:nil];
}


-(void)getBooksForCategory{
    self.reusableCells=[NSMutableArray array];
    NSDictionary *categoriesDict=nil;
    
    if ([[NetworkService getObject] checkInternetWithData]) {
        categoriesDict=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"list/category/%@/%@/books/fields/cover.1536x2048,thumb.304x406,title/index.start/1/page.size/1000/",categoryId,API_TYPE]];
        [UserDefaults addObject:categoriesDict withKey:categoryId ifKeyNotExists:NO];
    }else
        categoriesDict=[UserDefaults getDictionaryWithKey:categoryId];
    
    if (!categoriesDict) {
        
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
        return;
    }
    
    id object =[[[categoriesDict objectForKey:@"list"] objectForKey:@"books"] objectForKey:@"book"];
    if ([object isKindOfClass:[NSDictionary class]]) {
        self.booksArray=[NSMutableArray arrayWithObject:object];
    }else
        self.booksArray=[NSMutableArray arrayWithArray:object];
    
    if ([self.booksArray count] == 1) {
        FourBooksCell *cell = [[FourBooksCell alloc] initWithIsLastCategory:NO withBook:booksArray];
        cell.styleUrl=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.url"];
        //  NSLog(@"%@",[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"] );
        cell.CSSId=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"];
        cell.viewController=self;
        cell.horizontalTableView.contentOffset=CGPointMake(0, [self.booksArray count]*184);
       // cell.booksArray=[NSArray arrayWithArray:booksArray];
        [self.reusableCells addObject:cell];
        [cell release];
    }
    else{
        for (int i = 1; i <= [self.booksArray count]; i++)
        {
            i--;
            BOOL isStart=YES;
           NSMutableArray *rowBooks=[NSMutableArray array];
            while (i % 4 !=0 || isStart) {
                isStart=NO;
                if (i < [self.booksArray count]) {
                    [rowBooks addObject:[self.booksArray objectAtIndex:i]];
                    i++;
                }else
                    break;
            }
          
            FourBooksCell *cell = [[FourBooksCell alloc] initWithIsLastCategory:NO withBook:rowBooks];
            cell.styleUrl=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.url"];
            //  NSLog(@"%@",[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"] );
            cell.CSSId=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"];
            cell.viewController=self;
            cell.horizontalTableView.contentOffset=CGPointMake(0, [self.booksArray count]*184);
            
           // cell.booksArray=[NSArray arrayWithArray:rowBooks];
            [self.reusableCells addObject:cell];
            [cell release];
            
        }
    }
    
    [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self withObject:nil];
    [self.collectionTableView reloadData];
    
    
}
-(void)getBooksWithText:(NSString *)searchText{
    if ([[NetworkService getObject] checkInternetWithData]) {
        self.reusableCells=[NSMutableArray array];
        NSDictionary *categoriesDict=nil;
        categoriesDict=[NetworkService getDataInDictionaryWithBody:nil methodIsPost:NO andBaseURL:[NSString stringWithFormat:@"search/books/%@/%@/fields/cover.768x1024,thumb.304x406,title/index.start/1/page.size/1000/",API_TYPE,searchText]];
        id object =[[[categoriesDict objectForKey:@"list"] objectForKey:@"books"] objectForKey:@"book"];
        if ([object isKindOfClass:[NSDictionary class]]) {
            self.booksArray=[NSMutableArray arrayWithObject:object];
        }else
            self.booksArray=[NSMutableArray arrayWithArray:object];
        
        if ([self.booksArray count] == 1) {
            FourBooksCell *cell = [[FourBooksCell alloc] initWithIsLastCategory:NO withBook:booksArray];
            // NSLog(@"%@",[[categoriesDict objectForKey:@"list"]objectForKey:@"style.url"]);
            cell.styleUrl=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.url"];
            //  NSLog(@"%@",[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"] );
            cell.CSSId=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"];
            cell.viewController=self;
            cell.horizontalTableView.contentOffset=CGPointMake(0, [self.booksArray count]*189);
           // cell.booksArray=[NSArray arrayWithArray:booksArray];
            [self.reusableCells addObject:cell];
            [cell release];
        }
        else{
            for (int i = 1; i <= [self.booksArray count]; i++)
            {
                i--;
                BOOL isStart=YES;
              
                NSMutableArray *rowBooks=[NSMutableArray array];
                while (i % 4 !=0 || isStart) {
                    isStart=NO;
                    if (i < [self.booksArray count]) {
                        [rowBooks addObject:[self.booksArray objectAtIndex:i]];
                        i++;
                    }else
                        break;
                }
                
                FourBooksCell *cell = [[FourBooksCell alloc] initWithIsLastCategory:NO withBook:rowBooks];
                cell.styleUrl=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.url"];
                //NSLog(@"%@",[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"] );
                cell.CSSId=[[categoriesDict objectForKey:@"list"]objectForKey:@"style.version"];
                cell.viewController=self;
                cell.horizontalTableView.contentOffset=CGPointMake(0, [self.booksArray count]*189);
               // cell.booksArray=[NSArray arrayWithArray:rowBooks];
                [self.reusableCells addObject:cell];
                [cell release];
                
            }
        }
        
        [NSThread detachNewThreadSelector:@selector(hideIndicator) toTarget:self withObject:nil];
        [self.collectionTableView reloadData];
        
    }else{
        [self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FourBooksCell *cell = [self.reusableCells objectAtIndex:indexPath.section];
    //[cell.horizontalTableView reloadData];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //   NSLog(@"%d",[self.reusableCells count]);
    return [self.reusableCells count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // NSLog(@"%d",[self.booksArray count]);
    
    int sections=[self.booksArray count]/4;
    if( ([self.booksArray count] % 4)!= 0 )
        sections++;
    if (indexPath.section == sections-1) {
        return 243;
    }
    return 235;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_collectionTableView release];
    [_bookSearchBar release];
    [_activityView release];
    [_indicatorView release];
    [_arrowLabel release];
    [_titleLabel release];
    [_backButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBackButton:nil];
    [super viewDidUnload];
}
@end
