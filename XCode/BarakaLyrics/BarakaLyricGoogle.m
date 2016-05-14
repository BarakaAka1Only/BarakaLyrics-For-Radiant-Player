//
//  BarakaLyricGoogle.m
//  Baraka Lyrics For Radiant Player
//  Main Controller For Google Music
//  @date May 14th, 2016

#import "BarakaLyricGoogle.h"


@implementation BarakaLyricGoogle

// Lets Get Our Current Class
- (NSString *)__whatClass {
    [BarakaLyricGoogle temp];
    return @"";
}

+ (NSString *)temp {
    return @"";
}

- (NSString *)__findBarakaLyrics:(NSString *)artist album:(NSString *)album title:(NSString *)title {
    
    if (title == nil || artist == nil) {
        return @"";
    }
    
    NSString *lyrics;
    NSString *url;
    
    url = [BarakaLyricGoogle createGoogleUrlFor:title by:[NSString stringWithFormat:@"%@%@",[[artist substringToIndex:1] uppercaseString],[artist substringFromIndex:1]]];
    lyrics = [BarakaLyricGoogle downloadGoogleLyricsFrom:url t:title];
    
    if (lyrics != nil) {
        return lyrics;
    } else {
        return nil;
    }
    
}

+(NSString *) createGoogleUrlFor:(NSString *)title by:(NSString *)artist {
    NSString *url = @"https://play.google.com/store/search?c=music&docType=4&q=";
    url = [url stringByAppendingString:[BarakaLyricGoogle escapeUri:[NSString stringWithFormat:@"%@%@",[[artist substringToIndex:1] uppercaseString],[artist substringFromIndex:1]] by:@" "]];
    url = [url stringByAppendingString:@"-"];
    url = [url stringByAppendingString:[BarakaLyricGoogle escapeUri:title by:@" "]];
    return url;
}

+ (NSString *)downloadGoogleLyricsFrom:(NSString *)url t:(NSString *)title {
    //NSLog(@"obtaining lyrics '%@'", url);
    //NSLog(@"obtaining song title '%@'", title);
    
    NSString *Gurl = [NSString stringWithFormat:@"http://www.geoplugin.net/json.gp"];
    NSURL *u=[NSURL URLWithString:Gurl];
    NSData *data=[NSData dataWithContentsOfURL:u];
    NSError *error=nil;
    id response=[NSJSONSerialization JSONObjectWithData:data options:
                 NSJSONReadingMutableContainers error:&error];
    
    if([[response valueForKey:@"geoplugin_countryCode"] isEqualToString:@"US"]){
    
        NSURL *BarakaURL = [NSURL URLWithString:url];
        NSData *HTML = [NSData dataWithContentsOfURL:BarakaURL];

        if (HTML != nil) {
            TFHpple *Parser = [TFHpple hppleWithHTMLData:HTML];
        
            NSString *xpathCardQuery = @"//*[contains(@class,'card-list')]";
            NSArray *NodeCard = [Parser searchWithXPathQuery:xpathCardQuery];
            NSUInteger ele = (NSUInteger)[NodeCard count];

            NSMutableArray *CardArray = [[NSMutableArray alloc] initWithCapacity:0];
            if(ele > 0){
                if (NodeCard > 0) {
                    for (TFHppleElement *element in NodeCard) {
                    
                        TFHppleElement * name = [NodeCard objectAtIndex:0];
                    
                        NSString *title = [NSString stringWithFormat:@"%@", name.content];
                
                        if ([title containsString:title]) {
                            TFHppleElement * first = [NodeCard objectAtIndex:0];
                            for (TFHppleElement *child in first.children) {
                        
                                NSString *attrs = [NSString stringWithFormat:@"%@", child.attributes];
                        
                                if ([attrs containsString:@"data-docid"]) {
                                    //NSLog(@"Yes");
                                    NSString *docid = [@"" stringByAppendingString:[child objectForKey:@"data-docid"]];
                                    [CardArray addObject:docid];
                            
                                }
                            
                                //NSLog(@"attributes'%@'", child.attributes);
                            }
                        }
                    }
                
                    // Now see if there is lyrics ? https://play.google.com/music/preview/' + songID + '?lyrics=1')
                
                    NSString *SongID = [[CardArray objectAtIndex:0] stringByReplacingOccurrencesOfString:@"song-"
                                                                                              withString:@""
                                                                                              options:NSAnchoredSearch // beginning of string
                                                                                              range:NSMakeRange(0, [[CardArray objectAtIndex:0] length])];
            
                    NSString *url = @"https://play.google.com/music/preview/";
                    url = [url stringByAppendingString:[NSString stringWithFormat:@"%@",SongID]];
                    url = [url stringByAppendingString:@"?lyrics=1"];
                
                    NSURL *BarakaURL = [NSURL URLWithString:url];
                    NSData *HTML = [NSData dataWithContentsOfURL:BarakaURL];
                
                    if (HTML != nil) {
                        TFHpple *Parser = [TFHpple hppleWithHTMLData:HTML];
                        NSString *xpathLyricQuery = @"//*[contains(@class,'content-container lyrics')]";
                        NSArray *NodeLyric = [Parser searchWithXPathQuery:xpathLyricQuery];
                        NSUInteger ele = (NSUInteger)[NodeLyric count];
                        NSMutableArray *LyricArray = [[NSMutableArray alloc] initWithCapacity:0];
                        if(ele > 0){
                            if (NodeLyric > 0) {
                                //NSLog(@"data-docid '%@'", SongID);
                                //NSLog(@"obtaining BarakaURL '%@'", BarakaURL);
                            
                                    for (TFHppleElement *element in NodeLyric) {
                                        [LyricArray addObject:[element raw]];
                                    }
                            
                                NSString *Remove = [self stringByElement:LyricArray[0] Element:@"<div class=\"title\">Lyrics</div>"];
                                NSString *Final = Remove;
                            
                                NSLog(@"lyrics '%@'", Final);
                                return Final;
                            }
                        } else {
                            return nil;
                        }

                    
                    } else {
                        return nil;
                    }
             
                }
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return @"Only USA";
    }
    
    return @"";
}

@end
