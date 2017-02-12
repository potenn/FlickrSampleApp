# FlickrSampleApp

FlickrSampleApp is an iOS Swift 3.0 Sample App for accessing the Flickr API.
It is a digital Album using feeds of photos_public API.
- After Lauching this FlickrSample App, Click the start Button.
- You can set the duration of the image (1 to 10 seconds).
- Bring additional feeds in the background during the slide show to keep other images showing without breaking.
- Image transition effect has fade-in and fade-out.
- Deployment target >= iOS 9.0

# Cocoapods Installation

This app use SDWebImage and Alamofire.

If you don't know these, go to the below link and install it.

Asynchronous image downloader
SDWebImage : https://github.com/rs/SDWebImage

HTTP networking library written in Swift.
Alamofire : https://github.com/Alamofire/Alamofire

# Process

![Alt Test](https://github.com/potenn/FlickrSampleApp/blob/master/process.png)

# Usage

if you request https://api.flickr.com/services/feeds/photos_public.gne?format=json, you receive responseString.

so, if you want to use directly responseJSON, use the below API.
https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1

In this iOS application, we use only "media" key

```javascript
{
title: "Uploads from everyone",
link: "https://www.flickr.com/photos/",
description: "",
modified: "2017-02-12T06:38:04Z",
generator: "https://www.flickr.com",
items: [
{
title: "Perasaannya apa? Follow @hijrahcinta_ Follow @hijrahcinta_ Follow @hijrahcinta_",
link: "https://www.flickr.com/photos/137729389@N08/32009004224/",
media: {
m: "https://farm3.staticflickr.com/2405/32009004224_569056b219_m.jpg"
},
date_taken: "2017-02-11T22:38:04-08:00",
description: " <p><a href="https://www.flickr.com/people/137729389@N08/">tausiyah_cinta</a> posted a photo:</p> <p><a href="https://www.flickr.com/photos/137729389@N08/32009004224/" title="Perasaannya apa? Follow @hijrahcinta_ Follow @hijrahcinta_ Follow @hijrahcinta_"><img src="https://farm3.staticflickr.com/2405/32009004224_569056b219_m.jpg" width="240" height="240" alt="Perasaannya apa? Follow @hijrahcinta_ Follow @hijrahcinta_ Follow @hijrahcinta_" /></a></p> <p>via Instagram <a href="http://ift.tt/2kGn4Wb" rel="nofollow">ift.tt/2kGn4Wb</a> <a href="http://ift.tt/2f12zSN" rel="nofollow">ift.tt/2f12zSN</a></p>",
published: "2017-02-12T06:38:04Z",
author: "nobody@flickr.com ("tausiyah_cinta")",
author_id: "137729389@N08",
tags: "ifttt instagram"
}
```
# Contact
  poten1129@gmail.com
  
