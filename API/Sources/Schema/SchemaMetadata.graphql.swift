// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == API.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == API.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == API.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == API.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Mutation": return API.Objects.Mutation
    case "StaffLoginResponse": return API.Objects.StaffLoginResponse
    case "Staff": return API.Objects.Staff
    case "Account": return API.Objects.Account
    case "EClinic": return API.Objects.EClinic
    case "Subscription": return API.Objects.Subscription
    case "AppointmentSchedule": return API.Objects.AppointmentSchedule
    case "Doctor": return API.Objects.Doctor
    case "Degree": return API.Objects.Degree
    case "DoctorStatistic": return API.Objects.DoctorStatistic
    case "AppointmentScheduleThirdParty": return API.Objects.AppointmentScheduleThirdParty
    case "AppointmentScheduleSendBird": return API.Objects.AppointmentScheduleSendBird
    case "ECliniAppointment": return API.Objects.ECliniAppointment
    case "ECliniWorkingTime": return API.Objects.ECliniWorkingTime
    case "ECliniWorkingTimeData": return API.Objects.ECliniWorkingTimeData
    case "ECliniWorkingTimeBlock": return API.Objects.ECliniWorkingTimeBlock
    case "Profile": return API.Objects.Profile
    case "AccountThirdParty": return API.Objects.AccountThirdParty
    case "AccountSendBird": return API.Objects.AccountSendBird
    case "Comment": return API.Objects.Comment
    case "Warehouse": return API.Objects.Warehouse
    case "MedicalExamination": return API.Objects.MedicalExamination
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
