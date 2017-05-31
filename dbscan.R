library(dbscan)

mtl_crime <- read.csv('mtl_crimes.csv')
mtl_crime <- mtl_crime[as.numeric(mtl_crime$X) != 0, ]
dbscan(mtl_crime[,c('X','Y')], eps=300, minPts=15)
