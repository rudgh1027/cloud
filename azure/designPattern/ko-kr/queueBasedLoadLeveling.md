# 패턴 설명
 출처 : https://docs.microsoft.com/ko-kr/azure/architecture/patterns/queue-based-load-leveling
 
## 1. 특징
    - 큐에서 정해진 속도로 메시지를 전송하여 과부하에 의한 서비스 중단 예방
    - 치솟는 서비스 수요에 따라 인스턴스를 프로비저닝하여 리소스 스케일 변화를 확인
    
## 2. 이점
    - 서비스 지연이나 장애 시에도 사용자들은 큐를 사용할 수 있어 가용성을 최대화 할 수 있음
    - 트레픽에 따라 큐와 서비스 수를 모두 조절 가능
    - 리소스의 사용량을 예측하여 비용 최적화
    
## 3. 요구사항
    - 메세지 처리 속도 제어가 필요
    - 비동기 메커니즘 구현 필요
    - 자동 크기 조정으로 경합이 발생하여 큐를 사용하는 효과가 저하될 수 있음

# 사용 예시

## 1. 문제상황
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-overwhelmed.png"></img>
    - Web app 에서 Datastore로 직접 데이터를 전송하는 경우 요청이 증가하면 작업이 실패 할 수 있음
   
## 2. 해결방안
<img src="https://docs.microsoft.com/ko-kr/azure/architecture/patterns/_images/queue-based-load-leveling-function.png"></img>
    - Service Bus Queue와 Queue triggered azure function 을 이용하여 데이터 저장소에 전달하는 속도를 제어
   
# 시스템 구축 테스트
## 1. 테스트 계획
- 심박수와 체온을 초단위로 전송하는 Health Care 시스템을 가정
- Datastore는 Azure table storage로 구현
- Case 1 : Console application -> Table storage (10만건 데이터 송신시 n건 작업 실패 예상)
- Case 2 : Console application -> Service bus queue -> Function app -> Table storage
  - Queue가 buffer 역할을 하여 작업 정상 수행 예상

## 2. 실제 구현
다음 링크에 구현되어 있음
https://github.com/rudgh1027/cloud/blob/master/azure/002.queueTriggeredFunction_tableInsert/README.md

# Lessen & Learn
- Case 1은 구현하지 않음
  - 장애유발 불가 : Console appication을 통해 Queue에 데이터 쌓는 속도 초당 1~2건 인 것에 반해, Table storage는 초당 1kb 데이터 20,000건 보장
  - Table storage보다는 CosmosDB권장 : 10,000,000 이상 TPS 보장, 장애 복구 및 복제 등 
  - 참조 : https://docs.microsoft.com/ko-kr/azure/cosmos-db/table-support
- 개인적인 생각
  - 제공된 사용 예시처럼 단순 스토리지 앞단에서 쓰기용 버퍼로서의 기능은 무의미함(Radis cache를 사용)
  - 참조 : https://azure.microsoft.com/ko-kr/services/cache/
  - 사용량 예측을 위한 POC 기간에 사용하도록하고, 추가로 다음과 같은 시스템에서 사용시 *부하 평준화 패턴으로서 이점*이 있다고 생각함.
   <img src="https://docs.microsoft.com/ko-kr/azure/architecture/example-scenario/ai/media/mass-ingestion-newsfeeds-architecture.png"></img>
    - 참조 : https://docs.microsoft.com/ko-kr/azure/architecture/example-scenario/ai/newsfeed-ingestion
    - 여러 API를 순차적으로 거쳐가며 작업이 수행 됨
    - 특정 API에 장애 혹은 병목이 발생할 시 Queue가 Buffer 역할을 하여 부하를 조절해 줌
    - Retry 혹은 circuit-breaker 패턴으로 추가 보완하여 시스템 전체의 가용성과 효율성을 증대시킬 수 있음
  
