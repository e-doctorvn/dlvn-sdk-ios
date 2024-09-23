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
        callDuration
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
mutation EClinicEndCall($eClinicId: String!, $appointmentScheduleId: String!, $callId: String) {
  eClinicEndCall(eClinicId: $eClinicId, appointmentScheduleId: $appointmentScheduleId, callId: $callId) {
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

public let getAppointmentSchedule = """
query Query($appointmentScheduleId: String, $accountId: String, $profileId: String, $eClinicId: String, $warehouseId: String, $state: [AppointmentScheduleState], $scheduledAt: AppointmentScheduleScheduleAt, $limit: PageLimitInput, $sort: AppointmentScheduleSort) {
      appointmentSchedules(appointmentScheduleId: $appointmentScheduleId, accountId: $accountId, profileId: $profileId, eClinicId: $eClinicId, warehouseId: $warehouseId, state: $state, scheduledAt: $scheduledAt, limit: $limit, sort: $sort) {
        appointmentScheduleId
        isVideoRecord
        callDuration
        doctor { fullName degree { degreeId shortName name } doctorId avatar account { fullName } }
        thirdParty { sendbird { channelUrl } }
        eClinic {
          doctor {
            fullName
            degree {
              shortName
            }
          }
          appointment {
            prepareJoin
            duration
            limitImmediate
            lateJoin
            callRingingTime
          }
          displayName
          eClinicId
          avatar
          title
          description
          slug
          isCloseChat
          isOpening
          workingTimes { type isOpening duration data { dayOfWeek isActive blocks { from to isActive } } }
        }
        warehouse { warehouseId title }
        product {
          title
          productId
          packages {
            ... on ProductPackageVideo {
              quantity
              time
              amount
              total
              type
              eClinicIds
            }
            ... on ProductPackageOffline {
              quantity
              amount
              total
              type
              eClinicIds
            }
            ... on ProductPackageChat {
              quantity
              time
              amount
              total
              type
              eClinicIds
            }
            ... on ProductPackageEPharmacy {
              total
              items {
                title
                itemId
                type
                amount
              }
            }
            ... on ProductPackageLaboratoryReport {
              total
              items {
                type
                itemId
                title
                amount
              }
            }
          }
        }
        profile {
          profileId
          profileCode
          birthday
          account {
            accountId
            thirdParty { sendbird { token } }
          }
          fullName
          relation
        }
        comment {
          star
          content
        }
        package
        reason
        reasonImage
        scheduledAt
        state
        joinNumber
        joinMode
        supportNumber
        medicalExamination {
          medicalExaminationId
          content
          reason
          result
          appointmentSchedule {
            appointmentScheduleId
            profile {
              profileId
              profileCode
              fullName
              relation
            }
            doctor {
              fullName
              doctorId
              degree { degreeId shortName name }
            }
            eClinic {
              eClinicId
              displayName
              avatar
            }
            supportNumber
            scheduledAt
            createdAt
          }
        }
      }
    }
"""

public let AccountUpdateAggrement = """
mutation AccountUpdateAggrement($isAcceptAgreement: Date, $isAcceptShareInfo: Date) {
      accountUpdateAggrement(isAcceptAgreement: $isAcceptAgreement, isAcceptShareInfo: $isAcceptShareInfo)
    }
"""


public let wwsGetBookingData = """
subscription subscribeToSchedule($eClinicId: String, $accountId: String) {
  appointmentSchedule(eClinicId: $eClinicId, accountId: $accountId){
    appointmentScheduleId
    doctor { fullName degree { degreeId name shortName } workingRegion graduateYear doctorId avatar statistic {
      fusionRateCustomerAverage
      fusionRateAnswerCount
    } account { fullName } }
    thirdParty { sendbird { channelUrl } }
    eClinic {
      appointment {
        prepareJoin
        lateJoin
        callRingingTime
      }
      workingTimes { type duration data { dayOfWeek isActive blocks { from to isActive } } }
      displayName
      isCloseChat
      eClinicId
      avatar
      title
      description
      cover
      slug
    }
    profile {
      profileCode
      profileId
      avatar
      birthday
      account {
        accountId
        fullName
        type
        gender
        sourceType
        deviceId
        accessToken
        thirdParty { sendbird { token } }
      }
      fullName
      relation
      phone
    }
    comment {
      star
      content
    }
    warehouse { warehouseId }
    package
    reason
    reasonImage
    scheduledAt
    scheduleToken
    createdAt
    updatedAt
    state
    joinNumber
    joinMode
    joinAt
    supportNumber
    medicalExamination {
      medicalExaminationId
    }
  }
}
"""


public let AppointmentScheduleConfirm =  """
mutation appointmentScheduleConfirm (
      $eClinicId: String!,
      $appointmentScheduleId: String!,
    ){
      eClinicJoin(
          eClinicId: $eClinicId,
          appointmentScheduleId: $appointmentScheduleId,
      ){
          appointmentScheduleId
          state
          eClinic { slug displayName }
      }
    }
"""

public let EClinicReissue =  """
mutation EClinicReissue($eClinicId: String!, $appointmentScheduleId: String!) {
      eClinicReissue(eClinicId: $eClinicId, appointmentScheduleId: $appointmentScheduleId) {
        state
        eClinic { slug displayName }
      }
    }
"""

public let AppointmentScheduleCancel =  """
mutation appointmentScheduleCancel (
      $eClinicId: String!,
      $appointmentScheduleId: String!,
    ){
      eClinicCancel(
          eClinicId: $eClinicId,
          appointmentScheduleId: $appointmentScheduleId,
      ){
          state
          appointmentScheduleId
      }
  }
"""



