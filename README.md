# -Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data
# 텍스트마이닝 개인 프로젝트 - 민식이법 기사 데이터 분석
## 분석 기간 : 21.05.20~21.06.14
## 분석 업무 : Wordcloud, Sentiment Analysis, Phi Coefficient Analysis, LDA Topic modeling

### Ⅰ. 선정 데이터 및 선정 이유 : 민식이법

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/f12cacb7-89d5-430b-b032-6b44f8ed8ebd)

* 2019년 9월 충남 아산의 핚 어린이보호구역(스쿨존)에서 교통사고로 사망핚 김민식 굮(당시 9세) 사고 이후 발의된 법안으로, 2019년 12월 10일 국회를 통과해 2020년 3월 25일부터 시행됐다.
  
* 법안은 ▷어린이보호구역 내 싞호등과 과속단속카메라 설치 의무화 등을 담고 있는 '도로교통법 개정안'과 ▷어린이보호구역 내 앆전운전 의무 부주의로 사망이나 상해사고를 일으킨 가해자를 가중처벌하는 내용의 '특정범죄 가중처벌 등에 관한 법률 개정안' 등 2건으로 이뤄져 있다.
  
* 하지만 민식이 법에 대해서 **정당한 법안이다** 라고 생각하는 사람도 있지만 일각에서는 **처벌이 너무 과하다**라는 비판들도 적지않게 보여지고 있다. 따라서 민식이 법에 관한 기사들을 추출하여 **텍스트 마이닝**을 통해 여론의 흐름과 법의 정당성에 대해 분석하고자 한다.

### Ⅱ. Wordcloud

```R
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
```

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/d1c581c4-3f80-4f75-8f1c-9d52b7d1ae96)

* "어린이보호구역", ‚"스쿨존", ‚"민식이법", ‚"어린이", "초등학교" 등의 단어 빈도가 다른 단어에 비해 상대적으로 높게 추출되어 워드클라우드 형태로 출력되고 있다.

### Ⅲ. Sentiment Analysis

```R
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
```

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/c8f1cc53-0b77-452f-97e9-2d557ddd4053)

#### 분석

  * 중립을 유지 중인 뉴스 기사들이 44.7%로 가장 많은 비중을 차지하고 있다.
  * 그 다음으로 32.4%로 부정적인 경향을 띠는 뉴스기사가 존재하고, 긍정적인 뉴스 기사는 22.9%로 가장 적은 비중을 차지하고 있다.
  * 민식군의 사고 이후 민식이법이 국회를 통과한 당시에는 여론이 긍정적인 방향으로 흘러 갔으나 이후 과잉처벌과 민식이 법의 모순점 등으로 부정적인 여론쪽으로 흘러 갔을 것으로 생각된다.
  * 최초 알려짂 것과는 달리 가해 운전자는 스쿨존의 제한속도인 30km보다 낮은 속도인 23km였던 것으로 확인되었다.
  * 또한 뚫린 도로가 아니라 반대편 차선에 신호 대기중이던 차량이 늘어서 있던 바람에 횡단보도를 건너는 아이를 놓쳤던것이다.
  * 이 부분을 여전히 많은 사람들이 찬반논쟁을 벌이고 있는 상황이다.

### Ⅳ. Phi Coefficient

```R
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

```


![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/df0f4a7c-15bd-407b-bba8-ef6eaf9e430f)

#### 분석

  * 어린이보호구역 치사 : 어린이 보호 구역 치사와 관계가 큰 단어가 ‚ "가중처벌법상"와‚ "특정범죄" 인 것을 보면 어린이 보호구역에서 위반을 하거나 치사사건이 발생한 경우 "특정범죄 가중처벌법상 위반"으로 처벌 받는 것을 간접적으로 알 수 있다. 또한, "치다, "운전기사, "화물차", "초등학생" 들의 단어를 보아 운전기사가 화물차를 운전하다 어린이 보호 구역에서 사고가 발생했음을 짐작할 수 있다.

  * 운전기사 : 운전기사와 관계가 큰 단어를 보면 ‚"구속", "치다", "가중처벌법상"등이 존재핚다. 앞서 확인한 ‚ "어린이보호구역 치사"단어와 관계가큰 단어들과 함께 유추해 볼 때 운전기사가 어린이 보호구역에서 화물차를 운전하면서 우회전을 하다가 초등학생을 치면서 어린이가 사망하게되고 어린이 보호구역 치사사건이 발생하게 된 것이다. 그리고 그 운전자는 특별범죄 가중처벌법상 위반으로 구속을 당한 것을 정확하게 확인할 수 있다.

  * 인천 : 인천과 관계가 큰 단어를 확인해보면 "화물차", "초등학생", "숨지다"등이 존재하며 다른 단어들과의 상관관계를 분석하여 유추해볼 경우 인천 중구 신흥동 부근에서 화물 운전자가 어린이 보호 구역에서 초등학생을 쳐 숨지게 함으로써 민식이 사건과 동일하게 운전자는 특별범죄 가중처벌법상 위반으로 중부경찰서로 입건이 된 것을 알 수 있다.

### Ⅴ. Phi Coefficient Network Analysis

```R
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
```

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/4c570930-2563-4bc6-98ab-5d9176b3a71c)

#### 분석

  * 서로 연관된 그래프를 유추해 볼때 어린이 보호구역 치사사건 발생 시 특정범죄 가중처벌법상 위반으로 구속이 될 수 있음을 알수 있고, ‚"강화한"-"처벌"의 관계를 볼 때 어린이 교통안전법에 대해 현재보다 처벌이 더 강화되고 있음을 알 수있다.
  
  * 하지만 법이 강화됨에도 불구하고 인천시 중구 신흥동에서 민식이 사건와 유사한 사고가 발생한 것을 볼때 여전히 어린이 보호구역에서 안전사고 위험에 노출이 많이 되어있음을 알 수 있다.

### Ⅵ. LDA Topic modeling Analysis

#### Ⅵ-ⅰ. Extracting Key Words for Each Topic using LDA

```R
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
```

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/c72a3a5f-f65c-4d71-849b-3689e8620f49)

* Topic 1. : **초등학교**, 경찰, 신흥동, **사망**, 인근, **어린이보호구역(스쿨존)**
* Topic 2. : 기자, **횡단보도**, **운전자**, 앵커, 보도, 오전
* Topic 3. : **스쿨**, 발생, 들이, 이후, 초등학교, **아이들**
* Topic 4. : 불법, **가중처벌**, 국민, 위반, 기소, **사고**
* Topic 5. : 차량, 개정, **운전자**, 놀이, **민식이법**, 영상
* Topic 6. : **시행**, **강화**, 지난해, **과속**, 설치, 단속
* Topic 7. : 인천, 초등학생, **화물차**, 혐의, **치사**, 오후
* Topic 8. : **안전**, **교통안전**, **학교**, 시설, 행정, 광주

#### Ⅵ-ⅱ. Word Frequency Graph through LDA-based Topic Modeling

```R
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
```

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/1ea6fb00-c5d3-41e0-b1ea-a36a5416dfb3)

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/e7aac9c6-a533-4782-ba0f-29b5b129ebdb)

* 앞서 도출한 토픽별 단어와 실제 언급된 단어가 속한 문서들을 종합하여 각 토픽별 네이밍을 수행
  * Topic 1. : "민식이 법 사건의 발단"
  * Topic 2. : "50대 남성이 몰던 차에 깔려 30대 어머니 사망‚
  * Topic 3. : "어린이보호구역(스쿨존) 내 교통사고 위험에 대한 경각심이 높아지고 있음"
  * Topic 4. : "여전히 해결되지 않는 어린이 구역 안전사고"
  * Topic 5. : "사건이나 사고의 피해자 이름과 관련된 법"
  * Topic 6. : "도로교통법에 대한 규제 강화"
  * Topic 7. : "민식이 법, 특정범죄 가중처벌 적용"
  * Topic 8. : "국가차원의 어린이 구역 산재예방과 교통안전 강화"

Ⅶ. 결론

* 민식이 법에 관한 뉴스 기사와 R Programming 프로그램에서 지원하는 기능을 통해 다양한 기법들로 분석을 수행

* 사용된 분석 기법은 "감정분석(Sentiment Analysis)"‚ "워드클라우드(Wordcloud)", "막대 그래프 출력", "파이계수 네트워크 그래프(Phy Correlation Graph)", "LDA 모델 기반의 토픽모델링(Topic Modeling)"등이 사용됨

* 프로그램에서 토픽별로 확률이 가장 높은 단어를 추출해 맊든 토픽들과 사용자가 직접 문서들을 분석해 명명한 토픽 이름들에서 약간의 차이가 존재함 하지만 대부분은 유사했으며, 직접문서들을 읽고 주요 단어들을 찾아내며 토픽별 이름을 부여해보면서 데이터를 분석하는 능력을 함양할 수 있는 계기가 되었고 분석 과정 중 민식이 법이 가진 장·단점들도 함께 파악할 수 있었음

* 민식이 법은 분명 초기에는 많은 사람들의 공감과 지지를 얻으며 성공적으로 제정되었으나 이후 법에 대한 과잉처벌, 법 제정 자체에 대한 모순점 등의 이유로 점차 사람들의 인식이 부정적으로 바뀌었으며, 아직까지도 현재 진행형임
* 분명 민식이 법의 제정의도는 좋으나 법에 대핚 처벌 정도나 민식이 법과 유사핚 여러 어린이 교통 안전법에 대한 개선이 필요할 것으로 사료됨

* 수업에서 배운 다양한 텍스트 마이닝 기법들은 뉴스 뿐 아니라 경제 데이터의 지표 분석, 주식 및 증권 분석등에도 활용할 수 있다면 수 많은 기업에서 편리함과 시각화 뿐 아니라 미래에 경제에 대한 부가가치 창출도 충분히 기대할 수 있음
