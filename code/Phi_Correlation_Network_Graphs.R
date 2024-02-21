# 파이 계수 그래프
library(tidygraph)
set.seed(1234)

graph_cors <- word_cors %>%
  filter(correlation >= 0.50) %>%
  as_tbl_graph(directed = F) %>%
  mutate(centrality = centrality_degree(),
         group = as.factor(group_infomap()))

# 네트워크 그래프
library(ggraph)
set.seed(1234)
ggraph(graph_cors,
       layout = "fr") +
  geom_edge_link(color = "gray50",
                 aes(edge_alpha = correlation,
                     edge_width = correlation),
                 show.legend = F) +
  scale_edge_width(range = c(1, 4)) +
  geom_node_point(aes(size = centrality,
                      color = group),
                  show.legend = F) +
  scale_size(range = c(5, 10)) +
  geom_node_text(aes(label = name),
                 repel = T,
                 size = 5,
                 family = "bhs") +
  theme_graph()
