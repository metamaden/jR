# juicyimgR
Fun with image decomposition analysis in R!

# Wait but why
Image decomposition can be insightful, practical, but mostly fun. JuicyimgR is meant to provide the core functionality of an image decomposition pipeline, to be implemented in various ways (see TODO below for some of my own ideas).

# Illustrative example
There has almost always, but especially recently, been high interest in image decomposition problems. In a way this topic has been around at least as long as graphics interfaces have been capable of viewing, saving, and compressing image files.

Lately there is a widespread interest in decomposition as a means of getting at some core components, and in images this topic naturally extends to palette generation. So this example has to do with automatically generating a palette containing the decomposed set of 20 colors from an image. 

## Looking at the problem more 'closely'
Since I have been interested in automating this process from the get-go, this example details a script that scrapes an image from a Google image search, all without leaving the comfort of the R session!

We will leverage the talent and experience of a real-life artist in this analysis. After loading out dependancies, we scrape the top Google image search result of a painting by Chuck Close using "Chuck_Close" as our search term.
```
# Dependancies
library(imager); library(fpc); library(scales); library(dplyr);

# google image search, save html result
# first specify search term, then paste into boiler plate url
searchterm <- "Chuck_Close"
search <- read_html(paste0("https://www.google.com/search?site=&tbm=isch&q=",searchterm))

# keep top urls from search
urls <- search %>% html_nodes("img") %>% html_attr("src")
# map top 4 urls from search, and plot
map_il(urls[1:4],load.image) %>% plot

# grab top first url as image then convert to raster
img1 <- map_il(urls[1],load.image)
rc1 <- as.raster(img1[[1]])
```
## Preparing and performing cluster analysis
Next we transform the data in order to make it usable in the kmeans() function

```
# transform raster into dataframe with cols R, G, B, one row per pixel
lrc <- as.list(rc1) # get list of pixel hexval's
dfrc <- matrix(nrow=length(lrc),ncol=3); colnames(dfrc) <- c("R","G","B")

for(j in 1:length(lrc)){
  dfrc[j,] <- t(col2rgb(lrc[[j]]))/256
  message(j)
};
```

The then apply kmeans as such.

```
kdfrc <- kmeans(dfrc,centers=20,iter.max=30) # parameters taken from example
```
## Composite fun
And leveraging some of R's choice visualization functionality, we can generate a nice summary composite to help show what exactly happened when we ran the above code.

```
jpeg("example_summary_pic_imageDecompKmeans20_nocompress.jpg",height=8,width=20,units="in",res=400)
par(mfrow=c(1,4))

# 1. main src img
plot(rc1); mtext("Original Image", col="red")
# 2. kmeans result 1/2, coloration on original hexdata
plotcluster(dfrc,kdfrc$cluster,col=unlist(lrc),main="Kmeans Result\nCol=pixel.src")
# 3. kmeans result 2/2, coloration on kmeans cluster n=20
plotcluster(dfrc,kdfrc$cluster,main="Kmeans Result\nCol=cluster")
# 4. decomposed palette
show_col(rgb(kdfrc$centers),borders="white"); mtext("Decomposed Palette",col="red")

dev.off()
```
This generates the following:

![alt text](https://github.com/metamaden/juicyimgR/blob/master/chuck_close.jpg "composite for 'Chuck_Close' analysis")

Ta-da! 

This workflow has loads of exciting applications, and is ready to be wrapped up with code for API interfacing, conducting relatedness analyses across images, and so on.

# Helpful resources and citations
The code above was adapted, inspired, and informed by examples and information from the following:
https://dahtah.github.io/imager/imager.html  
http://www.milanor.net/blog/build-color-palette-from-image-with-paletter/  
http://www.melissaclarkson.com/resources/R_guides/documents/colors_Ver2.pdf  
http://research.stowers.org/mcm/efg/R/Color/Chart/  
https://stats.stackexchange.com/questions/31083/how-to-produce-a-pretty-plot-of-the-results-of-k-means-cluster-analysis  
https://rpubs.com/aaronsc32/image-compression-principal-component-analysis  

# TODO
1. Logging online clothes orders using JuicyImgR
2. Wrapping into a Tweet-API friendly script for automating posts.
3. Automating for web scraping applications (eg. NLP or sentiment analysis to assemble new google searches, etc.).
