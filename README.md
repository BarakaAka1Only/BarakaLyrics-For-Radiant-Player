BarakaLyrics For Radiant Player

BarakaLyrics adds lyrics into Radiant Player allowing songs that are played to get lyrics for said song(s).

I've included all source code and SVG images

How to's:

Take a look at file RadiantPlayerGoogleSample.html to see how everything is done this is a sample to ensure testing is good to go.

The important files are BarakaModal.css and BarakaRadiant.js

BarakaRadiant.js handles all the UI important things on Radiant Player

[this is not bundled with gmusic-utils for the on change events refer to my added additions on Radiant Player itself on the main.js]

BarakaModal.css of-course is the styling for BarakaLyrics

When modifying ensure that the BarakaModal.css changes are inset just as BarakaModal.html because it will be minified

and added into BarakaRadiant.js from block

`var radiant = BarakaRadiant.create('');`

Adding your changes into Radiant Player requires that BarakaRadiant.js minified and all characters are escaped  

USE http://bernhardhaeussner.de/odd/json-escape/ after minifying

`NSString *var =@"var BarakaLyrics = {};";`

The NSString above is the main var and should include the BarakaLyrics object first hand.
When characters are escaped after {}; in the NSString paste in the escaped code and you will be good to go.


Extending Lyric services:

`@interface BarakaLyrics` is where the magic happens via `findBarakaLyrics` constructors

Say i wanted to add in a service called GoogleLyrics

Header file and a controller file (.m) needs to be created

name `BarakaLyricGoogle.h BarakaLyricGoogle.m`

All new services are inherited by interface BarakaLyrics by making a unique `@interface` that is abstract to BarakaLyrics

`//`

`//  BarakaLyricGoogle.h`

`//  Baraka Lyrics For Radiant Player`

`//  Main Header For Google Lyrics`

`//  @date April 12th, 2016`


`#import "BarakaLyrics.h"`


`@interface BarakaLyricGoogle : BarakaLyrics`


`@end`

in our .m file we will make an implementation to BarakaLyricGoogle which will add-on to BarakaLyrics by findBarakaLyrics and whatClass

`whatClass` is important to get what classes are in use for our var NSString object which

`className = [obtain whatClass]; [self BarakaInjectLyrics:className content:Final];` takes over.

`//`

`//  BarakaLyricGoogle.m`

`//  Baraka Lyrics For Radiant Player`

`//  Main Controller For Google Lyrics`

`//  @date April 12th, 2016`

`#import "BarakaLyricGoogle.h"`


`@implementation BarakaLyricGoogle`


`// Lets Get Our Current Class`
`- (NSString *)__whatClass {`
`    [BarakaLyricGoogle temp];`
`    return @"";`
`}`

`+ (NSString *)temp {`
`    return @"";`
`}`

`- (NSString *)__findBarakaLyrics:(NSString *)artist album:(NSString *)album title:(NSString *)title {}`


Thanks to:

 Geoffrey Grosenbach for the Hpple which can be found here https://github.com/topfunky/hpple
 
 Matt Gallagher for XPathQuery
 
 And the Radiant Player team for making a great app.

 I had a lot of fun making this.

 Created in XCode and Atom [Minify using css and js with Atom Package Install]
