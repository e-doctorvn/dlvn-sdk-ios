//
//  ApiQuery.swift
//  AppTestSDK
//
//  Created by Bùi Đình Mạnh on 30/11/2023.
//

import Foundation



public let dlvnAccountInit = """
    mutation DLVNAccountInit($data: String, $signature: String, $dcId: String) { dlvnAccountInit(data: $data, signature: $signature, dcId: $dcId) { phone accessToken }}
    """
public let sendbirdAccount = "query SendbirdAccount { account { accountId thirdParty { sendbird { token }}}}"

// gọi lúc nghe máy màn hình incomming
public let eClinicApproveCall: String = """
    mutation eClinicApprove($eClinicId: String!, $appointmentScheduleId: String!) {
      eClinicApprove(eClinicId: $eClinicId, appointmentScheduleId: $appointmentScheduleId) {
        appointmentScheduleId
        state
        product {
          packages {
            ... on ProductPackageVideo {
              time
              type
            }
          }
        }
      }
    }
"""

// từ chối cuộc gọi inccomming
public let eClinicExpireRinging = """
mutation eClinicExpireRinging($eClinicId: String!, $appointmentScheduleId: String!) {
  eClinicExpireRinging(eClinicId: $eClinicId, appointmentScheduleId: $appointmentScheduleId) {
    appointmentScheduleId
    state
  }
}
"""

//goi khi từ tắt cuộc goi
public let eClinicEndCall = """
mutation EClinicEndCall($eClinicId: String!, $appointmentScheduleId: String!) {
  eClinicEndCall(eClinicId: $eClinicId, appointmentScheduleId: $appointmentScheduleId) {
    appointmentScheduleId
  }
}
"""

public let AppointmentDetail = """
query AppointmentDetail($appointmentScheduleId: String) {
  appointmentSchedules(appointmentScheduleId: $appointmentScheduleId) {
    appointmentScheduleId
    eClinic {
      displayName
      eClinicId
      displayNameApp
      avatar
    }
    doctor {
      avatar
      degree {
        shortName
      }
      fullName
    }
    thirdParty {
      sendbird {
        channelUrl
      }
    }
    
  }
}
"""

public let checkAccountExist = """
query checkAccountExist($accountId: String, $phone: String) {
  checkAccountExist(accountId: $accountId, phone: $phone)
}
"""

public let AccountUpdateAggrement = """
mutation AccountUpdateAggrement($isAcceptAgreement: Date, $isAcceptShareInfo: Date) {
      accountUpdateAggrement(isAcceptAgreement: $isAcceptAgreement, isAcceptShareInfo: $isAcceptShareInfo)
    }
"""


