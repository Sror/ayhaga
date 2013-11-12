

#import "EPub.h"
#import "ZipArchive.h"
#import "Chapter.h"
#import "XMLReader.h"
#import "UserDefaults.h"

@interface EPub()

- (void) parseEpub;
- (void) unzipAndSaveFileNamed:(NSString*)fileName;
- (NSString*) applicationDocumentsDirectory;
- (NSString*) parseManifestFile;
- (void) parseOPF:(NSString*)opfPath;
- (void)getBookId:(NSString *)opfPath;
- (void)deleteItemsAtPath:(NSString *)path;

@end

static int pathId;
@implementation EPub

@synthesize spineArray,bookId;

- (id) initWithEPubPath:(NSString *)path{
	if((self=[super init])){
		epubFilePath = [path retain];
		spineArray = [[NSMutableArray alloc] init];
         [self deleteItemsAtPath:@"book"];
        pathId++;
		[self parseEpub];
        //[self getIndex];
	}
	return self;
}

+ (int)pathId{
    return pathId;
}
+ (void)setPathId:(int)newPath{
    pathId=newPath;
}

- (void) parseEpub{
   
	[self unzipAndSaveFileNamed:epubFilePath];

	NSString* opfPath = [self parseManifestFile];
	[self parseOPF:opfPath];
}

- (void)deleteItemsAtPath:(NSString *)path{
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *folder = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:path];
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:folder error:NULL];
}


- (void)unzipAndSaveFileNamed:(NSString*)fileName{
	
	ZipArchive* za = [[ZipArchive alloc] init];
//	NSLog(@"%@", fileName);
//	NSLog(@"unzipping %@", epubFilePath);
	if( [za UnzipOpenFile:epubFilePath]){
		NSString *strPath=[NSString stringWithFormat:@"%@/book/UnzippedEpub%d",[self applicationDocumentsDirectory],pathId];
//		NSLog(@"%@", strPath);
		//Delete all the previous files
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath]) {
			NSError *error;
			[filemanager removeItemAtPath:strPath error:&error];
		}
		[filemanager release];
		filemanager=nil;
		//start unzip
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret ){
			// error handler here
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
														  message:@"Error while unzipping the epub"
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
			[alert show];
			[alert release];
			alert=nil;
		}
		[za UnzipCloseFile];
        [self replaceCSSStyle];
	}					
	[za release];
}

-(void)replaceCSSStyle{
    [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"book/UnzippedEpub%d/EPUB/Style/style2.css",pathId]];
  //
   // [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"UnzippedEpub%d/EPUB/Style/style.css",pathId]];
   
  //  NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"style2" ofType:@"css"];
   // NSData *cssData=[NSData dataWithContentsOfFile:cssPath];
    NSData *cssData=[UserDefaults getDataWithName:@"style.css" inRelativePath:@"/books" inDocument:YES];
    [UserDefaults saveData:cssData withName:@"style2.css" inRelativePath:[NSString stringWithFormat:@"book/UnzippedEpub%d/EPUB/Style/",pathId]inDocument:NO ];
    
   // cssPath = [[NSBundle mainBundle] pathForResource:@"style2" ofType:@"css"];
   // cssData=[NSData dataWithContentsOfFile:cssPath];
   // [UserDefaults saveData:cssData withName:@"style2.css" inRelativePath:[NSString stringWithFormat:@"UnzippedEpub%d/EPUB/Style/",pathId]inDocument:YES];

   // [UserDefaults deleteItemsAtPath:[NSString stringWithFormat:@"UnzippedEpub%d/OEBPS/Text/style.css",pathId]];
   //  [UserDefaults saveData:cssData withName:@"style.css" inRelativePath:[NSString stringWithFormat:@"UnzippedEpub%d/OEBPS/Text/",pathId]];
    
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString*) parseManifestFile{
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@/book/UnzippedEpub%d/META-INF/container.xml", [self applicationDocumentsDirectory],pathId];
//	NSLog(@"%@", manifestFilePath);
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:manifestFilePath]) {
		//		NSLog(@"Valid epub");
		CXMLDocument* manifestFile = [[[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil] autorelease];
		CXMLNode* opfPath = [manifestFile nodeForXPath:@"//@full-path[1]" error:nil];
	//	NSLog(@"%@", [NSString stringWithFormat:@"%@/UnzippedEpub/%@", [self applicationDocumentsDirectory], [opfPath stringValue]]);
		return [NSString stringWithFormat:@"%@/book/UnzippedEpub%d/%@", [self applicationDocumentsDirectory],pathId ,[opfPath stringValue]];
	} else {
		//NSLog(@"ERROR: ePub not Valid");
		return nil;
	}
	[fileManager release];
}
- (void)getBookId:(NSString *)opfPath{
    NSDictionary *dict= [XMLReader dictionaryForXMLString:[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:opfPath] encoding:NSUTF8StringEncoding error:nil] error:nil];
    self.bookId=[[[[dict objectForKey:@"package"] objectForKey:@"metadata"] objectForKey:@"dc:identifier"] objectForKey:@"text"];
    if ([self.bookId rangeOfString:@"urn:uuid:"].location !=NSNotFound) {
        self.bookId=[self.bookId substringFromIndex:[self.bookId rangeOfString:@"urn:uuid:"].location+9];
    }
   // CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
	//NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:dc" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
  //  CXMLElement* element=[itemsArray objectAtIndex:0];
  //  NSLog(@"%@",[[[[dict objectForKey:@"package"] objectForKey:@"metadata"] objectForKey:@"dc:identifier"] objectForKey:@"text"]);
  
}

- (NSArray *)getIndex{
    NSString* indexFilePath = [NSString stringWithFormat:@"%@/book/UnzippedEpub%d/EPUB/Navigation/toc.ncx", [self applicationDocumentsDirectory],pathId];
    id object=[[[[XMLReader dictionaryForXMLString:[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:indexFilePath] encoding:NSUTF8StringEncoding error:nil] error:nil] objectForKey:@"ncx"] objectForKey:@"navMap"] objectForKey:@"navPoint"];
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    }else{
        return [NSArray arrayWithObject:object];
    }
 //   NSArray *array=
   // NSLog(@"Index=%@",array);
    return nil;
}
- (void) parseOPF:(NSString*)opfPath{
    [self getBookId:opfPath];
	CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
	NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//	NSLog(@"itemsArray size: %d", [itemsArray count]);
    
    NSString* ncxFileName;
	
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
	for (CXMLElement* element in itemsArray) {
        
		[itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFileName = [[element attributeForName:@"href"] stringValue];
        //  NSLog(@"ID=%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
        
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/xhtml+xml"]){
            ncxFileName = [[element attributeForName:@"href"] stringValue];
          //  NSLog(@"%@ : %@", [[element attributeForName:@"id"] stringValue], [[element attributeForName:@"href"] stringValue]);
        }
	}
	
    int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
    CXMLDocument* ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray) {
        NSString* href = [[element attributeForName:@"href"] stringValue];
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        NSArray* navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
       // NSLog(@"navPoint=%@",navPoints);
        if([navPoints count]!=0){
            CXMLElement* titleElement = [navPoints objectAtIndex:0];
           [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }

	
	NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
	//NSLog(@"itemRefsArray size: %@", itemRefsArray);
	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    int count = 0;
	for (CXMLElement* element in itemRefsArray) {
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];

        Chapter* tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]
                                                       title:[titleDictionary valueForKey:chapHref] 
                                                chapterIndex:count++];
		[tmpArray addObject:tmpChapter];
		
		[tmpChapter release];
	}
	
	self.spineArray = [NSArray arrayWithArray:tmpArray]; 
	
	[opfFile release];
	[tmpArray release];
	[ncxToc release];
	[itemDictionary release];
	[titleDictionary release];
}

- (void)dealloc {
    [spineArray release];
	[epubFilePath release];
    [super dealloc];
}

@end
