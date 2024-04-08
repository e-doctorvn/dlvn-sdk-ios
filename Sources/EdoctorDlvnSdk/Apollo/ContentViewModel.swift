import Apollo
import Foundation
import API

@available(iOS 14.3, *)
class ContentViewModel: ObservableObject {
    
    var activeSubscription: Cancellable?
    
    init() {
        startSubscription()
    }
    
    deinit {
        activeSubscription?.cancel()
    }
    
    func startSubscription() {
        activeSubscription = Network.shared.apollo.subscribe(subscription: API.SubscriptionAppointmentScheduleSubscription(accountId: "dev_tyncTuiOKl5kPJly", eClinicId: nil)) {result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data?.appointmentSchedule {
                    AppointmentViewModel.shared.getData()
                    print("result: ", graphQLResult.data?.appointmentSchedule)
                    if data.count > 0 {
                        var value: [AppointmentModel?] = []
                        data.forEach { element in

                            let item = AppointmentModel(avatar: element?.doctor?.doctorId, package: element?.package?.rawValue, state: element?.state?.rawValue, scheduledAt: element?.scheduledAt, doctorShortName: element?.doctor?.degree?.shortName, doctorFullName: element?.doctor?.fullName, profileFullName: element?.profile?.fullName)
                            
                            value.append(item)
                        }
 

                        AppointmentController.shared.setAppointmentSchedule(value: value)
                    }

                }

                if let errors = graphQLResult.errors {
                    print("error: ", errors)

                }
            case .failure(let error):
                print("failure: ", error)
            }
        }
    }
   
    
    
    
}
