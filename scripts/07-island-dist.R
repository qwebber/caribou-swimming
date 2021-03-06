### Swim distance ====
# Quinn M.R. Webber, Jack G. Hendrix, Alec L. Robitaille,  Eric Vander Wal


### Packages ----
library(data.table)
library(spatsoc)
library(ggplot2)


### Data ----
edges <- readRDS('output/island-edges.Rds')
alloc.col(edges)

### Distance ----
# Generate undirected edge id
dyad_id(edges, 'island', 'endisland')

# Calculate mean step length between islands, undirected
edges[, swimdist := mean(stepLength), dyadID]

edges2 <- edges[, mean(swimdist), by = c("diff", "island")]
edges2$swimdist <- edges2$V1/10

## load area data
runarea <- readRDS('output/runarea.Rds')

df <- merge(edges2, runarea[, c("area", "island", "islandlen")], by = "island", allow.cartesian=TRUE)
df$island <- as.character(df$island)

df.complete <- df[complete.cases(df),]      
      
ggplot(df, aes(log(area)/log(islandlen + 1), swimdist)) +
  geom_point() +
  geom_smooth() +
  ylab("distance between islands") +
  xlab("log(area)/log(residency time)") 
  

