#!/usr/bin/env R

# 

# https://stackoverflow.com/questions/41257695/web-scraping-in-r-from-google-images

install.packages(c("imager", "fpc", "scales", "dplyr", "textreadr"))

library(imager)
library(fpc)
library(scales)
library(dplyr)
library(plyr)
library(textreadr)
library(rvest)

query <- function(searchterm = "Chuck_Close", 
                  urlbase = "https://www.google.com/search?site=&tbm=isch&q="){
  url <- paste0(urlbase, searchterm)
  search <- textreadr::read_html(url)
  # keep top urls from search
  urls <- url %>% 
    rvest::html_nodes("img") %>% 
    rvest::html_attr("src")
  urls <- url %>%
    xml2::read_html() %>%
    html_nodes(xpath = "//img") %>%
    html_attr("src")
  # map top 4 urls from search, and plot
  imager::map_il(urls[1:4], load.image) %>% plot
  # system("$LOCATE_PATH libSM.6.dylib")
  # returns warning
  # # sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
  system("locate libX11.6.dylib")
  # libX11.6.dylib
  imager::map_il(urls[5:10], load.image)
  # grab top first url as image then convert to raster
  img1 <- map_il(urls[1], load.image)
  rc1 <- as.raster(img1[[1]])
}

raster <- function(){
  
}

cluster <- function(){
  
}

imgdecomp <- function(){
  
}





