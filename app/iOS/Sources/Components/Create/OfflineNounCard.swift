//
//  OfflineNounCard.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-11-26.
//

import SwiftUI
import CoreData
import UIComponents

struct OfflineNounCard: View {
  var animation: Namespace.ID
  let noun: OfflineNoun
  
  private var dateString: String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "MMM d, YYYY"
    return dateFormatter.string(from: noun.createdDate)
  }
  
  var body: some View {
    StandardCard(
      media: {
        NounPuzzle(
          head: Image(nounTraitName: noun.head),
          body: Image(nounTraitName: noun.body),
          glass: Image(nounTraitName: noun.glasses),
          accessory: Image(nounTraitName: noun.accessory)
        )
        .matchedGeometryEffect(id: "\(noun.id)-puzzle", in: animation)
        .background(gradient)
        
      }, label: {
        VStack(alignment: .leading, spacing: 40) {
          HStack(alignment: .center) {
            Text(noun.name)
              .font(Font.custom(.bold, relativeTo: .title2))
            
            Spacer()
            
            Image.mdArrowCorner
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 35, height: 35, alignment: .center)
          }
          
          Text(dateString)
            .font(.custom(.regular, size: 15))
        }
      })
  }
  
  private var gradient: some View {
    LinearGradient(
      colors: noun.background.map { Color(hex: $0) },
      startPoint: .topLeading,
      endPoint: .bottomTrailing)
  }
}

struct OfflineNounCard_Previews: PreviewProvider {
  struct Preview: View {
    @Namespace var ns
    let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    var noun: OfflineNoun {
      let noun = OfflineNoun(context: moc)
      noun.background = ["#F8E38E", "#F6D1A8"]
      noun.name = "Benji"
      noun.createdDate = Date()
      noun.accessory = "accessory-axe"
      noun.body = "body-bege-bsod"
      noun.head = "head-ape"
      noun.glasses = "glasses-hip-rose"
      return noun
    }

    var body: some View {
      ScrollView {
        OfflineNounCard(animation: ns, noun: noun)
          .padding()
          .padding(.top, 40)
      }
      .ignoresSafeArea()
    }
  }

  static var previews: some View {
    Preview()
  }
}
