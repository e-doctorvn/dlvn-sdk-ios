// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SubscriptionAppointmentScheduleSubscription: GraphQLSubscription {
  public static let operationName: String = "SubscriptionAppointmentSchedule"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"subscription SubscriptionAppointmentSchedule($accountId: String, $eClinicId: String) { appointmentSchedule(accountId: $accountId, eClinicId: $eClinicId) { __typename appointmentScheduleId callDuration isVideoRecord doctor { __typename fullName degree { __typename degreeId name shortName } workingRegion graduateYear doctorId avatar statistic { __typename fusionRateCustomerAverage fusionRateAnswerCount } account { __typename fullName } } thirdParty { __typename sendbird { __typename channelUrl } } eClinic { __typename appointment { __typename prepareJoin lateJoin callRingingTime } workingTimes { __typename type duration data { __typename dayOfWeek isActive blocks { __typename from to isActive } } } displayName isCloseChat eClinicId avatar title description cover slug } profile { __typename profileCode profileId avatar birthday account { __typename accountId fullName type gender sourceType deviceId accessToken thirdParty { __typename sendbird { __typename token } } } fullName relation phone } comment { __typename star content } warehouse { __typename warehouseId } package reason reasonImage scheduledAt scheduleToken createdAt updatedAt state joinNumber joinMode joinAt supportNumber medicalExamination { __typename medicalExaminationId } } }"#
    ))

  public var accountId: GraphQLNullable<String>
  public var eClinicId: GraphQLNullable<String>

  public init(
    accountId: GraphQLNullable<String>,
    eClinicId: GraphQLNullable<String>
  ) {
    self.accountId = accountId
    self.eClinicId = eClinicId
  }

  public var __variables: Variables? { [
    "accountId": accountId,
    "eClinicId": eClinicId
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { API.Objects.Subscription }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("appointmentSchedule", [AppointmentSchedule?]?.self, arguments: [
        "accountId": .variable("accountId"),
        "eClinicId": .variable("eClinicId")
      ]),
    ] }

    public var appointmentSchedule: [AppointmentSchedule?]? { __data["appointmentSchedule"] }

    /// AppointmentSchedule
    ///
    /// Parent Type: `AppointmentSchedule`
    public struct AppointmentSchedule: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.AppointmentSchedule }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("appointmentScheduleId", String?.self),
        .field("callDuration", Int?.self),
        .field("isVideoRecord", Bool?.self),
        .field("doctor", Doctor?.self),
        .field("thirdParty", ThirdParty?.self),
        .field("eClinic", EClinic?.self),
        .field("profile", Profile?.self),
        .field("comment", Comment?.self),
        .field("warehouse", Warehouse?.self),
        .field("package", GraphQLEnum<API.ProductPackageEnum>?.self),
        .field("reason", String?.self),
        .field("reasonImage", [String?]?.self),
        .field("scheduledAt", API.Date?.self),
        .field("scheduleToken", String?.self),
        .field("createdAt", API.Date?.self),
        .field("updatedAt", API.Date?.self),
        .field("state", GraphQLEnum<API.AppointmentScheduleState>?.self),
        .field("joinNumber", String?.self),
        .field("joinMode", GraphQLEnum<API.AppointmentScheduleMode>?.self),
        .field("joinAt", API.Date?.self),
        .field("supportNumber", String?.self),
        .field("medicalExamination", MedicalExamination?.self),
      ] }

      public var appointmentScheduleId: String? { __data["appointmentScheduleId"] }
      public var callDuration: Int? { __data["callDuration"] }
      public var isVideoRecord: Bool? { __data["isVideoRecord"] }
      public var doctor: Doctor? { __data["doctor"] }
      public var thirdParty: ThirdParty? { __data["thirdParty"] }
      public var eClinic: EClinic? { __data["eClinic"] }
      public var profile: Profile? { __data["profile"] }
      public var comment: Comment? { __data["comment"] }
      public var warehouse: Warehouse? { __data["warehouse"] }
      public var package: GraphQLEnum<API.ProductPackageEnum>? { __data["package"] }
      public var reason: String? { __data["reason"] }
      public var reasonImage: [String?]? { __data["reasonImage"] }
      public var scheduledAt: API.Date? { __data["scheduledAt"] }
      public var scheduleToken: String? { __data["scheduleToken"] }
      public var createdAt: API.Date? { __data["createdAt"] }
      public var updatedAt: API.Date? { __data["updatedAt"] }
      public var state: GraphQLEnum<API.AppointmentScheduleState>? { __data["state"] }
      public var joinNumber: String? { __data["joinNumber"] }
      public var joinMode: GraphQLEnum<API.AppointmentScheduleMode>? { __data["joinMode"] }
      public var joinAt: API.Date? { __data["joinAt"] }
      public var supportNumber: String? { __data["supportNumber"] }
      public var medicalExamination: MedicalExamination? { __data["medicalExamination"] }

      /// AppointmentSchedule.Doctor
      ///
      /// Parent Type: `Doctor`
      public struct Doctor: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Doctor }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("fullName", String?.self),
          .field("degree", Degree?.self),
          .field("workingRegion", String?.self),
          .field("graduateYear", Int?.self),
          .field("doctorId", String?.self),
          .field("avatar", String?.self),
          .field("statistic", Statistic?.self),
          .field("account", Account?.self),
        ] }

        public var fullName: String? { __data["fullName"] }
        public var degree: Degree? { __data["degree"] }
        public var workingRegion: String? { __data["workingRegion"] }
        public var graduateYear: Int? { __data["graduateYear"] }
        public var doctorId: String? { __data["doctorId"] }
        public var avatar: String? { __data["avatar"] }
        public var statistic: Statistic? { __data["statistic"] }
        public var account: Account? { __data["account"] }

        /// AppointmentSchedule.Doctor.Degree
        ///
        /// Parent Type: `Degree`
        public struct Degree: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.Degree }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("degreeId", String?.self),
            .field("name", String?.self),
            .field("shortName", String?.self),
          ] }

          public var degreeId: String? { __data["degreeId"] }
          public var name: String? { __data["name"] }
          public var shortName: String? { __data["shortName"] }
        }

        /// AppointmentSchedule.Doctor.Statistic
        ///
        /// Parent Type: `DoctorStatistic`
        public struct Statistic: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.DoctorStatistic }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("fusionRateCustomerAverage", Double?.self),
            .field("fusionRateAnswerCount", Int?.self),
          ] }

          public var fusionRateCustomerAverage: Double? { __data["fusionRateCustomerAverage"] }
          public var fusionRateAnswerCount: Int? { __data["fusionRateAnswerCount"] }
        }

        /// AppointmentSchedule.Doctor.Account
        ///
        /// Parent Type: `Account`
        public struct Account: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.Account }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("fullName", String?.self),
          ] }

          public var fullName: String? { __data["fullName"] }
        }
      }

      /// AppointmentSchedule.ThirdParty
      ///
      /// Parent Type: `AppointmentScheduleThirdParty`
      public struct ThirdParty: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.AppointmentScheduleThirdParty }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("sendbird", Sendbird?.self),
        ] }

        public var sendbird: Sendbird? { __data["sendbird"] }

        /// AppointmentSchedule.ThirdParty.Sendbird
        ///
        /// Parent Type: `AppointmentScheduleSendBird`
        public struct Sendbird: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.AppointmentScheduleSendBird }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("channelUrl", String?.self),
          ] }

          public var channelUrl: String? { __data["channelUrl"] }
        }
      }

      /// AppointmentSchedule.EClinic
      ///
      /// Parent Type: `EClinic`
      public struct EClinic: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.EClinic }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("appointment", Appointment?.self),
          .field("workingTimes", [WorkingTime?]?.self),
          .field("displayName", String?.self),
          .field("isCloseChat", Bool?.self),
          .field("eClinicId", String?.self),
          .field("avatar", String?.self),
          .field("title", String?.self),
          .field("description", String?.self),
          .field("cover", String?.self),
          .field("slug", String?.self),
        ] }

        public var appointment: Appointment? { __data["appointment"] }
        public var workingTimes: [WorkingTime?]? { __data["workingTimes"] }
        public var displayName: String? { __data["displayName"] }
        public var isCloseChat: Bool? { __data["isCloseChat"] }
        public var eClinicId: String? { __data["eClinicId"] }
        public var avatar: String? { __data["avatar"] }
        public var title: String? { __data["title"] }
        public var description: String? { __data["description"] }
        public var cover: String? { __data["cover"] }
        public var slug: String? { __data["slug"] }

        /// AppointmentSchedule.EClinic.Appointment
        ///
        /// Parent Type: `ECliniAppointment`
        public struct Appointment: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.ECliniAppointment }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("prepareJoin", Int?.self),
            .field("lateJoin", Int?.self),
            .field("callRingingTime", Int?.self),
          ] }

          public var prepareJoin: Int? { __data["prepareJoin"] }
          public var lateJoin: Int? { __data["lateJoin"] }
          public var callRingingTime: Int? { __data["callRingingTime"] }
        }

        /// AppointmentSchedule.EClinic.WorkingTime
        ///
        /// Parent Type: `ECliniWorkingTime`
        public struct WorkingTime: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.ECliniWorkingTime }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("type", GraphQLEnum<API.ECliniWorkingTimeEnum>?.self),
            .field("duration", Int?.self),
            .field("data", [Datum?]?.self),
          ] }

          public var type: GraphQLEnum<API.ECliniWorkingTimeEnum>? { __data["type"] }
          public var duration: Int? { __data["duration"] }
          public var data: [Datum?]? { __data["data"] }

          /// AppointmentSchedule.EClinic.WorkingTime.Datum
          ///
          /// Parent Type: `ECliniWorkingTimeData`
          public struct Datum: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { API.Objects.ECliniWorkingTimeData }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("dayOfWeek", [GraphQLEnum<API.DayOfWeek>?]?.self),
              .field("isActive", Bool?.self),
              .field("blocks", [Block?]?.self),
            ] }

            public var dayOfWeek: [GraphQLEnum<API.DayOfWeek>?]? { __data["dayOfWeek"] }
            public var isActive: Bool? { __data["isActive"] }
            public var blocks: [Block?]? { __data["blocks"] }

            /// AppointmentSchedule.EClinic.WorkingTime.Datum.Block
            ///
            /// Parent Type: `ECliniWorkingTimeBlock`
            public struct Block: API.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { API.Objects.ECliniWorkingTimeBlock }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("from", String?.self),
                .field("to", String?.self),
                .field("isActive", Bool?.self),
              ] }

              public var from: String? { __data["from"] }
              public var to: String? { __data["to"] }
              public var isActive: Bool? { __data["isActive"] }
            }
          }
        }
      }

      /// AppointmentSchedule.Profile
      ///
      /// Parent Type: `Profile`
      public struct Profile: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Profile }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("profileCode", String?.self),
          .field("profileId", String?.self),
          .field("avatar", String?.self),
          .field("birthday", API.Date?.self),
          .field("account", Account?.self),
          .field("fullName", String?.self),
          .field("relation", GraphQLEnum<API.ProfileRelation>?.self),
          .field("phone", String?.self),
        ] }

        public var profileCode: String? { __data["profileCode"] }
        public var profileId: String? { __data["profileId"] }
        public var avatar: String? { __data["avatar"] }
        public var birthday: API.Date? { __data["birthday"] }
        public var account: Account? { __data["account"] }
        public var fullName: String? { __data["fullName"] }
        public var relation: GraphQLEnum<API.ProfileRelation>? { __data["relation"] }
        public var phone: String? { __data["phone"] }

        /// AppointmentSchedule.Profile.Account
        ///
        /// Parent Type: `Account`
        public struct Account: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.Account }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("accountId", String?.self),
            .field("fullName", String?.self),
            .field("type", GraphQLEnum<API.AccountType>?.self),
            .field("gender", GraphQLEnum<API.Gender>?.self),
            .field("sourceType", String?.self),
            .field("deviceId", String?.self),
            .field("accessToken", String?.self),
            .field("thirdParty", ThirdParty?.self),
          ] }

          public var accountId: String? { __data["accountId"] }
          public var fullName: String? { __data["fullName"] }
          public var type: GraphQLEnum<API.AccountType>? { __data["type"] }
          public var gender: GraphQLEnum<API.Gender>? { __data["gender"] }
          public var sourceType: String? { __data["sourceType"] }
          public var deviceId: String? { __data["deviceId"] }
          public var accessToken: String? { __data["accessToken"] }
          public var thirdParty: ThirdParty? { __data["thirdParty"] }

          /// AppointmentSchedule.Profile.Account.ThirdParty
          ///
          /// Parent Type: `AccountThirdParty`
          public struct ThirdParty: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { API.Objects.AccountThirdParty }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("sendbird", Sendbird?.self),
            ] }

            public var sendbird: Sendbird? { __data["sendbird"] }

            /// AppointmentSchedule.Profile.Account.ThirdParty.Sendbird
            ///
            /// Parent Type: `AccountSendBird`
            public struct Sendbird: API.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: ApolloAPI.ParentType { API.Objects.AccountSendBird }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("token", String?.self),
              ] }

              public var token: String? { __data["token"] }
            }
          }
        }
      }

      /// AppointmentSchedule.Comment
      ///
      /// Parent Type: `Comment`
      public struct Comment: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Comment }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("star", Int?.self),
          .field("content", String?.self),
        ] }

        public var star: Int? { __data["star"] }
        public var content: String? { __data["content"] }
      }

      /// AppointmentSchedule.Warehouse
      ///
      /// Parent Type: `Warehouse`
      public struct Warehouse: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.Warehouse }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("warehouseId", String?.self),
        ] }

        public var warehouseId: String? { __data["warehouseId"] }
      }

      /// AppointmentSchedule.MedicalExamination
      ///
      /// Parent Type: `MedicalExamination`
      public struct MedicalExamination: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.MedicalExamination }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("medicalExaminationId", String?.self),
        ] }

        public var medicalExaminationId: String? { __data["medicalExaminationId"] }
      }
    }
  }
}
