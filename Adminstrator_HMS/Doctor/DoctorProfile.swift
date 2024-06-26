//
//  DoctorProfile.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 09/05/24.
//

import SwiftUI

struct DoctorProfile: View {
    var imageUrl : String
    var fullName : String
    var specialist : String
    let doctor: DoctorModel
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @State private var isFetching = false

    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack {
                    VStack(alignment : .leading) {
                        
                        HStack {
                            if let imageUrl = URL(string: imageUrl) {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .clipped()
                                        .frame(width: 85, height: 85)
                                        .cornerRadius(50)
                                        .padding(.trailing, 5)
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .clipped()
                                        .frame(width: 85, height: 85)
                                        .cornerRadius(50)
                                        .padding(.trailing, 5)
                                        .foregroundColor(.accentColor1)
                                }
                                .frame(width: 90, height: 90)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .clipped()
                                    .frame(width: 85, height: 85)
                                    .cornerRadius(50)
                                    .padding(.trailing, 5)
                                    .foregroundColor(.accentColor1)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("\(fullName)")
                                    .font(AppFont.mediumSemiBold)
                                Text("\(specialist)")
                                    .font(AppFont.smallReg)
                                    .foregroundStyle(Color(uiColor: .secondaryLabel)).opacity(0.6)
                                    .padding(.bottom, 0.5)
                            }
                            
                        } // End of HStack
                        .padding()
                        
                        HStack {
                            
   //Fetching review of current user
                            let reviewsForSkillOwner = reviewViewModel.reviewDetails.filter { $0.doctorId == doctor.id }

                            var reviewCount = reviewViewModel.reviewDetails.filter { $0.doctorId == doctor.id }.count
                    
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                                        .frame(width: 55, height: 55)
                                    Image(systemName: "person.2.fill")
                                        .resizable()
                                        .clipped()
                                        .frame(width: 40, height: 30)
                                        .cornerRadius(50)
                                        .foregroundStyle(Color.accentColor1)
                                }
                                Text("\(reviewCount)")
                                Text("Patients")
                            }
                            
                            Spacer()
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                                        .frame(width: 55, height: 55)
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .clipped()
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(50)
                                        .foregroundColor(.accentColor1)
//                                        .padding(.trailing, 5)
                                }
                                if !reviewsForSkillOwner.isEmpty {
                                    //Calculating Average of the doctor
                                    let averageRating = reviewsForSkillOwner.reduce(0.0) { $0 + Double($1.ratingStar) } / Double(reviewsForSkillOwner.count)
                            
                                    Text("\(averageRating, specifier: "%.1f") ⭐️")
                                        .font(AppFont.smallReg)
                            
                                    Text("\(reviewsForSkillOwner.count) Review\(reviewsForSkillOwner.count == 1 ? "" : "s")")
                                        .font(AppFont.smallReg)
                                } else {
                                    Text("no")
                                    Text("reviews")
                    
                                } //else
                           
                            }//VStack
                            
                            Spacer()
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                                        .frame(width: 55, height: 55)
                                    Image(systemName: "arrow.up.right.bottomleft.rectangle.fill")
                                        .resizable()
                                        .clipped()
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(50)
//                                        .padding(.trailing, 5)
                                        .foregroundColor(.accentColor1)
                                }
                                Text(doctor.experience)
                                Text("Experience")
                            }
                            
                            
                        }
                        .padding()
                       
                        
                        
//                        Text("Select Schedule")
//                            .padding()
                        
                        VStack{
                           
                            ReviewListView(doctorId: doctor.id)
                            
                        }
                   
                        
                        
                    }  //End of VStack
                    .onAppear() {
                        reviewViewModel.fetchReviewDetail()
                        }
                    
                } // End of Scroll View
                .navigationTitle("Book Appointment")
            } //End of VStack
            .background(Color.clear)
         
            
        } //End of the navigation Stack
    }
}

//struct DoctorProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let dummyDoctor = DoctorModel(
//            id: "1",
//            fullName: "Dr. Jane Doe",
//            descript: "Expert in cardiology",
//            gender: "Female",
//            mobileno: "1234567890",
//            experience: "10 years",
//            qualification: "MD, Cardiology",
//            dob: Date(timeIntervalSince1970: 0),  // January 1, 1970
//            address: "123 Main St, Springfield",
//            pincode: "123456",
//            department: "Cardiology",
//            speciality: "Cardiologist",
//            cabinNo: "101",
//            profilephoto: nil  // Can use an actual URL if desired
//        )
//        DoctorProfile(imageUrl: "www.google.com" , fullName: "Aditya" , specialist: "specialist", doctor: dummyDoctor)
//    }
//}



struct ReviewListView: View {
    @ObservedObject var reviewViewModel = ReviewViewModel.shared
    var doctorId: String

    var body: some View {
        VStack(alignment: .leading){
            ForEach(reviewViewModel.reviewDetails) { review in
                VStack(alignment: .leading) {
                    Text("\(String(repeating: "⭐️", count: review.ratingStar))")
                        .font(AppFont.actionButton)
                    
                    Text(" \(review.comment)")
                        .font(.headline)
                }
            }
        }
        .padding()
        .onAppear {
            reviewViewModel.fetchReviewDetailByDoctorId(doctorId: doctorId)
        }
    }
}

struct ReviewListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListView(doctorId: "cXlNrV7VNYTmCmYaibqynU45Avu1")
    }
}
