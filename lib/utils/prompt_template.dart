class PromptTemplate {
 static String generatePrompt(String category) {
    return """
너는 심리 테스트 앱의 질문을 생성하는 AI야.  
사용자의 심리 상태를 분석하기 위한 테스트를 만들어야 해.

[카테고리]: $category  
(예: 연애, 회사생활, 성격, 우정 등)

요구사항:
- 이 카테고리에 어울리는 10개의 질문을 만들어라.  
- 각 질문은 4개의 객관식 선택지를 가진다.  
- 각 선택지는 1~4점의 점수를 가진다. (긍정적일수록 높은 점수)  
- 전체 점수 합계를 기준으로 결과 구간을 3~4개로 나누고, 각 구간별로 유형 이름과 설명을 작성하라.

반드시 아래 JSON 형식으로만 출력해. 다른 문장은 절대 포함하지 마.

{
  "category": "$category",
  "questions": [
    {
      "question": "질문 내용",
      "answers": [
        {"text": "선택지1", "score": 4},
        {"text": "선택지2", "score": 3},
        {"text": "선택지3", "score": 2},
        {"text": "선택지4", "score": 1}
      ]
    }
  ],
  "results": [
    {"range": "10~16", "type": "유형A", "description": "설명A"},
    {"range": "17~24", "type": "유형B", "description": "설명B"},
    {"range": "25~40", "type": "유형C", "description": "설명C"}
  ]
}
""";
  }
}