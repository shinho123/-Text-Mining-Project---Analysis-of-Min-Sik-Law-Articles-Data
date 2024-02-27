# -Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data
# 텍스트마이닝 개인 프로젝트 - 민식이법 기사 데이터 분석
## 분석 기간 : 21.05.20~21.06.14
## 분석 업무 : Wordcloud, Sentiment Analysis, Phi Coefficient Analysis, N-gram Analysis, LDA Topic modeling

### 선정 데이터 및 선정 이유 : 민식이법

![image](https://github.com/shinho123/-Text-Mining-Project---Analysis-of-Min-Sik-Law-Articles-Data/assets/105840783/f12cacb7-89d5-430b-b032-6b44f8ed8ebd)

* 2019년 9월 충남 아산의 핚 어린이보호구역(스쿨존)에서 교통사고로 사망핚 김민식 굮(당시 9세) 사고 이후 발의된 법안으로, 2019년 12월 10일 국회를 통과해 2020년 3월 25일부터 시행됐다.
  
* 법안은 ▷어린이보호구역 내 싞호등과 과속단속카메라 설치 의무화 등을 담고 있는 '도로교통법 개정안'과 ▷어린이보호구역 내 앆전운전 의무 부주의로 사망이나 상해사고를 일으킨 가해자를 가중처벌하는 내용의 '특정범죄 가중처벌 등에 관한 법률 개정안' 등 2건으로 이뤄져 있다.
  
* 하지만 민식이 법에 대해서 **정당한 법안이다** 라고 생각하는 사람도 있지만 일각에서는 **처벌이 너무 과하다**라는 비판들도 적지않게 보여지고 있다. 따라서 민식이 법에 관한 기사들을 추출하여 **텍스트 마이닝**을 통해 여론의 흐름과 법의 정당성에 대해 분석하고자 한다.

### Wordcloud

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

### Sentiment Analysis

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

#### 결과
  * 중립을 유지 중인 뉴스 기사들이 44.7%로 가장 많은 비중을 차지하고 있다.
  * 그 다음으로 32.4%로 부정적인 경향을 띠는 뉴스기사가 존재하고, 긍정적인 뉴스 기사는 22.9%로 가장 적은 비중을 차지하고 있다.
#### 분석
  * 민식군의 사고 이후 민식이법이 국회를 통과한 당시에는 여론이 긍정적인 방향으로 흘러 갔으나 이후 과잉처벌과 민식이 법의 모순점 등으로 부정적인 여론쪽으로 흘러 갔을 것으로 생각된다.
  * 최초 알려짂 것과는 달리 가해 운전자는 스쿨존의 제한속도인 30km보다 낮은 속도인 23km였던 것으로 확인되었다.
  * 또한 뚫린 도로가 아니라 반대편 차선에 신호 대기중이던 차량이 늘어서 있던 바람에 횡단보도를 건너는 아이를 놓쳤던것이다.
  * 이 부분을 여전히 많은 사람들이 찬반논쟁을 벌이고 있는 상황이다.
