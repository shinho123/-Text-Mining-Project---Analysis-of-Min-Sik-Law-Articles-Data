Raw <- read_excel("C:/csv/Min_raw.xlsx")

Raw <- Raw %>%
  select("본문")

names(Raw) <- c("value")
Raw

# 텍스트 전처리
Min_Raw <- Raw %>%
  mutate(value = str_replace(value, "[^가-힣]", " "),
         value = str_squish(value))

View(Raw)

# 텍스트 토큰화
text <- Min_Raw %>%
  unnest_tokens(input = value, 
                output = word, 
                token = "words",
                drop = F)

# 텍스트 카운터
text_count <- text %>%
  count(word, sort = T) %>%
  filter(str_count(word) > 1)

# 텍스트 양이 많은 순서대로 20개 추출
top20 <- text_count %>%
  head(20)

# 워드클라우드 출력
font_add_google(name = "Black Han Sans", family = "bhs")
showtext_auto()

text_count %>%
  ggplot(aes(label = word, 
             size = n,
             col = n)) +
  geom_text_wordcloud(seed = 1234,
                      family = "bhs") +
  scale_radius(limits = c(20, NA),
               range = c(3, 30)) +
  scale_colour_gradient(low = "#66aaf2",
                        high = "#00FF00") +
  theme_minimal()
