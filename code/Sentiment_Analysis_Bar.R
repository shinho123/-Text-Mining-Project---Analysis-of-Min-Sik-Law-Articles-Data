# 뉴스 기사의 감정분석
dic <- read_csv("C:/csv/knu_sentiment_lexicon.csv")

Raw <- read_excel("C:/csv/Min_raw.xlsx")

Raw <- Raw %>%
  select("본문")

names(Raw) <- c("sentence")

# 문장 전처리
Min_Raw <- Raw %>%
  mutate(sentence = str_squish(sentence))

# 문장 토큰화
Min_token <- Min_Raw %>%
  unnest_tokens(input = sentence,
                output = word,
                token = "words",
                drop = F)
Min_score <- Min_token %>%
  left_join(dic, by = "word") %>%
  mutate(polarity = ifelse(is.na(polarity), 0, polarity))

Min_score <- Min_score %>%
  group_by(sentence) %>%
  summarise(score = sum(polarity)) %>%
  mutate(sentiment = ifelse(score >= 1, "pos",
                            ifelse(score <= -1, "neg", "neu")))
Min_score_count <- Min_score %>%
  count(sentiment, sort = T) %>%
  mutate(ratio = n/sum(n)*100)

Min_score_count

# 빈도 막대 그래프 만들기
font_add_google(name = "Black Han Sans", family = "bhs")
showtext_auto()
Min_score_count$dummy <- 0

Min_score_count %>%
  ggplot(aes(dummy, ratio, fill = sentiment)) +
  geom_col() +
  geom_text(aes(label = paste0(round(ratio, 1), "%", "(", n, ")")),
            position = position_stack(vjust = 0.5),
            family = "bhs") +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        text = element_text(family = "bhs", size = 15)) +
  labs(title = "민식이 법 감정분석", y = NULL) 
