# 토픽별 주요단어 추출
term_topic <- tidy(lda_model, matrix = "beta")

# 토필별 beta 상위 단어 추출
term_topic %>%
  group_by(topic) %>%
  slice_max(beta, n = 15) %>%
  print(n = Inf)

# 불용어 목록
stop_word <- c(11, 12, 18, 54, 10, 29, 23, 60, "교통사고", "어린이보호구역(스쿨존)에서", 25, '\'민식이법\'', '식이법','민식이법')
stop_word
top_term_topic <- term_topic %>%
  filter(!term %in% stop_word) %>%
  group_by(topic) %>%
  slice_max(beta, n = 10)

# 막대 그래프 만드릭
top_term_topic %>%
  ggplot(aes(x = reorder_within(term, beta, topic),
             y = beta,
             fill = factor(topic))) +
  geom_col(show.legend = F) +
  facet_wrap(~topic, scales = "free", ncol = 3) +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL) +
  theme(text = element_text(family = "bhs"))

# 토픽별 감마 추출
doc_topic <- tidy(lda_model, matrix = "gamma")

# 문서별로 확률이 가장 높은 토픽 추출
doc_class <- doc_topic %>%
  group_by(document) %>%
  slice_max(gamma, n = 1)

# integer로 변환
doc_class$document <- as.integer(doc_class$document)

# 원문에 토픽 번호 부여
min_topic <- news_min %>%
  left_join(doc_class, by = c("id" = "document"))

# 토픽별 주요 단어 목록 만들기
top_terms <- term_topic %>%
  filter(!term %in% stop_word) %>%
  group_by(topic) %>%
  slice_max(beta, n = 6, with_ties = F) %>%
  summarise(term = paste(term, collapse = ", "))

top_terms

# 토픽별 문서 빈도 구하기
count_topic <- min_topic %>%
  count(topic) %>%
  na.omit()
count_topic

count_topic_word <- count_topic %>%
  left_join(top_terms, by = "topic") %>%
  mutate(topic_name = paste("Topic", topic))

count_topic_word

# 막대 그래프 
library(scales)
count_topic_word %>%
  ggplot(aes(x = reorder(topic_name, n),
             y = n,
             fill = topic_name)) +
  geom_col(show.legend = F) +
  coord_flip() +
  geom_text(aes(label = comma(n, accuracy = 1)),
            hjust = -0.2) +
  geom_text(aes(label = term),
            hjust = 1.03,
            col = "white",
            fontface = "bold",
            family = "bhs") +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, 70)) +
  labs(title = "민식이법 기사 토픽",
       subtitle = "토픽별 주요 단어 및 댓글 빈도",
       x = NULL, y = NULL) +
  theme_minimal() +
  theme(text = element_text(family = "bhs"),
        plot.title = element_text(size = 14, face = "bold"),
        plot.subtitle = element_text(size = 1))
