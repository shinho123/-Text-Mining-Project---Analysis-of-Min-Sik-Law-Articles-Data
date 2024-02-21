# 토픽별 주요 문서 추출하기
reply_topic <- min_topic %>%
  group_by(topic) %>%
  slice_max(gamma, n = 100)

reply_topic %>%
  filter(topic == 8) %>%
  pull(sentence)

# 토픽 이름 목록 만들기
name_topic <- tibble(topic = 1:8,
                     name = c("1. 민식이 법 사건의 발단",
                              "2. 50대 남성이 몰던 차에 깔려 30대 어머니 사망",
                              "3. 어린이보호구역(스쿨존) 내 교통사고 위험에 대한 경각심이 높아지고 있음",
                              "4. 여전히 해결되지 않는 어린이 구역 안전사고",
                              "5. 사건이나 사고의 피해자 이름을 딴 법",
                              "6. 도로교통법에 대한 규제 강화",
                              "7. 민식이 법, 특정범죄 가중처벌 적용",
                              "8. 국가차원의 어린이 구역 산재예방과 교통안전 강화"
                     ))
name_topic

# 토픽 이름 부여하기
top_term_topic_name <- top_term_topic %>%
  left_join(name_topic, name_topic, by = "topic")

top_term_topic_name

# 막대 그래프 만들기
top_term_topic_name %>%
  ggplot(aes(x = reorder_within(term, beta, name),
             y = beta,
             fill = factor(topic))) +
  geom_col(show.legend = F) +
  facet_wrap(~ name, scales = "free", ncol = 4) +
  coord_flip() +
  scale_x_reordered() +
  labs(title = "민식이법 기사 토픽",
       subtitle = "토픽별 주요 단어 Top10",
       x = NULL,
       y = NULL) +
  theme_minimal() +
  theme(text = element_text(family = "bhs"),
        plot.title = element_text(size = 14, face = "bold"),
        plot.subtitle = element_text(size = 12),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())
