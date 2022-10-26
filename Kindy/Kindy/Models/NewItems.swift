//
//  NewItem.swift
//  Kindy
//
//  Created by Sooik Kim on 2022/10/26.
//

import Foundation
import UIKit


class NewItems {
    
    static var bookstoreDummy: [Bookstore] = [
        Bookstore(images: [UIImage(named: "B급취향1")!, UIImage(named: "B급취향2")!, UIImage(named: "B급취향3")!, UIImage(named: "B급취향4")!, UIImage(named: "B급취향5")!, UIImage(named: "B급취향6")!] , name: "B급취향", address: "경상북도 포항시 북구 장량로241번길 12 (양덕동) 1층", telNumber: "0507-1398-5416", emailAddress: "b_ook_taste@naver.com", instagramURL: "https://www.instagram.com/b_ook_taste/", businessHour: BusinessHour(monday: "12:00 ~ 19:00",tuesday: "12:00 ~ 19:00", wednesday: "12:00 ~ 19:00", thursday: "12:00 ~ 20:00", friday: "12:00 ~ 20:00", saturday: "12:00 ~ 20:00", sunday: "12:00 ~ 18:00", etc: "" ), description: """
            B급취향은 "누구도 배제하지 않는, 누구나 머물 수 있는 공간"이라는 슬로건을 바탕으로 운영하는 디저트 카페 겸 독립서점입니다.
            B급취향이라는 이름 답게 페미니즘, 사회주의, 동물권, 장애인권, 성소수자인권, 환경권, 사회주의 등 비주류를 전면에 내세워 그 가치를 실현하기 위해 비건/논비건 디저트를 판매하고 독립출판물과 단행본, 중고 서적을 판매합니다.
            주 출입구 문턱이 없어 유아차와 휠체어 진입이 수월합니다.
            어린이 손님을 위해 열람이 가능한 동화책과 유아 전용 의자가 마련되어 있습니다.

            기수 별로 독서 모임과 글쓰기 모임을 진행하고 있으며, 책방지기 끼리 주고 받는 편지 형식의 메일링 서비스를 운영하고 있습니다.
""", location: Location(latitude: 36.0831375, longitude: 129.4069346), isFavorite: true),
        
        Bookstore(images: [UIImage(named: "무사이책방1")!, UIImage(named: "무사이책방2")!, UIImage(named: "무사이책방3")!, UIImage(named: "무사이책방4")!, UIImage(named: "무사이책방5")!, UIImage(named: "무사이책방6")!, UIImage(named: "무사이책방7")!, UIImage(named: "무사이책방8")!, UIImage(named: "무사이책방8")!, UIImage(named: "무사이책방10")!, UIImage(named: "무사이책방11")!] , name: "무사이책방", address: "부산광역시 북구 산성로12번길 21 (화명동 , 우신아파트상가) 지하 1층", telNumber: "051-362-7004", emailAddress: "mousai0042@naver.com", instagramURL: "https://www.instagram.com/mousai.official", businessHour: BusinessHour(monday: "12:00 ~ 19:00",tuesday: "12:00 ~ 19:00", wednesday: "12:00 ~ 19:00", thursday: "12:00 ~ 20:00", friday: "12:00 ~ 20:00", saturday: "12:00 ~ 20:00", sunday: "12:00 ~ 18:00", etc: "" ), description: """
           무사이 책방'은 복합문화공간 무사이 안에 자리하고 있습니다. 신간과 정기간행물, 그리고 독립출판물을 만날 수 있습니다. 북토크, 글쓰기 강좌, 그리고 독서모임과 같이 책을 매개로 하는 여러가지 프로그램도 기획하고 있습니다. '무사이 책방'은 널리 알려진 책보다는, 알려질 필요가 있다고 생각하는 책을 소개합니다. 그동안 미처 알지 못했던 취향을 발견하는 공간이 되었으면 바람을 갖고 오늘도 다양한 목소리에 귀를 기울입니다.
""", location: Location(latitude: 35.2383705, longitude: 129.0156939)),
        
        Bookstore(images: [UIImage(named: "소요서가1")!, UIImage(named: "소요서가2")!, UIImage(named: "소요서가3")!] , name: "소요서가", address: "서울특별시 중구 청계천로 160 (산림동 , 세운청계상가) 바열 309호", telNumber: "02-2272-1517", emailAddress: "soyoseoga@gmail.com", instagramURL: "www.instagram.com/soyoseoga", businessHour: BusinessHour(monday: "휴무",tuesday: "12:00 ~ 20:00", wednesday: "12:00 ~ 20:00", thursday: "12:00 ~ 20:00", friday: "12:00 ~ 20:00", saturday: "12:00 ~ 20:00", sunday: "휴무", etc: "" ), description: """
            소요서가는 을지로 청계상가 3층 데크에 위치한 '철학전문서점'으로, 전문가에게도 가볍지 않고 애호가에게도 무겁지 않은 서점을 지향합니다. 현재 동서양의 철학고전부터 현대사회의 주요 쟁점들을 다룬 인문교양서까지 3000여 종의 장서를 보유하고 있으며 철학강의와 독서모임, 서평 등을 정기적으로 운영하고 있습니다.
""", location: Location(latitude: 37.5679121, longitude: 126.9953938)),
        
//        Bookstore(images: [UIImage(named: "한길문고 바깥풍경")!, UIImage(named: "한길문고 간판사진")!, UIImage(named: "한길문고 매장2")!, UIImage(named: "권윤덕작가")!, UIImage(named: "나태주시인")!, UIImage(named: "북캠프3")!, UIImage(named: "북캠프4")!, UIImage(named: "북캠프5")!, UIImage(named: "엉덩이로 책읽기 성인")!, UIImage(named: "정유정작가")!, UIImage(named: "정재승과학자")!, UIImage(named: "한길문고 음악회")!, UIImage(named: "회색인간 김동식")!] , name: "한길문고", address: "군산시 하나운로 38, 2층 한길문고", telNumber: "063-463-3131", emailAddress: "3131book@hanmail.net", instagramURL: "", businessHour: BusinessHour(monday: "10:00 ~ 21:00",tuesday: "10:00 ~ 21:00", wednesday: "10:00 ~ 21:00", thursday: "10:00 ~ 21:00", friday: "10:00 ~ 21:00", saturday: "10:00 ~ 21:00", sunday: "10:00 ~ 21:00", etc: "명절 당일 휴무" ), description: """
//            한길문고 (since 1987 - 군산 녹두서점부터)
//            1987년 녹두서점을 시작으로 2002년 한길문고로 서점명을 변경하였다. 2012년 군산에 444ml라는 폭우가 내렸고 지하에 있던 한길문고는 10만권의 책을 모두 잃었다. 10만권이라는 책의 값어치는 말로 이루할 수 없지만 그에 더불어 폭우가 휩쓸고 간 서점 내부는 이곳이 어떤 장소였는지 분간하기 힘들정도로 구분하기 힘들었다. 당시 서점 내부에는 희망이라곤 보이지 않았다. 공간과 책의 값어치는 물로 인해 한순간에 사라져 버린 것이다.
//            이 상황은 故이민우 사장님에게 그야말로 세상이 무너지는 느낌이었을 것이다. 그런데 기적이 일어난 것이다. 한사람이서 만들 수 없는 기적을 군산 시민들께서 만들어 주신 것이다. 직장인 아닌 서점으로 출근을 하여 이미 값어치가 사라진 책들은 한곳에 정리하고 빛을 잃은 서점 공간을 쓸고 닦아주신 것이다. 그렇게 한길문고는 피해 한 달만에 다시 오픈을 할 수 있게 되었다.
//            현재 한길문고는 당시 운영하던 지하에서 하고 있지 않고 2층에서 하고 있다. 시간이 해결해 줄 수 없는 것이 가끔은 있다. 지하에서 얻은 트라우마는 현재 한길문고를 운영하고 계신 문지영 대표님께는 크게 다가갔다. “만약 다른 곳에서 한길문고를 운영해도 지하에서는 하고 싶진 않아요.” 대표님께서 직접 하신 말씀이시다.
//            또 한 가지 해결 할 수 없는게 더 있다. 이민우 사장님께서 돌아가신 것이다. 다른 무엇보다 사람이 먼저였던 사장님은 어느 누구하고도 대체 불가이다. 하지만 그런 사장님께서 한길문고에 남기고 가신 것이 있다. 그것은 기적같이 한길문고를 다시 열게 도와주신 군산시민들에게 받은 ‘빚’을 돌려드리는 것이다. 서점에서 돌려드릴 방법은 문화행사 또는 공간을 통해서라고 당시부터 말씀하셨다.
//            그리하여 한길문고는 매월 문화행사를 진행하였고, 군산시민들께서도 계속 방문중에 있다. 하지만 인터넷서점과 다양한 편리한 도서구입 방법으로 인해 지역서점(한길문고 포함)은 경쟁에서 밀릴 수밖에 없다. 작년 코로나 상황 때문에 행사를 많이 진행하지 못하였지만, 2019년 한길문고의 행사는 호황 그 자체였다. 정재승 박사, 정유정 작가, 나태주 시인 등 잘 알지 못하더라도 한번쯤은 들어 봤을 유명한 작가님들을 많이 섭외하였고, 많을 때는 150명의 고객을 모시고 강연을 진행했다.
//""", location: Location(latitude: 35.9621863, longitude: 126.7007825)),
        
        Bookstore(images: [UIImage(named: "좋아서점1")!,UIImage(named: "좋아서점2")!,UIImage(named: "좋아서점3")!,UIImage(named: "좋아서점4")!,UIImage(named: "좋아서점5")!] , name: "좋아서점", address: "경상북도 영주시 대학로78번길 3 (가흥동)", telNumber: "010-4667-0377", emailAddress: "salang6262@naver.com ", instagramURL: "https://www.instagram.com/like.you365", businessHour: BusinessHour(monday: "10:00 ~ 22:00",tuesday: "10:00 ~ 22:00", wednesday: "10:00 ~ 22:00", thursday: "10:00 ~ 22:00", friday: "10:00 ~ 22:00", saturday: "10:00 ~ 22:00", sunday: "10:00 ~ 22:00", etc: "무인서점" ), description: """
            좋아서점은 무인서점으로 운영되는 독립서점 입니다. 책방에 오셔서 독립서적, LP음악들과 함께 비움의 시간을 가져 보세요.
""", location: Location(latitude: 36.8081412, longitude: 128.6160497)),
        
        Bookstore(images: [UIImage(named: "서실리책방1")!,UIImage(named: "서실리책방2")!,UIImage(named: "서실리책방3")!,UIImage(named: "서실리책방4")!,UIImage(named: "서실리책방5")!] , name: "서실리책방", address: "제주특별자치도 제주시 구좌읍 중산간동로 2262", telNumber: "010-5112-0406", emailAddress: "silver367@naver.com", instagramURL: "https://www.instagram.com/seosilli_books/", businessHour: BusinessHour(monday: "11:00 ~ 16:00",tuesday: "11:00 ~ 16:00", wednesday: "휴무", thursday: "휴무", friday: "11:00 ~ 16:00", saturday: "11:00 ~ 16:00", sunday: "11:00 ~ 16:00", etc: "" ), description: """
           조용한 마을에 있는 조용하고 작은 책방
""", location: Location(latitude: 33.4713168, longitude: 126.784255)),
        
        Bookstore(images: [UIImage(named: "속초동아서점1")!,UIImage(named: "속초동아서점2")!,UIImage(named: "속초동아서점3")!,UIImage(named: "속초동아서점4")!] , name: "속초 동아서점", address: "강원도 속초 수복로 108 (교동)", telNumber: "033-632-1555", emailAddress: "duhgun@naver.com", instagramURL: "www.instagram.com/bookstoredonga", businessHour: BusinessHour(monday: "09:00 ~ 21:00",tuesday: "09:00 ~ 21:00", wednesday: "09:00 ~ 21:00", thursday: "09:00 ~ 21:00", friday: "09:00 ~ 21:00", saturday: "09:00 ~ 21:00", sunday: "휴무", etc: "" ), description: """
            1956년에 개점하여 3대째 운영 중인 강원도 속초의 동네서점.
""", location: Location(latitude: 38.2008638, longitude: 128.5808805)),
        
        Bookstore(images: [UIImage(named: "노말에이1")!,UIImage(named: "노말에이2")!,UIImage(named: "노말에이3")!,UIImage(named: "노말에이4")!, UIImage(named: "노말에이5")!,UIImage(named: "노말에이6")!,UIImage(named: "노말에이7")!] , name: "노말에이", address: "서울특별시 중구 마른내로 12 (저동2가) 4층", telNumber: "070-4681-5858", emailAddress: "normala.kr@gmail.com", instagramURL: "www.instagram.com/normala.kr", businessHour: BusinessHour(monday: "12:00 ~ 18:00",tuesday: "12:00 ~ 18:00", wednesday: "12:00 ~ 18:00", thursday: "12:00 ~ 18:00", friday: "12:00 ~ 18:00", saturday: "13:00 ~ 18:00", sunday: "12:00 ~ 18:00", etc: "" ), description: """
            노말에이는 디자인스튜디오 131WATT(일삼일와트)가 운영하는 서점으로 BOOK IS ANSWER라는 슬로건을 가지고 2015년 문을 열었습니다.
            900여 종의 국내외 서적, 200여 종의 문구류를 직접 큐레이션 하여 밀도 있게 소개하고 있습니다.
            노말에이는 책에 집중할 수 있는 조용하고 차분한 분위기의 공간을 지향합니다. 책을 통해 답을 얻을 수 있는 시간을 가져보세요.
""", location: Location(latitude: 37.564614, longitude: 126.9891333), isFavorite: true),
        
        Bookstore(images: [UIImage(named: "공간과몰입1")!,UIImage(named: "공간과몰입2")!,UIImage(named: "공간과몰입3")!,UIImage(named: "공간과몰입4")!] , name: "공간과몰입", address: "서울특별시 종로구 낙산길 19 (동숭동) 1층", telNumber: "010-4963-8097", emailAddress: "gggmolip@naver.com", instagramURL: "https://www.instagram.com/gggmolip/", businessHour: BusinessHour(monday: "휴무",tuesday: "휴무", wednesday: "19:00 ~ 22:00", thursday: "휴무", friday: "19:00 ~ 22:00", saturday: "13:00 ~ 20:00", sunday: "13:00 ~ 20:00", etc: "" ), description: """
            온전한 몰입을 위한 공간, 공간과몰입입니다.
            사소한 무언가에 과몰입한 책을 우선적으로 입고합니다.
""", location: Location(latitude: 37.5805484, longitude: 127.0056108), isFavorite: true),
        
        Bookstore(images: [UIImage(named: "일상서재1")!,UIImage(named: "일상서재5")!,UIImage(named: "일상서재2")!,UIImage(named: "일상서재3")!,UIImage(named: "일상서재4")!] , name: "일상서재", address: "충청남도 천안시 동남구 대흥로 207 (대흥동) 1층", telNumber: "010-8812-0152", emailAddress: "uiyonglee@naver.com", instagramURL: "www.instagram.com/dailybooooks", businessHour: BusinessHour(monday: "휴무",tuesday: "13:00 - 21:00", wednesday: "13:00 - 21:00", thursday: "13:00 - 21:00", friday: "13:00 - 21:00", saturday: "13:00 - 21:00", sunday: "휴무", etc: "" ), description: """
            소소한 일상이 책으로, 낯선 문장이 당신의 일상으로, 은은하게 스며드는 공간'
            책 짓는 독립서점 <일상서재> 입니다.
            일상서재는 일상 속에서 누구나 발견할 수 있는 일상의 책방입니다.
            잘 지어진 책보다 『독립출판물』이라는 '괜찮지 않아도 괜찮은' 책들을 취급합니다.
            당신과 당신의 하루에 의미를 건내줄 좋은 책을 만나고,
            당신의 일상으로 좋은 책을 만드는 공간이 되었으면 좋겠습니다.
            10살 푸들 망고와 캘리그라퍼 일상수집가가 책방지기로 공간을 꾸리고 있답니다.
            1층에는 일인출판사와 독립서점, 2층에는 복합문화공간이 함께 운영되고 있습니다.
            복합문화공간은 입주 공간(4명의 작가님)과 대관 공간(스튜디오, 갤러리, 세미나실)으로 구성되어 있습니다.
""", location: Location(latitude: 36.8067541, longitude: 127.14688640)),
        
        Bookstore(images: [UIImage(named: "밤산책방1")!,UIImage(named: "밤산책방2")!,UIImage(named: "밤산책방3")!,UIImage(named: "밤산책방4")!] , name: "밤산책방", address: "부산 수영구 수영로510번길 42 지층 1호 지하1층", telNumber: "", emailAddress: "", instagramURL: "https://www.instagram.com/bam_sanchaek_bang/", businessHour: BusinessHour(monday: "00:00 ~ 19:00",tuesday: "휴무", wednesday: "휴무", thursday: "휴무", friday: "08:00 ~ 24:00", saturday: "00:00 ~ 24:00", sunday: "00:00 ~ 24:00", etc: "" ), description: """
            주말 낮, 밤 24시간 산책하듯 오셔서 쉬어가세요
            광안리에 위치한 작고 소박한 *위로를 위한 주말 무인 서점*입니다 !
""", location: Location(latitude: 35.150770, longitude: 129.113780)),
        
        Bookstore(images: [UIImage(named: "두두디북스1")!,UIImage(named: "두두디북스2")!,UIImage(named: "두두디북스3")!,UIImage(named: "두두디북스4")!] , name: "두두디북스", address: "부산광역시 수영구 수영로510번길 43 지하1층", telNumber: "010-4948-0367", emailAddress: "", instagramURL: "www.instagram.com/doodoodibooks/", businessHour: BusinessHour(monday: "00:00 ~ 24:00",tuesday: "00:00 ~ 24:00", wednesday: "00:00 ~ 24:00", thursday: "00:00 ~ 24:00", friday: "00:00 ~ 24:00", saturday: "13:00 ~ 19:00", sunday: "13:00 ~ 19:00", etc: "주중 무인 운영" ), description: """
            두두디북스 북카페&펍&바
            예술
            • Since 2016
            • 북카페 & 복합문화공간
            • 전시/공연/문화모임 진행
            - 주중 무인 운영(월-금)
            - 토 PM 1시~7시
            - 일 PM 1시~7시
            🔽 두두디북스 활동 참여 & 무인대관 & 조합원참여
            linktr.ee/doodoodibooks
""", location: Location(latitude: 35.15087560, longitude: 129.11396260)),
        
    ]
    
    
    static let curationDummy: [Curation] = [
        Curation(id: "1", title: "B급 취향,", subTitle: "감각적인 인테리어, 세심한 디저트 메뉴가 돋보이는 독립서점", mainImage: "B급취향_Curation1", headText: """
        누구도 배제하지 않고 누구나 머무를 수 있는 공간을 제공하고 싶다는 슬로건으로 책방을 운영하고 계십니다.\n
        책 큐레이션은 물론이고 비건을 위한 디저트도 준비되어 사장님이 책방에 진심이라는 것이 모든 곳에서 느껴진다.\n
        덧붙이자면 사장님께서 너무 유쾌하셔서 서점에서 주최하는 클래스 프로그램에 참여해보시길 꼭 추천드리고 싶다.\n
        10월22일 B급취향의 돌잔치가 개최된다니 궁금하시면 B급취향 인스타그램을 참고하시길!(킨디에서 자세한 정보를 찾아보시길..이면 좋겠다)\n
""", imageWithText: [("B급취향_Curation1", ""), ("B급취향_Curation2", ""), ("B급취향_Curation3", "")], infoText: """
        포항시 북구 장량로 241번길 12, 1층\n
        월-수 12:00-19:00 목-토 12:00-20:00 일 12:00-18:00\n
        인스타그램 https://www.instagram.com/b_ook_taste/\n
        유튜브 https://youtu.be/ne25n4EHsgQ\n\n

        #B급취향#포항#포항북구#양덕동#독립서점#북카페#인테리어#카페#비건#페미니즘#환경#클래스
""", bookStore: bookstoreDummy[0]),
        
        Curation(id: "2", title: "한가로운 일상,", subTitle: "잠시 쉬어갈 장소가 필요 없는 분들에게", mainImage: "testImage", headText: "📚 두두디북스 | 부산 수영구 \n\n✏️ 출입문부터 시작해 내부 인테리어까지 프라이빗한 아지트에 온 것 같은 느낌이 들었다.  공간이 생각보다 굉장히 넓었고, 펍 운영 공간은 이전에 생각하던 서점 분위기와는 반전되는 느낌이라 신선하고 재밌었다.  2016년부터 계속 자리를 지키고 있는 만큼 ‘만남’에 진심인 이 곳에서는 굉장히 다양한 클래스들을 개최하고 있어 부산에 계신 분이라면 시간을 내어 참여해봐도 좋을 것 같다", imageWithText: [("두두디북스1", ""), ("두두디북스2", ""), ("두두디북스3", ""), ("두두디북스4", "")], infoText: """
            주중 무인 운영(월-금),토 PM 1시~7시, 일 PM 1시~7시\n
            부산광역시 수영구 수영로510번길 43 (광안동, 광남빌라) 지하 1층\n
            인스타그램 www.instagram.com/doodoodibooks\n\n

            #두두디북스#부산#수영구#독립서점#전시#공연#북토크#펍#바#카페
""", bookStore: bookstoreDummy[10]),
        
        Curation(id: "3", title: "한가로운 일상,", subTitle: "잠시 쉬어갈 장소가 필요 없는 분들에게", mainImage: "testImage", headText: """
            밤산책방\n
            무인서점이라 서서 반겨주는 사람은 없었지만 서점 내 곳곳에 비치된 안내 문구에서 세심한 배려가 느껴져 기분 좋았다.\n
            어느날 조용한 위로를 받고싶은 날이 찾아 온다면 새벽 내내 따뜻한 불을 밝히고 있는 밤산책방으로 가보는 것을 추천한다.\n
""", imageWithText: [("밤산책방1", ""), ("밤산책방2", ""), ("밤산책방3", ""), ("밤산책방4", "")], infoText: """
                 금토일\n
                 부산광역시 수영구 수영로510번길 42 지하1층\n
                 인스타그램 https://www.instagram.com/bam_sanchaek_bang/\n\n
                 #밤산책방#부산#수영구#독립서점#무인서점#24시간서점#주말#공휴일
""", bookStore: bookstoreDummy[9])
    ]
    
}
