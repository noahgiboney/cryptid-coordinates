//
//  LocationPreviewView.swift
//  CryptidCoordinates
//
//  Created by Noah Giboney on 1/16/24.
//

import MapKit
import SwiftUI

struct LocationPreviewView: View {
    
    @State private var viewModel = ViewModel()
    var nearestLocations: [HauntedLocation]
    
    
    var body: some View {
        VStack{
            
            HStack{
                Text(nearestLocations[viewModel.index].name)
                    .font(.title.bold())
                Spacer()
            }
            .padding(.vertical)
            
            HStack{
                Spacer()
                Button("Investigate") {
                    
                }
                .buttonStyle(.bordered)
            }
            .padding(.trailing, 30)
            
            HStack{
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.right")
                    
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding(.vertical, 30)
            
            Spacer()
        }
        .onAppear {
            
        }
    }
}



#Preview {
    LocationPreviewView(nearestLocations: [HauntedLocation.example, HauntedLocation.allLocations[1]])
}
