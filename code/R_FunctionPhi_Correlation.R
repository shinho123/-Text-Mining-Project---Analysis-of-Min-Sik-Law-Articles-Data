# 토픽모델링
library(readr)
library(dplyr)  

raw_news_min <- read_excel("C:/csv/Min_raw.xlsx")

library(stringr)
library(textclean)

raw_news_min <- raw_news_min %>%
  select("본문")

names(raw_news_min) <- c("sentence")
# 기본적인 전처리

raw_news_min <- raw_news_min  %>%
  mutate(id = row_number())

news_min <- raw_news_min %>%
  mutate(sentence <- str_replace(sentence, "[^가-힣]", " "),
         sentence <- str_squish(sentence)) %>%
  # 중복 제거
  distinct(sentence, .keep_all = T) %>% 
  # 짧은 문서 제거 - 3단어 이상 추출
  filter(str_count(sentence, boundary("word")) >= 3)


library(tidytext)
library(KoNLP)

# 명사 추출
comment <- news_min %>%
  unnest_tokens(input = sentence,
                output = word,
                token = extractNoun,
                drop = F) %>%
  filter(str_count(word) > 1) %>%
  group_by(id) %>%
  distinct(word, .keep_all = T) %>%
  ungroup() %>%
  select(id, word)

# 빈도가 높은 단어 제거하기
comment_count <- comment %>%
  add_count(word) %>%
  filter(n <= 100) %>%
  select(-n)

# LDA 모델 만들기

# 문서별 단어빈도
count_word_doc <- comment_count %>%
  count(id, word, sort = T)
count_word_doc

# DTM만들기
dtm_comment <- count_word_doc %>%
  cast_dtm(document = id,
           term = word,
           value = n)
dtm_comment
as.matrix(dtm_comment[1:8, 1:8])

# 토픽 모델 만들기
library(topicmodels)
lda_model <- LDA(dtm_comment,
                 k = 8,
                 method = "Gibbs",
                 control = list(seed = 1234))
lda_model

# beta 추출하기
term_topic <- tidy(lda_model,
                   matrix = "beta")
term_topic

# 토픽의 주요 단어 살펴보기
terms(lda_model, 20) %>%
  data.frame()

# 토픽별로 beta가 가장 높은 단어 추출하기
top_term_topic <-
  term_topic %>%
  group_by(topic) %>%
  slice_max(beta, n = 10, with_ties = F)
top_term_topic
# 그래프 그리기
library(ggplot2)
library(scales)

top_term_topic %>%
  ggplot(aes(reorder_within(term, beta, topic), beta, fill = factor(topic))) +
  geom_col(show.legend = F) +
  facet_wrap(~topic, scales = "free", ncol = 4) +
  coord_flip() +
  scale_x_reordered() +
  scale_y_continuous(n.breaks = 4,
                     labels = number_format(accuracy = .01)) +
  labs(x = NULL) + 
  theme(text = element_text(family = "bhs"))



# 카테고리 별 정리
raw_news_min <- read_excel("C:/csv/Min_raw.xlsx")

raw_news_min <- raw_news_min %>%
  select("본문")

names(raw_news_min) <- c("sentence")

# 기본적인 전처리
raw_news_min <- raw_news_min  %>%
  mutate(id = row_number())

news_min <- raw_news_min %>%
  mutate(sentence <- str_replace(sentence, "[^가-힣]", " "),
         sentence <- str_squish(sentence)) %>%
  # 중복 제거
  distinct(sentence, .keep_all = T) %>% 
  # 짧은 문서 제거 - 3단어 이상 추출
  filter(str_count(sentence, boundary("word")) >= 3)

# 토큰화
pos_min <- news_min %>%
  unnest_tokens(input = sentence,
                output = word_pos,
                token = SimplePos22,
                drop = F)

separate_pos_min <- pos_min %>%
  separate_rows(word_pos, sep = "[+]") %>%
  filter(str_detect(word_pos, "/n|/pv|/pa")) %>%
  mutate(word = ifelse(str_detect(word_pos, "/pv|/pa"),
                       str_replace(word_pos, "/.*$", "다"),
                       str_remove(word_pos, "/.*$"))) %>%
  filter(str_count(word) >= 2) %>%
  arrange(id)


library(widyr)

word_cors <- separate_pos_min %>%
  add_count(word) %>%
  filter(n >= 20) %>%
  pairwise_cor(item = word,
               feature = id,
               sort = T)

word_cors %>% 
  print(n = 100)

target = c("어린이보호구역치사", "운전기사", "인천")

# 상위 10개 추출
top_cors <- word_cors %>%
  filter(item1 %in% target) %>%
  group_by(item1) %>%
  slice_max(correlation, n = 10)
top_cors

# 그래프 순서 정하기
top_cors$item1 <- factor(top_cors$item1, levels = target)

# 막대 그래프 만들기
top_cors %>%
  ggplot(aes(x = reorder_within(item2, correlation, item1),
             y = correlation,
             fill = item1)) +
  geom_col(show.legend = F) +
  facet_wrap(~item1, scales = "free") +
  coord_flip() +
  scale_x_reordered() +
  labs(title = "민식이법 기사 주요 단어",
       subtitle = "파이 계수 Top10",
       x = NULL) +
  theme_minimal() +
  theme(text = element_text(family = "bhs"),
        plot.title = element_text(size = 14, face = "bold"),
        plot.subtitle = element_text(size = 12),
        strip.text = element_text(size = 11))
