//
//  test.swift
//  Kindy
//
//  Created by 정호윤 on 2022/11/05.
//

import Foundation

let bookstores: [Bookstore] = [
    Bookstore(
        images: [
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%86%8C%EC%9A%94%EC%84%9C%EA%B0%80%2F%E1%84%89%E1%85%A9%E1%84%8B%E1%85%AD%E1%84%89%E1%85%A5%E1%84%80%E1%85%A1_%E1%84%82%E1%85%A2%E1%84%87%E1%85%AE%E1%84%8B%E1%85%AF%E1%86%AB%E1%84%8C%E1%85%A5%E1%86%AB.jpg?alt=media&token=7fffea20-317b-486e-8019-5168df399ca4",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%86%8C%EC%9A%94%EC%84%9C%EA%B0%80%2F%E1%84%89%E1%85%A9%E1%84%8B%E1%85%AD%E1%84%89%E1%85%A5%E1%84%80%E1%85%A1_%E1%84%82%E1%85%A2%E1%84%87%E1%85%AE%E1%84%8E%E1%85%B3%E1%86%A8%E1%84%86%E1%85%A7%E1%86%AB%E1%84%86%E1%85%A2%E1%84%83%E1%85%A2.jpg?alt=media&token=5c176d6f-7505-4539-8abd-328b8530cf2d",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%86%8C%EC%9A%94%EC%84%9C%EA%B0%80%2F%E1%84%89%E1%85%A9%E1%84%8B%E1%85%AD%E1%84%89%E1%85%A5%E1%84%80%E1%85%A1_%E1%84%8B%E1%85%AC%E1%84%87%E1%85%AE%E1%84%8C%E1%85%A5%E1%86%AB%E1%84%86%E1%85%A7%E1%86%AB_%E1%84%87%E1%85%A1%E1%86%B7.jpg?alt=media&token=b1f41a69-2c64-4d3c-b95d-5844ea6d29b5"
        ],
        name: "소요서가",
        address: "서울특별시 중구 산림동 156-8",
        description: "소요서가는 을지로 청계상가 3층 데크에 위치한 '철학전문서점'으로, 전문가에게도 가볍지 않고 애호가에게도 무겁지 않은 서점을 지향합니다. 현재 동서양의 철학고전부터 현대사회의 주요 쟁점들을 다룬 인문교양서까지 3000여 종의 장서를 보유하고 있으며 철학강의와 독서모임, 서평 등을 정기적으로 운영하고 있습니다.",
        contact: Contact(
            telNumber: "010-7667-3784",
            emailAddress: "millgamm@naver.com",
            instagramURL: nil
        ),
        businessHour: BusinessHour(
            monday: nil,
            tuesday: "화 12:00 - 20:00",
            wednesday: "수 12:00 - 20:00",
            thursday: "목 12:00 - 20:00",
            friday: "금 12:00 - 20:00",
            saturday: "토 12:00 - 20:00",
            sunday: nil,
            notice: nil
        ),
        location: Location(latitude: 37.5681642, longitude: 126.9951849)
    ),
    
    Bookstore(
        images: [
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2FB%EA%B8%89%EC%B7%A8%ED%96%A5%2FB%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8E%E1%85%B1%E1%84%92%E1%85%A3%E1%86%BC1.jpeg?alt=media&token=f5fb5afa-c4f7-497e-b1ca-0aadebf82188",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2FB%EA%B8%89%EC%B7%A8%ED%96%A5%2FB%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8E%E1%85%B1%E1%84%92%E1%85%A3%E1%86%BC2.jpeg?alt=media&token=31e71556-ed46-48cb-86f4-28bcf9446936",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2FB%EA%B8%89%EC%B7%A8%ED%96%A5%2FB%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8E%E1%85%B1%E1%84%92%E1%85%A3%E1%86%BC3.jpeg?alt=media&token=ed654ae8-86b0-46ff-b4cb-3bab139a3dd5",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2FB%EA%B8%89%EC%B7%A8%ED%96%A5%2FB%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8E%E1%85%B1%E1%84%92%E1%85%A3%E1%86%BC4.jpeg?alt=media&token=15a27341-5f16-4a1b-b108-775fbb33ef55",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2FB%EA%B8%89%EC%B7%A8%ED%96%A5%2FB%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8E%E1%85%B1%E1%84%92%E1%85%A3%E1%86%BC5.jpeg?alt=media&token=a29c7c24-0d9a-4526-b6ca-af72f64d61ad",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2FB%EA%B8%89%EC%B7%A8%ED%96%A5%2FB%E1%84%80%E1%85%B3%E1%86%B8%E1%84%8E%E1%85%B1%E1%84%92%E1%85%A3%E1%86%BC6.jpeg?alt=media&token=ca59005f-e8cf-4fe9-8874-ebb4aab09872"
        ],
        name: "B급취향",
        address: "경북 포항시 북구 장량로241번길 12 1층",
        description: "B급취향은 \"누구도 배제하지 않는, 누구나 머물 수 있는 공간\"이라는 슬로건을 바탕으로 운영하는 디저트 카페 겸 독립서점입니다. B급취향이라는 이름 답게 페미니즘, 사회주의, 동물권, 장애인권, 성소수자인권, 환경권, 사회주의 등 비주류를 전면에 내세워 그 가치를 실현하기 위해 비건/논비건 디저트를 판매하고 독립출판물과 단행본, 중고 서적을 판매합니다. 주 출입구 문턱이 없어 유아차와 휠체어 진입이 수월합니다. 어린이 손님을 위해 열람이 가능한 동화책과 유아 전용 의자가 마련되어 있습니다. 기수 별로 독서 모임과 글쓰기 모임을 진행하고 있으며, 책방지기 끼리 주고 받는 편지 형식의 메일링 서비스를 운영하고 있습니다.",
        contact: Contact(
            telNumber: nil,
            emailAddress: "b_ook_taste@naver.com",
            instagramURL: "https://www.instagram.com/b_ook_taste/"
        ),
        businessHour: BusinessHour(
            monday: "월 12:00 - 19:00",
            tuesday: "화 12:00 - 19:00",
            wednesday: "수 12:00 - 19:00",
            thursday: "목 12:00 - 20:00",
            friday: "금 12:00 - 20:00",
            saturday: "토 12:00 - 20:00",
            sunday: "일 12:00 - 18:00",
            notice: nil
        ),
        location: Location(latitude: 36.08315871547483, longitude: 129.40695978320272)
    ),
    
    Bookstore(
        images: [
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%A2%8B%EC%95%84%EC%84%9C%EC%A0%90%2F%E1%84%8C%E1%85%A9%E1%87%82%E1%84%8B%E1%85%A1%E1%84%89%E1%85%A5%E1%84%8C%E1%85%A5%E1%86%B71.jpg?alt=media&token=f62ab440-a311-484c-9947-5490106ea1de",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%A2%8B%EC%95%84%EC%84%9C%EC%A0%90%2F%E1%84%8C%E1%85%A9%E1%87%82%E1%84%8B%E1%85%A1%E1%84%89%E1%85%A5%E1%84%8C%E1%85%A5%E1%86%B72.jpg?alt=media&token=0afc7401-77d7-4b24-8c94-e7d71cfb6e0e",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%A2%8B%EC%95%84%EC%84%9C%EC%A0%90%2F%E1%84%8C%E1%85%A9%E1%87%82%E1%84%8B%E1%85%A1%E1%84%89%E1%85%A5%E1%84%8C%E1%85%A5%E1%86%B73.jpg?alt=media&token=bde0325d-b2b4-4cf6-87dd-83343a2a242e",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%A2%8B%EC%95%84%EC%84%9C%EC%A0%90%2F%E1%84%8C%E1%85%A9%E1%87%82%E1%84%8B%E1%85%A1%E1%84%89%E1%85%A5%E1%84%8C%E1%85%A5%E1%86%B74.jpg?alt=media&token=8aafde13-981b-411c-90eb-6e1d99c9ffc4",
            "https://firebasestorage.googleapis.com/v0/b/kindy-43d2d.appspot.com/o/Bookstores%2F%EC%A2%8B%EC%95%84%EC%84%9C%EC%A0%90%2F%E1%84%8C%E1%85%A9%E1%87%82%E1%84%8B%E1%85%A1%E1%84%89%E1%85%A5%E1%84%8C%E1%85%A5%E1%86%B75.jpg?alt=media&token=f9ddc97b-496e-4e41-a860-0d1e8a451ece"
        ],
        name: "좋아서점",
        address: "경북 영주시 대학로 78번길 3",
        description: "좋아서점은 무인서점으로 운영되는 독립서점 입니다. 책방에 오셔서 독립서적, LP음악들과 함께 비움의 시간을 가져 보세요.",
        contact: Contact(
            telNumber: nil,
            emailAddress: "salang6262@naver.com ",
            instagramURL: "https://www.instagram.com/like.you365/"
        ),
        businessHour: BusinessHour(
            monday: "매일 10:00 - 22:00",
            tuesday: "매일 10:00 - 22:00",
            wednesday: "매일 10:00 - 22:00",
            thursday: "매일 10:00 - 22:00",
            friday: "매일 10:00 - 22:00",
            saturday: "매일 10:00 - 22:00",
            sunday: "매일 10:00 - 22:00",
            notice: nil
        ),
        location: Location(latitude: 36.8081032, longitude: 128.6160838)
    )
]
