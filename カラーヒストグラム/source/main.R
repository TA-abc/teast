library(imager)
## library(tidyverse)
library(tidyr)
library(ggplot2)

## 画像読み込み
## リサイズ
##  => そのまま使うと、
##      width * height * number_of_image
##      なのでかなり大きいデータになる。
##      そのためリサイズ必須。
## データフレーム化
## クラスタリング
## カラーヒストグラム作成
## 分類？

fs <- list.files("../Groundtruth/arborgreens/", full.names=T)

imgs <- lapply(fs, load.image)

set_width <- 50
set_height <- 50
number_of_clusters <- 64

## widths <- sapply(imgs, width)
## heights <- sapply(imgs, height)

imgs_rescaled <- lapply(imgs,function(i,width,height){
  resize(im = i, size_x = width, size_y = height)
}, width=set_width, height=set_height)


idx <- 1
images_df <- lapply(1:length(imgs_rescaled),function(idx){
  
  d <- as.data.frame(imgs_rescaled[[idx]])
  
  d$cc <- factor(d$cc,labels=c('R','G','B'))
  
  d2 <- spread(
    data = d
   ,key = "cc"
   ,value = "value"
  )
  
  d2$file_idx <- idx
  
  return(d2)
})
images_df <- do.call(rbind, images_df)

idx <- 1
d <- images_df[images_df$file_idx==images_df$file_idx[1],]
tmp <- lapply(split(images_df,images_df$file_idx),function(d){
  
  d2 <- gather(data = d, key = RGB, value = pixel_value, -x, -y, -file_idx)
  d2$RGB <- factor(d2$RGB, levels=c("R","G","B"))
  
  ## Histogram
    
  g <- ggplot(data=d2, aes(x=.data[["pixel_value"]], fill=.data[["RGB"]])) + geom_histogram(position="dodge")
  g <- g + scale_fill_manual(
    values = c(
      "R" = "red"
     ,"G"  = "green"
     ,"B"     = "blue"
    )
  )
  
  ## Barplot
  d2$pixel_value_cut <- cut(d2$pixel_value, breaks = 10)
  g <- ggplot(data=d2, aes(x=.data[["pixel_value_cut"]], fill=.data[["RGB"]])) + geom_bar(position="dodge")
  g <- g + scale_fill_manual(
    values = c(
      "R" = "red"
      ,"G"  = "green"
      ,"B"     = "blue"
    )
  )
  
  
})







